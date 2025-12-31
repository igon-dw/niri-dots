# Kitty Terminal Configuration

This directory contains the Kitty terminal emulator configuration with dynamic theme switching support.

## 📁 Directory Structure

```
kitty/.config/kitty/
├── README.md                      # English documentation (this file)
├── README.ja.md                   # Japanese documentation
├── THEMES.md                      # Theme information and attribution
├── kitty.conf                     # Main Kitty configuration file
├── current-theme.conf             # Symlink to active theme (auto-generated, not in Git)
├── themes/                        # Available color schemes (12 themes)
│   ├── ayu.conf
│   ├── catppuccin.conf
│   ├── earthsong.conf
│   ├── everforest.conf
│   ├── flatland.conf
│   ├── gruvbox.conf
│   ├── night-owl.conf
│   ├── nord.conf
│   ├── palenight.conf
│   ├── shades-of-purple.conf
│   ├── solarized.conf
│   └── tokyo-night.conf
└── scripts/                       # Theme management utilities
    ├── switch-theme.sh            # Theme switching script (auto-initializes on first run)
    └── list-themes.sh             # List available themes
```

## 🎨 Available Themes

Unified with Waybar theme collection, **file names match exactly (excluding extensions)**:

- **Ayu** - Orange and blue accents with high contrast. Excellent visibility for coding work (Default: Earthsong)
- **Catppuccin** - Lavender and pink pastels. Easy on the eyes with a soft impression, ideal for long sessions
- **Earthsong** - Beige and brown natural tones. Calming warm colors perfect for focused work (Default)
- **Everforest** - Forest-inspired green palette. Low contrast design reduces eye strain during extended terminal use
- **Flatland** - Gray-based minimalist design. Clean and professional look suitable for business environments
- **Gruvbox** - Yellow, orange, and green warm retro colors. High contrast and popular among programmers
- **Night Owl** - Deep blue-purple background with bright accents. Designed for night work with reduced blue light
- **Nord** - Blue and gray cool color palette. Cool, calm impression inspired by Nordic winter
- **Palenight** - Purple and pink Material Design style. Modern and polished, suitable for design work
- **Shades of Purple** - Bold use of vivid purple. Distinctive and impressive, perfect for creative environments
- **Solarized** - Scientifically designed 16-color palette. Optimized contrast ratios reduce eye fatigue
- **Tokyo Night** - Deep navy with neon colors. Modern and stylish theme capturing Tokyo's nighttime atmosphere

> **Note**: Waybar has an additional `original` theme, but Kitty does not have a corresponding theme.

## 🚀 Usage

### Method 1: Interactive Mode (fuzzel)

Run the script without arguments to select a theme with fuzzel:

```bash
~/.config/kitty/scripts/switch-theme.sh
```

This displays all themes from the `themes/` directory in fuzzel's dmenu. Desktop notifications confirm the theme change.

**Note**: On first run, `switch-theme.sh` automatically initializes `current-theme.conf` with the default theme (Earthsong).

### Method 2: Command Line Arguments

Specify the theme name directly:

```bash
~/.config/kitty/scripts/switch-theme.sh catppuccin
~/.config/kitty/scripts/switch-theme.sh tokyo-night
~/.config/kitty/scripts/switch-theme.sh nord
~/.config/kitty/scripts/switch-theme.sh gruvbox
~/.config/kitty/scripts/switch-theme.sh everforest
~/.config/kitty/scripts/switch-theme.sh ayu
```

### Method 3: Unified Theme Switcher (Recommended)

**Switch themes for Waybar, Kitty, and Niri all at once** using the unified script:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

This script:

1. Shows Waybar theme list in fuzzel
2. Automatically applies the selected theme to Waybar
3. Automatically applies to Kitty if a matching theme exists
4. Prompts for manual selection if Kitty theme doesn't exist
5. Shows notification when complete

> **Tip**: Theme names are unified between Waybar and Kitty, so most themes apply to both automatically.

### Method 4: List Available Themes

To view available themes:

```bash
# Formatted output (current theme marked with *)
~/.config/kitty/scripts/list-themes.sh

# Simple output (for scripts)
~/.config/kitty/scripts/list-themes.sh --simple
```

Example formatted output:

```
Available themes:

  * earthsong (current)
    flatland
    solarized
    gruvbox
    nord
    tokyo-night
    catppuccin
    ayu
    everforest
    night-owl
    palenight
    shades-of-purple
```

## 🔧 How Theme Switching Works

### Hybrid Approach with Stow

