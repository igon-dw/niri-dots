#!/usr/bin/env python3
"""
niri-taskbar.py
Waybar custom module that displays windows sorted by monitor position,
workspace index, and horizontal position within the workspace.

Sort key: (output.logical.x, workspace.idx, pos_in_scrolling_layout[0])

Output format (JSON for waybar):
  {"text": "<pango markup>", "tooltip": "<tooltip text>", "class": "..."}
"""

import json
import subprocess
import sys

# ---------------------------------------------------------------------------
# Nerd Font icon mapping: app_id -> icon
#
# HOW TO ADD AN APP:
#   1. Open the app, then run:  niri msg -j windows
#   2. Find the "app_id" field for that window.
#   3. Add a line below:  "that-app-id": "ICON",
#
# ICON lookup order (icon_for function):
#   a) exact match with the raw app_id
#   b) case-insensitive match (app_id.lower())
#   c) DEFAULT_ICON fallback
#
# Nerd Font cheatsheet: https://www.nerdfonts.com/cheat-sheet
# ---------------------------------------------------------------------------
APP_ICONS: dict[str, str] = {
    # Browsers
    # app_id from `niri msg -j windows`:
    #   Vivaldi       -> "vivaldi-stable"
    #   Google Chrome -> "Google-chrome"  (matched via .lower() -> "google-chrome")
    "vivaldi-stable": "󰖟",
    "vivaldi": "󰖟",
    "google-chrome": "",  # StartupWMClass=Google-chrome (.lower() hits this)
    "com.google.chrome": "",  # Flatpak variant
    "chromium": "",
    "firefox": "",
    "brave-browser": "",
    "org.mozilla.firefox": "",
    # Terminals
    "com.mitchellh.ghostty": "󰆍",
    "ghostty": "󰆍",
    "kitty": "󰄛",
    "Alacritty": "",
    "foot": "󰽒",
    "wezterm-gui": "",
    # Editors / IDEs
    "obsidian": "",
    "nvim": "",
    "neovim": "",
    "code": "󰨞",
    "code-insiders": "󰨞",
    "visual-studio-code": "󰨞",
    "zed": "",
    # File managers
    "nemo": "",
    "nautilus": "",
    "org.gnome.nautilus": "",
    "pcmanfm": "",
    "thunar": "",
    # Communication
    "discord": "󰙯",
    "slack": "󰒱",
    "teams": "󰊻",
    "geary": "󰇮",
    "thunderbird": "󰇮",
    "org.gnome.geary": "󰇮",
    # Media
    "mpv": "",
    "vlc": "󰕼",
    "spotify": "",
    "clapper": "",
    "totem": "",
    "org.gnome.totem": "",
    # Graphics / Design
    "gimp-2.99": "",
    "gimp": "",
    "inkscape": "",
    "org.inkscape.inkscape": "",
    "krita": "",
    # Settings / System
    "gnome-control-center": "󰒓",
    "org.gnome.settings": "󰒓",
    "nwg-look": "󰔉",
    "pavucontrol": "󰕾",
    "blueman-manager": "󰂯",
    "nm-connection-editor": "󰛳",
    # Gaming
    "steam": "",
    "lutris": "",
    "heroic": "",
    # Productivity
    "libreoffice-writer": "",
    "libreoffice-calc": "",
    "libreoffice-impress": "",
    "org.libreoffice.writer": "",
    "org.libreoffice.calc": "",
    "obsidian-notes": "",
    # Misc
    "clipse": "󰅌",
    "fuzzel": "󱓞",
    "loupe": "",
    "org.gnome.loupe": "",
    "wlogout": "󰤆",
}

DEFAULT_ICON = "󰘔"  # Generic window icon
SEPARATOR = "  │  "  # Visual separator between monitors


# ---------------------------------------------------------------------------
# Data fetching
# ---------------------------------------------------------------------------


def niri_json_list(subcmd: str) -> list:
    """Run `niri msg -j <subcmd>` and return parsed JSON as list."""
    result = subprocess.run(
        ["niri", "msg", "-j", subcmd], capture_output=True, text=True, check=True
    )
    return json.loads(result.stdout)  # type: ignore[return-value]


def niri_json_dict(subcmd: str) -> dict:
    """Run `niri msg -j <subcmd>` and return parsed JSON as dict."""
    result = subprocess.run(
        ["niri", "msg", "-j", subcmd], capture_output=True, text=True, check=True
    )
    return json.loads(result.stdout)  # type: ignore[return-value]


