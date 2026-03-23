#!/bin/bash

# Get current windows, workspaces, and outputs as JSON
windows=$(niri msg --json windows)
workspaces=$(niri msg --json workspaces)
outputs=$(niri msg --json outputs)

# Use jq -s (slurp) to load all three JSONs as an array
selected_line=$(jq -r -s '
  .[0] as $windows |
  .[1] as $workspaces |
  .[2] as $outputs |

  # 1. Mapping table for display names (add or edit as needed)
  {
    "vivaldi-stable": "Vivaldi",
    "com.mitchellh.ghostty": "Ghostty",
    "org.gnome.Totem": "Videos",
    "google-chrome": "Google Chrome",
    "code-url-handler": "VS Code",
    "firefox": "Firefox",
    "code": "VS Code",
    "org.gnome.Geary": "Geary",
    "obsidian": "Obsidian",
    "org.upscayl.Upscayl": "Upscayl",
    "org.gnome.Loupe": "Loupe",
    "org.gnome.Meld": "Meld",
    "org.gnome.World.PikaBackup": "Pika Backup",
    "org.kde.kdenlive": "Kdenlive",
    "org.pulseaudio.pavucontrol": "Pavucontrol",
    "mousepad": "Mousepad",
    "steam": "Steam",
    "onlyoffice-desktopeditors": "ONLYOFFICE",
    "org.musicbrainz.Picard": "Picard",
    "dev.zed.Zed": "Zed",
    "kitty": "Kitty",
    "Alacritty": "Alacritty",
    "nemo": "Nemo",
    "com.obsproject.Studio": "OBS Studio",
    "virt-manager": "Virt-Manager",
    "blueman-manager": "Blueman",
    "losslesscut-bin": "LosslessCut",
    "1password": "1Password",
    "mpv": "mpv",
    "org.gnome.Solanum": "Solanum"
  } as $name_map |

  # 2. Mapping table for icons (add entries for non-standard app_id/icon pairs)
  {
    "vivaldi-stable": "vivaldi",
    "code-url-handler": "vscode",
  } as $icon_map |

  # 3. Build a dictionary workspace_id → {idx, output}
  ($workspaces | map({key: (.id|tostring), value: {idx: .idx, output: .output}}) | from_entries) as $ws_dict |

  # 4. Prepare window data and add sort key
  $windows |
  map(
    . as $w |
    ($ws_dict[$w.workspace_id | tostring]) as $ws_info |
    ($ws_info.output // "") as $out_name |
    
    # Sort key logic: (output x coordinate, workspace idx, column position)
    ($outputs[$out_name].logical.x // 99999) as $out_x |
    ($ws_info.idx // 99999) as $ws_idx |
    (.layout.pos_in_scrolling_layout[0] // 99999) as $col |

    # Add extra fields to each window object
    . + {
      _sort_key: [$out_x, $ws_idx, $col],
      _display_name: ($name_map[.app_id] // .app_id),
      _icon_name: ($icon_map[.app_id] // .app_id)
    }
  ) |
  
  # 5. Sort windows using sort key (output position, workspace order, column)
  sort_by(._sort_key) |
  
  # 6. Create formatted output for fuzzel
  .[] |
  
   # Pad ID to 5 chars (right align), Pad & Truncate application name to exactly 15 chars (left align)
   ((.id | tostring | ("     " + .)[-5:]) as $padded_id |
    ((._display_name + "               ")[0:15]) as $padded_name |
    "\($padded_id) │ \($padded_name) │ \(.title)\u0000icon\u001f\(._icon_name)"
   )

' <(echo "$windows") <(echo "$workspaces") <(echo "$outputs") | fuzzel --dmenu -i -w 100 -l 20 -p "Select Window:")

# Exit if selection is cancelled
if [ -z "$selected_line" ]; then
	exit 0
fi

# Extract window ID from selected line (first field, whitespace delimited)
window_id=$(echo "$selected_line" | awk '{print $1}')

# Focus selected window
if [ -n "$window_id" ]; then
	niri msg action focus-window --id "$window_id"
fi
