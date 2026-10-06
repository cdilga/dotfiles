// mx-gesture: Logitech MX Master gesture button on macOS without Logi Options+.
//
// The gesture button (control id 0xC3) is not a normal HID button. It only reports when software
// "diverts" it over Logitech's HID++ vendor channel, and the device forgets that on every reconnect.
// This daemon re-diverts it (with raw XY so swipes can be measured) whenever the mouse appears, then:
//   hold still >= holdDelay   -> F18 down, F18 up on release   (push-to-talk; bind your dictation app to F18)
//   hold + move > threshold   -> swipe-left/right/up/down       (runs ~/.config/mx-gesture/action <event>)
//   quick tap                 -> tap                            (same action script)
// Mirrors the Solaar rules on Omarchy (omarchy/solaar/.config/solaar/rules.yaml).

import CoreGraphics
import Foundation
import IOKit.hid

let logiVendor = 0x046D
let gestureCID: UInt16 = 0x00C3
let holdDelay = 0.20          // seconds before a still hold becomes push-to-talk
let swipeThreshold = 150      // raw counts (~4 mm at 1000 dpi)
let f18: CGKeyCode = 79
let swid: UInt8 = 0x0B        // our HID++ software id (responses echo it; device notifications use 0)
let actionScript = (NSHomeDirectory() as NSString).appendingPathComponent(".config/mx-gesture/action")

func log(_ s: String) {
  FileHandle.standardError.write("\(ISO8601DateFormatter().string(from: Date())) \(s)\n".data(using: .utf8)!)
}

func runAction(_ event: String) {
  guard FileManager.default.isExecutableFile(atPath: actionScript) else { log("no action script for \(event)"); return }
  let p = Process()
  p.executableURL = URL(fileURLWithPath: actionScript)
  p.arguments = [event]
  do { try p.run() } catch { log("action \(event) failed: \(error)") }
}

func postKey(_ code: CGKeyCode, down: Bool) {
  CGEvent(keyboardEventSource: nil, virtualKey: code, keyDown: down)?.post(tap: .cghidEventTap)
}