def fetch_data() -> tuple[list, list, dict]:
    """Fetch windows, workspaces, and outputs from niri."""
    windows = niri_json_list("windows")
    workspaces = niri_json_list("workspaces")
    outputs = niri_json_dict("outputs")
    return windows, workspaces, outputs


# ---------------------------------------------------------------------------
# Sort key
# ---------------------------------------------------------------------------


def build_sort_key(windows: list, workspaces: list, outputs: dict):
    """
    Return a function that maps a window dict to a sortable tuple:
      (output_x, workspace_idx, column_in_workspace)
    """
    ws_map = {ws["id"]: ws for ws in workspaces}
    output_x = {name: info["logical"]["x"] for name, info in outputs.items()}

    def key(w: dict) -> tuple:
        ws = ws_map.get(w.get("workspace_id"), {})
        out_name = ws.get("output", "")
        x = output_x.get(out_name, 99999)
        ws_idx = ws.get("idx", 99999)
        pos = w.get("layout", {}).get("pos_in_scrolling_layout") or [99999]
        col = pos[0]
        return (x, ws_idx, col)

    return key


# ---------------------------------------------------------------------------
# Rendering
# ---------------------------------------------------------------------------


def icon_for(app_id: str) -> str:
    """Return Nerd Font icon for given app_id."""
    return APP_ICONS.get(app_id, APP_ICONS.get(app_id.lower(), DEFAULT_ICON))


def render_text(
    windows: list, workspaces: list, outputs: dict
) -> tuple[str, str, bool]:
    """
    Build the Pango markup text and tooltip string.

    Returns: (text, tooltip, any_focused)
    """
    if not windows:
        return "", "No windows open", False

    ws_map = {ws["id"]: ws for ws in workspaces}
    # Sort outputs by x position to determine monitor order
    sorted_outputs = sorted(outputs.items(), key=lambda kv: kv[1]["logical"]["x"])
    output_order = [name for name, _ in sorted_outputs]

    key_fn = build_sort_key(windows, workspaces, outputs)
    sorted_windows = sorted(windows, key=key_fn)

    # Group windows by output name for separator insertion
    def get_output_name(w: dict) -> str:
        ws = ws_map.get(w.get("workspace_id"), {})
        return ws.get("output", "")

    # Build text parts, inserting separator at output boundaries
    parts: list[str] = []
    tooltip_lines: list[str] = []
    prev_output: str | None = None
    any_focused = False

    for w in sorted_windows:
        out_name = get_output_name(w)
        app_id = w.get("app_id", "")
        title = w.get("title", "")
        focused = w.get("is_focused", False)
        if focused:
            any_focused = True

        # Insert separator between monitors
        if prev_output is not None and out_name != prev_output:
            parts.append(f'<span alpha="60%">{SEPARATOR}</span>')

        icon = icon_for(app_id)

        # Focused window: bold + underline for theme-agnostic visual emphasis.
        # CSS #custom-taskbar.focused can additionally style the whole bar.
        if focused:
            parts.append(f"<span><b><u>{icon}</u></b></span>")
        else:
            parts.append(f'<span alpha="80%">{icon}</span>')

        # Tooltip: one line per window
        ws = ws_map.get(w.get("workspace_id"), {})
        ws_idx = ws.get("idx", "?")
        monitor = out_name or "?"
        tooltip_lines.append(f"[{monitor} WS{ws_idx}] {icon} {title}")

        prev_output = out_name

    text = "  ".join(parts)
    tooltip = "\n".join(tooltip_lines) if tooltip_lines else "No windows"
    return text, tooltip, any_focused


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main() -> None:
    try:
        windows, workspaces, outputs = fetch_data()
        text, tooltip, any_focused = render_text(windows, workspaces, outputs)
        css_class = ["niri-taskbar"]
        if any_focused:
            css_class.append("focused")
        output = {
            "text": text,
            "tooltip": tooltip,
            "class": css_class,
        }
        print(json.dumps(output, ensure_ascii=False))
    except subprocess.CalledProcessError as e:
        # niri not running or msg failed — output empty gracefully
        err = {"text": "", "tooltip": f"niri error: {e}", "class": "niri-taskbar-error"}
        print(json.dumps(err))
        sys.exit(0)
    except Exception as e:
        err = {"text": "⚠", "tooltip": str(e), "class": "niri-taskbar-error"}
        print(json.dumps(err))
        sys.exit(1)


if __name__ == "__main__":
    main()
