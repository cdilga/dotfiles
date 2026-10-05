# OPENSPEC:START
# OpenSpec shell completions configuration (compinit called once below)
fpath=("/Users/cdilga/.oh-my-zsh/custom/completions" $fpath)
# OPENSPEC:END

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# CORE ZSH SETTINGS
# ============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Fast completion (skip security audit, use cache)
autoload -Uz compinit && compinit -C -u

# Prefer the keychain-backed `gh` login for this Mac over inherited process env.
unset GH_TOKEN
unset GITHUB_TOKEN

# ============================================================================
# PATH SETUP (fast, no subshells)
# ============================================================================
typeset -U path  # unique entries only
path=(
  "$HOME/.pyenv/bin"
  "$HOME/.lmstudio/bin"
  "$HOME/.local/bin"
  $path
)

# ============================================================================
# GIT ALIASES (replaces oh-my-zsh git plugin)
# ============================================================================
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push'
alias gst='git status'
alias gsw='git switch'

# Keep NTM aliases/completions aligned with the installed binary.
if command -v ntm >/dev/null 2>&1; then
  eval "$(ntm shell zsh)"
fi

# Claude Code with type-ahead capture
alias cc='/Users/cdilga/Documents/dev/dilger-toolbox/claude-wrapper.sh'

# ============================================================================
# LAZY LOAD NVM (saves ~1.5s)
# Self-contained wrappers for Claude Code shell snapshot compatibility
# ============================================================================
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  nvm "$@"
}
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  node "$@"
}
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  npm "$@"
}
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  npx "$@"
}

# ============================================================================
# LAZY LOAD PYENV (saves ~0.5s) - only if installed
# Self-contained wrappers for Claude Code shell snapshot compatibility
# ============================================================================
export PYENV_ROOT="$HOME/.pyenv"

if [[ -x "$PYENV_ROOT/bin/pyenv" ]]; then
  pyenv() {
    unset -f pyenv python python3 pip pip3
    eval "$("$PYENV_ROOT/bin/pyenv" init -)"
    eval "$("$PYENV_ROOT/bin/pyenv" virtualenv-init -)"
    pyenv "$@"
  }
  python() {
    unset -f pyenv python python3 pip pip3
    eval "$("$PYENV_ROOT/bin/pyenv" init -)"
    eval "$("$PYENV_ROOT/bin/pyenv" virtualenv-init -)"
    python "$@"
  }
  python3() {
    unset -f pyenv python python3 pip pip3
    eval "$("$PYENV_ROOT/bin/pyenv" init -)"
    eval "$("$PYENV_ROOT/bin/pyenv" virtualenv-init -)"
    python3 "$@"
  }
  pip() {
    unset -f pyenv python python3 pip pip3
    eval "$("$PYENV_ROOT/bin/pyenv" init -)"
    eval "$("$PYENV_ROOT/bin/pyenv" virtualenv-init -)"
    pip "$@"
  }
  pip3() {
    unset -f pyenv python python3 pip pip3
    eval "$("$PYENV_ROOT/bin/pyenv" init -)"
    eval "$("$PYENV_ROOT/bin/pyenv" virtualenv-init -)"
    pip3 "$@"
  }

  alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
fi

# ============================================================================
# SHELL ENHANCEMENTS
# ============================================================================
# Autosuggestions (ghost text from history)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Tab accepts suggestion if exists, otherwise normal completion
_tab_or_complete() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle expand-or-complete
  fi
}
zle -N _tab_or_complete
bindkey '^I' _tab_or_complete

# History substring search (type partial command, then Up/Down to filter)
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up    # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow
bindkey '^P' history-substring-search-up      # Ctrl+P (vim style)
bindkey '^N' history-substring-search-down    # Ctrl+N (vim style)

# fzf (fuzzy finder: Ctrl+R for history, Ctrl+T for files)
# Cached: regenerate with `fzf --zsh > ~/.cache/zsh/fzf.zsh`
source ~/.cache/zsh/fzf.zsh

# zoxide (smart cd: use 'z' instead of 'cd', learns your habits)
# Cached: regenerate with `zoxide init zsh > ~/.cache/zsh/zoxide.zsh`
source ~/.cache/zsh/zoxide.zsh

# ============================================================================
# POWERLEVEL10K
# ============================================================================
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/Users/cdilga/.bun/_bun" ] && source "/Users/cdilga/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Prefer the source-built beads_rust binary from ~/.local/bin.
unalias br 2>/dev/null  # br installer - remove conflicting alias

# >>> MCP Agent Mail alias (DISABLED by Rust installer on 2026-04-07T07:55:56Z)
# if [[ ":$PATH:" != *":/Users/cdilga/.local/bin:"* ]]; then
#   export PATH="/Users/cdilga/.local/bin:$PATH"
# fi
# Rust binary installed at: /Users/cdilga/.local/bin/am
# To restore Python version: uncomment the alias line(s) above
# <<< MCP Agent Mail alias (DISABLED)

# >>> MCP Agent Mail alias (DISABLED by Rust installer on 2026-04-07T07:55:56Z)
# alias bd='br'
# Rust binary installed at: /Users/cdilga/.local/bin/am
# To restore Python version: uncomment the alias line(s) above
# <<< MCP Agent Mail alias (DISABLED)

# >>> MCP Agent Mail alias (DISABLED by Rust installer on 2026-04-07T07:55:56Z)
# alias am='/Users/cdilga/.local/bin/am'
# Rust binary installed at: /Users/cdilga/.local/bin/am
# To restore Python version: uncomment the alias line(s) above
# <<< MCP Agent Mail alias (DISABLED)

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/cdilga/.lmstudio/bin"
# End of LM Studio CLI section

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# kimi-code
export PATH="/Users/cdilga/.kimi-code/bin:$PATH"

# dcg: warn if hook was silently removed from Claude Code settings
if command -v dcg &>/dev/null && command -v jq &>/dev/null; then
  if [ -f "$HOME/.claude/settings.json" ] && \
     ! jq -e '.hooks.PreToolUse[]? | select(.hooks[]?.command | test("dcg\"?$"))' \
       "$HOME/.claude/settings.json" &>/dev/null; then
    printf '\033[1;33m[dcg] Hook missing from ~/.claude/settings.json — run: dcg install\033[0m\n'
  fi
fi

# Machine-specific / secret config (untracked; see README)
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