This configuration uses a **hybrid approach** combining symlinks and Kitty's remote control:

1. **Stow Management**: Main configuration files are managed by stow
   - `kitty.conf` → symlinked from niri-dots
   - `themes/*.conf` → symlinked from niri-dots
   - `scripts/*.sh` → symlinked from niri-dots

2. **Dynamic Theme Link**: `current-theme.conf` is a relative symlink
   - Created by scripts (not managed by Git)
   - Points to `./themes/<ThemeName>.conf`
   - This creates a symlink chain: `current-theme.conf` → `themes/X.conf` → actual file

3. **Auto-initialization**: First run automatically creates `current-theme.conf`
   - No manual setup required after stow
   - Defaults to Earthsong theme

4. **Live Updates**: When switching themes:
   - Updates the `current-theme.conf` symlink
   - Applies to running Kitty instances via remote control API
   - New Kitty windows/tabs automatically use the new theme

5. **Notifications**: Shows change confirmation via `notify-send` (requires mako or dunst)

### Why Symlink Chain Works

```
~/.config/kitty/current-theme.conf (script-generated symlink)
    ↓
~/.config/kitty/themes/earthsong.conf (stow symlink)
    ↓
~/niri-dots/kitty/.config/kitty/themes/earthsong.conf (actual file)
```

Linux handles this transparently. Kitty reads through the chain to get the final file content.

## 📝 Main Configuration

The `kitty.conf` includes:

- **Font**: JetBrainsMono Nerd Font Mono (14pt)
- **Opacity**: 0.8 background transparency
- **Theme**: Dynamically loaded via `include ./current-theme.conf`
- **Keybindings**:
  - `Shift+Ctrl+Return`: New tab
  - `Shift+Ctrl+H`: Previous tab
  - `Shift+Ctrl+L`: Next tab
- **Remote Control**: Enabled for live theme switching

## ➕ Adding New Themes

1. Create a new `.conf` file in the `themes/` directory:

   ```sh
   # Example theme file format
   cat > themes/myTheme.conf << EOF
   background            #282420
   foreground            #e5c6a8
   cursor                #f6f6ec
   selection_background  #111417
   color0                #111417
   color1                #f22c40
   color2                #5ab738
   color3                #d5911a
   color4                #407ee7
   color5                #6666ea
   color6                #00ad9c
   color7                #a8a19f
   color8                #766e6b
   color9                #f22c40
   color10               #5ab738
   color11               #d5911a
   color12               #407ee7
   color13               #6666ea
   color14               #00ad9c
   color15               #f1efee
   EOF
   ```

2. **Waybar Integration (Recommended)**: If using unified theme switching, also add a Waybar theme with the same name:

   ```bash
   # Create Waybar theme (different format for color variables)
   nano ~/niri-dots/waybar/.config/waybar/themes/myTheme.css
   ```

3. Commit to Git:

   ```sh
   git add themes/myTheme.conf
   git commit -m "Add myTheme color scheme"
   ```

4. Switch to the new theme:

   ```sh
   ~/.config/kitty/scripts/switch-theme.sh myTheme
   ```

### Required Color Settings

New themes require the following settings:

- `background` - Background color
- `foreground` - Foreground color (text)
- `cursor` - Cursor color
- `selection_background` - Selection background color
- `color0` ~ `color15` - 16-color palette (ANSI colors)

## 🔧 Dependencies

### Required

- `kitty` - Terminal emulator itself
- `ln` - Symlink creation (standard Unix tool)

### Recommended

- `fuzzel` - For interactive theme selection
- `mako` or `dunst` - For desktop notifications (notify-send)
- `pgrep` - Process checking (standard Unix tool)

Even without fuzzel or mako, you can switch themes via command line arguments.

## 💡 Tips

### Niri Keybinding Configuration

You can bind theme switching to a key in the Niri configuration file (`~/.config/niri/config.kdl`):

```kdl
binds {
    // Kitty theme switching only
    Mod+Shift+T { spawn "sh" "-c" "~/.config/kitty/scripts/switch-theme.sh"; }

    // Unified theme switching (Waybar + Kitty + Niri)
    Mod+T { spawn "sh" "-c" "~/.config/niri/scripts_for_niri/change-all-themes.sh"; }
}
```

### Check Current Theme

```bash
readlink ~/.config/kitty/current-theme.conf
# Output: ./themes/earthsong.conf
```

Or:

```bash
~/.config/kitty/scripts/list-themes.sh
```

### Using rofi Instead

If you prefer rofi over fuzzel, change `fuzzel --dmenu` to `rofi -dmenu` in the `switch-theme.sh` script.

