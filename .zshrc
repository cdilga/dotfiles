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
# LAZY LOAD CONDA (saves ~0.8s)
# Self-contained wrapper for Claude Code shell snapshot compatibility
# ============================================================================
conda() {
  unset -f conda
  __conda_setup="$('/Users/cdilga/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/Users/cdilga/anaconda3/etc/profile.d/conda.sh" ]; then
      . "/Users/cdilga/anaconda3/etc/profile.d/conda.sh"
    else
      export PATH="/Users/cdilga/anaconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
  conda "$@"
}

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
