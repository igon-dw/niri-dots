# Project-local zsh entry point for `nix develop`.

for config_file in "$ZDOTDIR"/zshrc.d/*.zsh(N); do
  source "$config_file"
done

[[ -f "$ZDOTDIR/options.zsh" ]] && source "$ZDOTDIR/options.zsh"
