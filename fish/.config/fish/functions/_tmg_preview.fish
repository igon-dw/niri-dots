function _tmg_preview --description "Generate fzf preview for tmg function"
    # --- Configuration ---
    set -l template_file ~/.config/fish/command_templates.yml

    # --- Receive argument (selected description) ---
    set -l selected_description $argv[1]

    # --- Generate preview content ---

    # Extract `details` element from file. Return empty string if not found.
    set -l details (yq "map(select(.description == \"$selected_description\")) | .[0].details // \"\"" "$template_file")

    # Display details if not empty
    if test -n "$details"
        echo "📖 Details:"
        echo -----------
        echo "$details"
        echo "" # newline
    end

    # Extract `command` element and display with bat
    set -l command_text (yq "map(select(.description == \"$selected_description\")) | .[0].command" "$template_file")
    echo "💻 Command:"
    echo -----------

    if command -v bat >/dev/null
        echo "$command_text" | bat --language sh --style=plain --color=always
    else
        echo "$command_text"
    end
end
