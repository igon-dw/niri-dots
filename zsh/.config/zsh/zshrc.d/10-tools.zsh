export ABBR_QUIETER=1
export ABBR_USER_ABBREVIATIONS_FILE=/dev/null

if command -v sheldon >/dev/null 2>&1; then
  eval "$(sheldon source)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

if [[ $- == *i* ]]; then
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh 2>/dev/null
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh 2>/dev/null
fi

if command -v fzf >/dev/null 2>&1; then
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
  elif command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules}/**"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    unset FZF_ALT_C_COMMAND
  fi

  export FZF_DEFAULT_OPTS="--layout=reverse --info=inline --height=80% --multi --preview-window=':hidden' --bind '?:toggle-preview' --bind 'ctrl-a:select-all' --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'"
fi