### Manual Config Reload

If theme doesn't apply immediately:

```bash
# Reload config manually
kitty @ load-config

# Or restart Kitty
```

## 🔗 Stow Integration

This configuration is designed to work seamlessly with GNU Stow:

1. **Before stow**: Files are in `~/niri-dots/kitty/.config/kitty/`
2. **After stow**: Files are symlinked to `~/.config/kitty/`
3. **Generated file**: `current-theme.conf` is auto-created on first theme switch (Git-ignored via root `.gitignore`)

### Stow Commands

```bash
# Apply configuration
cd ~/niri-dots
stow kitty

# Theme is automatically initialized on first use
~/.config/kitty/scripts/switch-theme.sh

# Remove configuration
cd ~/niri-dots
stow -D kitty
```

### Git Integration

The dynamically generated `current-theme.conf` is excluded from Git via the root `.gitignore` file:

```gitignore
waybar/.config/waybar/style.css
kitty/.config/kitty/current-theme.conf
```

## 🐛 Troubleshooting

### "current-theme.conf: No such file or directory"

Simply run the switch script (it auto-initializes):

```bash
~/.config/kitty/scripts/switch-theme.sh
```

### Theme Not Applying to Running Instances

Check if Kitty's remote control is enabled:

```bash
kitty @ ls
```

If you get an error, add the following to `kitty.conf`:

```conf
allow_remote_control yes
listen_on unix:/tmp/kitty
```

Then restart Kitty.

### Theme Files Not Found

Check theme directory contents:

```bash
ls -la ~/.config/kitty/themes/
```

Verify stow symlinks are created correctly:

```bash
ls -la ~/.config/kitty/
```

### Notifications Not Appearing

Check if notification daemon is running:

```bash
pgrep -x mako  # or pgrep -x dunst
```

**Understanding the output:**

- **Number displayed** (e.g., 1234) → Notification daemon is running ✓
- **No output** → Notification daemon is not running ✗

How to start the notification daemon (mako or dunst) varies by distribution and setup. Please refer to the following resources for your environment:

- [Mako Official Documentation](https://github.com/emersion/mako)
- [Dunst Official Documentation](https://dunst-project.org/)

### Script Not Executable

Check if scripts are executable and grant permissions if needed:

```bash
chmod +x ~/.config/kitty/scripts/*.sh
```

## 📚 Resources

- [Kitty Official Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Remote Control](https://sw.kovidgoyal.net/kitty/remote-control/)
- [Kitty Color Themes](https://github.com/kovidgoyal/kitty-themes)
- [Niri Compositor](https://github.com/YaLTeR/niri)

## 🎓 Theme Attribution

For detailed information about all included themes, their sources, licenses, and authors, please see [THEMES.md](./THEMES.md).

Key points:

- Most themes are sourced from official repositories or the [kovidgoyal/kitty-themes](https://github.com/kovidgoyal/kitty-themes) collection
- All themes include source/upstream information in their file headers
- Two themes (Palenight, Shades of Purple) are custom adaptations based on waybar theme colors
- All themes are licensed under MIT or compatible open-source licenses

## 🔗 Unified Theme System

This Kitty configuration is part of the niri-dots repository's unified theme system.

### Theme Consistency

- **Waybar**: 13 themes (ayu, catppuccin, earthsong, everforest, flatland, gruvbox, night-owl, nord, **original**, palenight, shades-of-purple, solarized, tokyo-night)
- **Kitty**: 12 themes (same as above except `original`)
- **File Name Consistency**: Names match exactly excluding extensions

### Unified Script Operation

`change-all-themes.sh` works as follows:

1. Uses Waybar theme list as reference (13 themes)
2. Applies selected theme to Waybar via fuzzel
3. Auto-applies to Kitty if matching theme exists
4. Prompts for manual selection if Kitty theme doesn't exist (`original` case)
5. Shows success notification when both apply successfully

### Adding New Themes to Unified System

To add a new theme to the unified theme system:

1. **Create Waybar theme**: `waybar/.config/waybar/themes/newtheme.css`
2. **Create Kitty theme**: `kitty/.config/kitty/themes/newtheme.conf`
3. **Unify file names**: Use the same name excluding extension
4. **Commit to Git**: Commit both files
5. **Test with unified script**: Verify with `change-all-themes.sh`

This maintains consistent color themes across your entire desktop environment.

## 📄 License

This configuration is part of the [niri-dots](https://github.com/igon-dev/niri-dots) repository.
