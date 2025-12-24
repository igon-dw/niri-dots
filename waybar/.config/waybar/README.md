# Waybar Theme Switcher

This directory contains configuration for Waybar with an easy-to-use theme switching system.

## 📁 Directory Structure

```
waybar/.config/waybar/
├── config.jsonc           # Waybar modules and layout configuration
├── base.css               # Theme-independent style definitions
├── style.css              # Main CSS file (dynamically generated, not in Git)
├── style.css.template     # CSS template (in Git)
├── scripts_for_waybar/    # Waybar scripts
│   ├── switch-theme.sh    # Theme switching script
│   ├── get-current-theme.sh  # Get current theme name
│   └── get-mpris.sh       # Get media player info
└── themes/                # Theme definitions directory
    ├── ayu.css
    ├── catppuccin.css
    ├── earthsong.css
    ├── everforest.css
    ├── flatland.css
    ├── gruvbox.css
    ├── night-owl.css
    ├── nord.css
    ├── original.css
    ├── palenight.css
    ├── shades-of-purple.css
    ├── solarized.css
    └── tokyo-night.css
```

## 🎨 Available Themes

- **Ayu** - Orange and blue accents with high contrast. Excellent visibility for coding work
- **Catppuccin (Mocha)** - Lavender and pink pastels. Easy on the eyes with a soft impression, ideal for long sessions
- **Earthsong** - Beige and brown natural tones. Calming warm colors perfect for focused work
- **Everforest** - Forest-inspired green palette. Low contrast design reduces eye strain during extended terminal use
- **Flatland** - Gray-based minimalist design. Clean and professional look suitable for business environments
- **Gruvbox** - Yellow, orange, and green warm retro colors. High contrast and popular among programmers
- **Night Owl** - Deep blue-purple background with bright accents. Designed for night work with reduced blue light
- **Nord** - Blue and gray cool color palette. Cool, calm impression inspired by Nordic winter
- **Original** - Repository-specific custom theme. Well-balanced general-purpose color scheme
- **Palenight** - Purple and pink Material Design style. Modern and polished, suitable for design work
- **Shades of Purple** - Bold use of vivid purple. Distinctive and impressive, perfect for creative environments
- **Solarized Dark** - Scientifically designed 16-color palette. Optimized contrast ratios reduce eye fatigue
- **Tokyo Night** - Deep navy with neon colors. Modern and stylish theme capturing Tokyo's nighttime atmosphere

## 🚀 Usage

### Method 1: Interactive Mode (fuzzel)

