if status is-interactive
    # Commands to run in interactive sessions can go here
    # enable starship
    starship init fish | source
    zoxide init fish | source
end

# Suppress default fish greeting
set -g fish_greeting

# Set EDITOR
set -gx EDITOR nvim

# Set BROWSER
set -gx BROWSER vivaldi

# abbr settings
# Set-up icons for files/folders in terminal using eza
abbr ls 'eza -a --icons'
abbr ll 'eza -al --icons'
abbr lt2 'eza -a --tree --level=2 --icons --ignore-glob=".git|node_modules"'
abbr lt3 'eza -a --tree --level=3 --icons --ignore-glob=".git|node_modules"'
abbr lt4 'eza -a --tree --level=4 --icons --ignore-glob=".git|node_modules"'
abbr lt5 'eza -a --tree --level=5 --icons --ignore-glob=".git|node_modules"'

# Change directory easily with fzf and fd
abbr cdf 'cd (fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf)'

# launch apps easily
abbr lzg lazygit

# cvim is a command to launch a customized Neovim (e.g., cvim), but currently there are no specific settings.
abbr cvim 'NVIM_APPNAME=cvim nvim'

# Abbreviation for encoding an AV1 video clip from input.mp4 using VAAPI GPU acceleration; time range (-ss/-to) is customizable
abbr ffclip 'ffmpeg -hide_banner -y -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 -ss 00:00:00 -to 00:01:00 -i input.mp4 -vf "format=nv12,hwupload" -c:v av1_vaapi -qr 18 -c:a aac -b:a 192k output_clip.mp4'

# Abbreviation for launching github copilot CLI tool
abbr cplt copilot
abbr cpltr 'copilot --resume'

# Abbreviation for launching opencode
abbr oc 'opencode'

## Abbreviation for lauching tty-clock
abbr ttc 'tty-clock -sc -C 6 -t'

# Add ~/.local/bin to PATH for user scripts
fish_add_path ~/.local/bin

# Add ~/Desktop/Scripts to PATH for easy script execution
fish_add_path ~/Desktop/Scripts/

# LSP, linter, fomatter via mason.nvim
fish_add_path ~/.local/share/nvim/mason/bin/

# Load all custom functions from ~/.config/fish/functions/
for file in ~/.config/fish/functions/*.fish
    source $file
end

# ROCm related settings
# ROCm/HIP environment variables
set -gx AMD_SERIALIZE_KERNEL 1
set -gx HSA_OVERRIDE_GFX_VERSION 11.0.0
set -gx PYTORCH_HIP_ALLOC_CONF max_split_size_mb:64
set -gx HIP_LAUNCH_BLOCKING 1
set -gx HSA_ENABLE_SDMA 0

# Use fnm (Fast Node Manager) for managing Node.js versions
# This is initialization for fnm
fnm env --use-on-cd | source
