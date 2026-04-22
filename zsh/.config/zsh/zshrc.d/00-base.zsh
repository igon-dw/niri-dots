typeset -U path fpath

path=(
  "$HOME/.local/bin"
  /usr/sbin
  /usr/local/sbin
  $path
)

[[ -d "$HOME/Desktop/Scripts" ]] && path=("$HOME/Desktop/Scripts" $path)
[[ -d "$HOME/.local/share/nvim/mason/bin" ]] && path=("$HOME/.local/share/nvim/mason/bin" $path)

export EDITOR=nvim
export BROWSER=vivaldi

export AMD_SERIALIZE_KERNEL=1
export HSA_OVERRIDE_GFX_VERSION=11.0.0
export PYTORCH_HIP_ALLOC_CONF=max_split_size_mb:64
export HIP_LAUNCH_BLOCKING=1
export HSA_ENABLE_SDMA=0

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

setopt autocd
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt no_hist_verify

bindkey -e
bindkey -r '^S' 2>/dev/null
bindkey '^[s' history-incremental-search-forward

fpath=("$ZDOTDIR/functions" $fpath)
autoload -Uz compinit jnal spf
compinit -d "$HOME/.zcompdump"

# Enable fish-like completion:
# - case-insensitive matches
# - substring matches
# - subsequence-style fuzzy matches such as `dcnts` -> `Documents`
zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*' \
  'r:|?=**'