final class Mouse {
  let dev: IOHIDDevice
  var devIndex: UInt8 = 0xFF
  var reprogIndex: UInt8 = 0
  var statusIndex: UInt8 = 0
  var reply: [UInt8]? = nil
  let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)

  // gesture state
  var pressed = false
  var ptt = false
  var dx = 0, dy = 0
  var skipFirstMove = false
  var holdTimer: DispatchWorkItem?

  init(_ dev: IOHIDDevice) { self.dev = dev }

  var name: String { (IOHIDDeviceGetProperty(dev, kIOHIDProductKey as CFString) as? String) ?? "Logitech device" }

  // --- HID++ transport -------------------------------------------------------------------------
  func send(_ idx: UInt8, _ feature: UInt8, _ fn: UInt8, _ params: [UInt8]) -> Bool {
    var r = [UInt8](repeating: 0, count: 20)
    r[0] = 0x11; r[1] = idx; r[2] = feature; r[3] = (fn << 4) | swid
    for (i, b) in params.prefix(16).enumerated() { r[4 + i] = b }
    return IOHIDDeviceSetReport(dev, kIOHIDReportTypeOutput, 0x11, r, r.count) == kIOReturnSuccess
  }

  // Send and wait (spinning the run loop) for the matching response; nil on error/timeout.
  func request(_ idx: UInt8, _ feature: UInt8, _ fn: UInt8, _ params: [UInt8]) -> [UInt8]? {
    reply = nil
    guard send(idx, feature, fn, params) else { return nil }
    let deadline = Date().addingTimeInterval(0.6)
    while Date() < deadline {
      CFRunLoopRunInMode(.defaultMode, 0.02, true)
      if let r = reply {
        if r[2] == 0xFF || r[2] == 0x8F { return nil }        // HID++ 2.0 / 1.0 error
        if r[1] == idx && r[2] == feature && r[3] == (fn << 4) | swid { return Array(r[4...]) }
      }
    }
    return nil
  }

  func featureIndex(_ idx: UInt8, _ id: UInt16) -> UInt8? {
    guard let p = request(idx, 0x00, 0, [UInt8(id >> 8), UInt8(id & 0xFF)]), p[0] != 0 else { return nil }
    return p[0]
  }

  // Find the device slot (0xFF on Bluetooth, 1...6 behind a Bolt/Unifying receiver) and divert 0xC3.
  func arm() {
    for idx: UInt8 in [0xFF, 1, 2, 3, 4, 5, 6] {
      guard let reprog = featureIndex(idx, 0x1B04) else { continue }
      // setCidReporting: divert | dvalid | rawXY | rvalid
      guard request(idx, reprog, 3, [UInt8(gestureCID >> 8), UInt8(gestureCID & 0xFF), 0x33, 0, 0]) != nil else { continue }
      devIndex = idx; reprogIndex = reprog
      statusIndex = featureIndex(idx, 0x1D4B) ?? 0
      log("armed gesture button on \(name) (index 0x\(String(idx, radix: 16)))")
      return
    }
    log("\(name): no HID++ device with a gesture button answered; will retry on reconnect")
  }

  // --- input -----------------------------------------------------------------------------------
  func onReport(_ id: UInt32, _ bytes: UnsafeMutablePointer<UInt8>, _ len: Int) {
    var r = Array(UnsafeBufferPointer(start: bytes, count: len))
    if r.first != UInt8(id) { r.insert(UInt8(id), at: 0) }  // normalise: byte 0 is always the report id
    guard r.count >= 7, r[0] == 0x10 || r[0] == 0x11 else { return }
    if r[3] & 0x0F == swid || r[2] == 0xFF || r[2] == 0x8F { reply = r; return }
    guard r[1] == devIndex else { return }
    if r[2] == reprogIndex && r[3] == 0x00 { buttons(r) }
    else if r[2] == reprogIndex && r[3] == 0x10 { move(r) }
    else if statusIndex != 0 && r[2] == statusIndex {
      log("device reconnected/reset; re-arming")
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.arm() }
    }
  }

  func buttons(_ r: [UInt8]) {
    var cids: [UInt16] = []
    for i in stride(from: 4, to: min(12, r.count - 1), by: 2) { cids.append(UInt16(r[i]) << 8 | UInt16(r[i + 1])) }
    let down = cids.contains(gestureCID)
    if down && !pressed {
      pressed = true; ptt = false; dx = 0; dy = 0; skipFirstMove = true
      let t = DispatchWorkItem { [weak self] in
        guard let s = self, s.pressed, !s.ptt, max(abs(s.dx), abs(s.dy)) < swipeThreshold else { return }
        s.ptt = true; postKey(f18, down: true)
      }
      holdTimer = t
      DispatchQueue.main.asyncAfter(deadline: .now() + holdDelay, execute: t)
    } else if !down && pressed {
      pressed = false; holdTimer?.cancel()
      if ptt { postKey(f18, down: false); ptt = false; return }
      if max(abs(dx), abs(dy)) < swipeThreshold { runAction("tap"); return }
      runAction(abs(dx) >= abs(dy) ? (dx > 0 ? "swipe-right" : "swipe-left") : (dy > 0 ? "swipe-down" : "swipe-up"))
    }
  }

  func move(_ r: [UInt8]) {
    guard pressed, !ptt else { return }
    if skipFirstMove { skipFirstMove = false; return }   // MX Master 3S sends a bogus first delta (Solaar does the same)
    dx += Int(Int16(bitPattern: UInt16(r[4]) << 8 | UInt16(r[5])))
    dy += Int(Int16(bitPattern: UInt16(r[6]) << 8 | UInt16(r[7])))
  }
}

// --- device discovery ----------------------------------------------------------------------------
var mice: [IOHIDDevice: Mouse] = [:]
let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
IOHIDManagerSetDeviceMatchingMultiple(manager, [
  [kIOHIDVendorIDKey: logiVendor, kIOHIDDeviceUsagePageKey: 0xFF43] as CFDictionary,  // Bluetooth HID++
  [kIOHIDVendorIDKey: logiVendor, kIOHIDDeviceUsagePageKey: 0xFF00, kIOHIDDeviceUsageKey: 0x02] as CFDictionary,  // receiver long reports
] as CFArray)

let reportCB: IOHIDReportCallback = { ctx, _, _, _, id, bytes, len in
  Unmanaged<Mouse>.fromOpaque(ctx!).takeUnretainedValue().onReport(id, bytes, len)
}

IOHIDManagerRegisterDeviceMatchingCallback(manager, { _, _, _, dev in
  let m = Mouse(dev)
  mice[dev] = m
  log("found \(m.name)")
  IOHIDDeviceRegisterInputReportCallback(dev, m.buffer, 64, reportCB, Unmanaged.passUnretained(m).toOpaque())
  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { m.arm() }   // give a fresh connection a moment
}, nil)

IOHIDManagerRegisterDeviceRemovalCallback(manager, { _, _, _, dev in
  if let m = mice.removeValue(forKey: dev) {
    if m.ptt { postKey(f18, down: false) }   // never leave F18 stuck down
    log("lost \(m.name)")
  }
}, nil)

if !IOHIDRequestAccess(kIOHIDRequestTypeListenEvent) { log("needs Input Monitoring permission") }
if !CGPreflightPostEventAccess() { _ = CGRequestPostEventAccess(); log("needs Accessibility permission to send F18") }

IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
let rc = IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
if rc != kIOReturnSuccess { log("IOHIDManagerOpen failed: 0x\(String(UInt32(bitPattern: rc), radix: 16))") }
log("mx-gesture running; waiting for devices")
CFRunLoopRun()
