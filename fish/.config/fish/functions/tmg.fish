function tmg --description "Search and expand command templates with fzf"
    # --- Configuration ---
    set -l template_file ~/.config/fish/command_templates.yml

    # --- Check dependencies ---
    if not command -v fzf >/dev/null
        echo "Error: fzf is not installed." >&2
        return 1
    end
    if not command -v yq >/dev/null
        echo "Error: yq is not installed." >&2
        return 1
    end
    if not test -f "$template_file"
        echo "Error: Template file not found at $template_file" >&2
        return 1
    end

    # --- Execute fzf ---
    # Extract descriptions with yq and pass to fzf
    # Call helper function `_tmg_preview` to generate preview based on selected description
    # If fzf is cancelled (exit code non-zero), exit without doing anything
    set -l selected_description (yq '.[].description' "$template_file" | fzf --height 60% --layout=reverse --border \
        --preview "fish -c '_tmg_preview \$argv[1]' -- {}" \
        --preview-window='right:60%:wrap')

    if test $status -ne 0
        return
    end

    # --- Expand command ---
    # Extract corresponding command using yq based on selected description
    set -l command_to_insert (yq "map(select(.description == \"$selected_description\")) | .[0].command" "$template_file")

    # Insert extracted command into current command line
    commandline -i "$command_to_insert"
end