Run the script without arguments to select a theme with fuzzel:

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
```

This displays all themes from the `themes/` directory in fuzzel's dmenu. Desktop notifications confirm the theme change.

### Method 2: Command Line Arguments

Specify the theme name directly:

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
~/.config/waybar/scripts_for_waybar/switch-theme.sh nord
~/.config/waybar/scripts_for_waybar/switch-theme.sh catppuccin
~/.config/waybar/scripts_for_waybar/switch-theme.sh tokyo-night
~/.config/waybar/scripts_for_waybar/switch-theme.sh ayu
~/.config/waybar/scripts_for_waybar/switch-theme.sh everforest
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

> **Tip**: Theme names are unified between Waybar and Kitty (except Waybar's `original`), so most themes apply to both automatically.

### Method 4: From Waybar Theme Button

Click the `custom/theme` module defined in `config.jsonc` to display the theme switching menu. The current theme name is also displayed.

### Method 5: Manual Edit (Not Recommended)

You can edit the `@import` line in `style.css.template` and generate style.css from the template, but using the script is recommended.

```css
@import "themes/gruvbox.css"; /* Change this line */
@import "base.css";
```

## 🔧 How Theme Switching Works

1. **Template-based**: Dynamically generates `style.css` from `style.css.template` based on selected theme
2. **Auto-restart**: Automatically restarts Waybar after theme change to apply changes
3. **Notifications**: Shows change confirmation via `notify-send` (requires mako or dunst)
4. **Git management**: `style.css` is in `.gitignore` and dynamically generated, avoiding conflicts

## 📦 Waybar Modules

Current configuration includes the following modules:

### Left Side

- `custom/appmenu` - Application launcher (fuzzel)
- `cpu` - CPU usage
- `temperature` - CPU temperature
- `disk` - Disk usage
- `memory` - Memory usage
- `custom/gpu` - GPU information
- `wlr/taskbar` - Taskbar

### Center

- `clock` - Clock
- `niri/workspaces` - Workspaces
- `custom/makoDismiss` - Dismiss all notifications

### Right Side

- `custom/mpris` - Media player information
- `custom/theme` - Current theme display and theme switcher
- `niri/language` - Keyboard layout
- `tray` - System tray
- `pulseaudio` - Volume control
- `custom/wlogout` - Logout menu

## ➕ Adding New Themes

1. Create a new `.css` file in the `themes/` directory
2. Use an existing theme file as a template
3. Define all `@define-color` variables (see complete list below)
4. The script automatically detects the new theme

### Required Color Variables (Complete List)

New themes must define all of the following variables:

#### Basic Colors

```css
@define-color bar_bg                  /* Bar overall background color */
@define-color module_bg               /* Module background color */
@define-color module_border           /* Module border color */
@define-color global_fg               /* Overall text color */
@define-color tooltip_bg              /* Tooltip background */
@define-color tooltip_border          /* Tooltip border */
```

#### App Menu

```css
@define-color appmenu_fg              /* App menu text color */
@define-color appmenu_hover_fg        /* App menu hover text color */
```

#### System Monitoring Modules

```css
@define-color cpu_fg                  /* CPU text color */
@define-color temperature_fg          /* Temperature text color */
@define-color disk_fg                 /* Disk text color */
@define-color gpu_fg                  /* GPU text color */
@define-color memory_fg               /* Memory text color */
```

#### Taskbar

```css
@define-color taskbar_btn_bg          /* Taskbar button background */
@define-color taskbar_btn_border      /* Taskbar button border */
@define-color taskbar_btn_hover_bg    /* Taskbar hover background */
@define-color taskbar_btn_hover_border /* Taskbar hover border */
@define-color taskbar_btn_active_bg   /* Taskbar active background */
@define-color taskbar_btn_active_border /* Taskbar active border */
```

#### Clock

```css
@define-color clock_fg                /* Clock text color */
```

#### System Tray

```css
@define-color tray_hover_fg           /* Tray hover text color */
```

#### Logout Button

```css
@define-color logout_fg               /* Logout text color */
@define-color logout_hover_fg         /* Logout hover text color */
```

#### Menu Items

```css
@define-color menuitem_fg             /* Menu text color */
@define-color menuitem_bg             /* Menu background */
@define-color menuitem_hover_bg       /* Menu hover background */
@define-color menuitem_hover_fg       /* Menu hover text color */
```

#### Theme Button

```css
@define-color theme_fg                /* Theme button text color */
```

#### Media Player

```css
@define-color mpris_fg                /* MPRIS text color */
```

```css
@define-color language_bg            /* Language display background */
@define-color language_hover_bg; /* Language display hover background */
```

#### Volume Control

```css
@define-color pulseaudio_bg          /* Volume background */
@define-color pulseaudio_hover_bg; /* Volume hover background */
```

#### Media Player

```css
@define-color mpris_fg               /* MPRIS text color */
@define-color mpris_bg               /* MPRIS background */
@define-color mpris_hover_bg; /* MPRIS hover background */
```

## 🔧 Dependencies

### Required

- `sed` - Text processing (standard Unix tool)
- `pkill` - Process management (standard Unix tool)
- `waybar` - Status bar itself

### Recommended

- `fuzzel` - For interactive theme selection
- `mako` or `dunst` - For desktop notifications (notify-send)
- `btop` or `htop` - System monitor (launched when clicking modules)
- `wlogout` - For logout menu

Even without fuzzel or mako, you can switch themes via command line arguments.

## 💡 Tips

### Niri Keybinding Configuration

You can bind theme switching to a key in the Niri configuration file (`~/.config/niri/config.kdl`):

```kdl
binds {
    // Waybar theme switching only
    Mod+Shift+T { spawn "sh" "-c" "~/.config/waybar/scripts_for_waybar/switch-theme.sh"; }

    // Unified theme switching (Waybar + Kitty + Niri)
    Mod+T { spawn "sh" "-c" "~/.config/niri/scripts_for_niri/change-all-themes.sh"; }
}
```

### Get Current Theme Name

The `get-current-theme.sh` script retrieves the currently applied theme name:

```bash
~/.config/waybar/scripts_for_waybar/get-current-theme.sh
```

This script is also used by the `custom/theme` module.

### Using rofi Instead

If you prefer rofi over fuzzel, change `fuzzel --dmenu` to `rofi -dmenu` in the `switch-theme.sh` script.

### Unified Theme Switching Details

The unified script works in the following order:

1. List available themes from Waybar's theme directory
2. Select via fuzzel
3. Apply theme to Waybar (auto-restart)
4. Check if Kitty theme file with same name exists
5. Auto-apply if exists, prompt manual selection if not
6. Show unified notification when all successful

**Theme Name Consistency:**

- Waybar: 13 themes (ayu, catppuccin, earthsong, everforest, flatland, gruvbox, night-owl, nord, **original**, palenight, shades-of-purple, solarized, tokyo-night)
- Kitty: 12 themes (same as above except `original`)
- File names match exactly (excluding extensions)

## 📝 Technical Details

### CSS Architecture

- Uses GTK-compatible `@define-color` for color management
- Modular structure with `@import` directives
- Theme files (`themes/*.css`) contain only color variable definitions
- Layout and style definitions consolidated in `base.css`
- Theme files are completely independent for easy maintenance

### Script Operation

1. Uses `style.css.template` as base
2. Replaces `@import` line according to theme selection
3. Generates new `style.css`
4. Restarts Waybar to apply changes
5. Shows notification via notify-send

### Benefits of Template Approach

- No Git conflicts (style.css not managed)
- Easy setup in new environments
- No backup files needed
- Idempotency guaranteed

## 🐛 Troubleshooting

### Theme Not Applying

Try restarting Waybar manually:

```bash
pkill -x waybar && waybar &
```

### fuzzel Not Working

Check if fuzzel is installed:

```bash
command -v fuzzel
```

If not installed, specify theme via command line arguments.

### Script Not Executable

Check if scripts are executable and grant permissions if needed:

```bash
chmod +x ~/.config/waybar/scripts_for_waybar/*.sh
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

### style.css Not Generated

Check if template file exists:

```bash
ls -la ~/.config/waybar/style.css.template
```

If it doesn't exist, retrieve it from the repository.

### custom/theme Module Not Working

Check if `get-current-theme.sh` script is executable:

```bash
~/.config/waybar/scripts_for_waybar/get-current-theme.sh
```

## 📚 Resources

- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar Configuration](https://github.com/Alexays/Waybar/wiki/Configuration)
- [Waybar Styling](https://github.com/Alexays/Waybar/wiki/Styling)
- [Niri Compositor](https://github.com/YaLTeR/niri)

## 🔗 Unified Theme System

This Waybar configuration is part of the niri-dots repository's unified theme system.

### Theme Consistency

Waybar and Kitty themes have **unified file names (excluding extensions)**:

| Theme Name       | Waybar | Kitty |
| ---------------- | ------ | ----- |
| ayu              | ✓      | ✓     |
| catppuccin       | ✓      | ✓     |
| earthsong        | ✓      | ✓     |
| everforest       | ✓      | ✓     |
| flatland         | ✓      | ✓     |
| gruvbox          | ✓      | ✓     |
| night-owl        | ✓      | ✓     |
| nord             | ✓      | ✓     |
| original         | ✓      | ✗     |
| palenight        | ✓      | ✓     |
| shades-of-purple | ✓      | ✓     |
| solarized        | ✓      | ✓     |
| tokyo-night      | ✓      | ✓     |

### Adding New Themes to Unified System

To add a new theme to the unified theme system:

1. **Create Waybar theme**: `waybar/.config/waybar/themes/newtheme.css`
   - Define all required color variables (see complete list above)
2. **Create Kitty theme**: `kitty/.config/kitty/themes/newtheme.conf`
   - Define background, foreground, cursor, selection_background, color0-15
3. **Unify file names**: Use the same name excluding extension (e.g., `newtheme`)
4. **Commit to Git**: Commit both files
5. **Test with unified script**: Verify with `change-all-themes.sh`

This maintains consistent color themes across your entire desktop environment.

## 📄 License

This configuration is part of the [niri-dots](https://github.com/igon-dev/niri-dots) repository.
