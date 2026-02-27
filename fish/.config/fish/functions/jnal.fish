function jnal --description "Daily journal management tool"
    # --- Configuration paths ---
    set -l state_dir "$HOME/.local/state/jnal"
    set -l config_file "$state_dir/base_dir"
    set -l template_config "$state_dir/template"
    
    # Check EDITOR is set
    if not set -q EDITOR
        echo "Error: \$EDITOR environment variable is not set." >&2
        echo "Set it in your config.fish: set -gx EDITOR <your-editor>" >&2
        return 1
    end
    set -l editor_cmd $EDITOR

    # --- Helper: get quarter from month ---
    function _jnal_get_quarter
        set -l month $argv[1]
        if test $month -ge 1 -a $month -le 3
            echo Q1
        else if test $month -ge 4 -a $month -le 6
            echo Q2
        else if test $month -ge 7 -a $month -le 9
            echo Q3
        else
            echo Q4
        end
    end

    # --- Helper: ensure directory exists ---
    function _jnal_ensure_dir
        set -l dir $argv[1]
        if not test -d "$dir"
            echo "Directory does not exist: $dir"
            echo -n "Create it? (y/N): "
            read answer
            if string match -q -i y "$answer"
                mkdir -p "$dir"
                if test $status -ne 0
                    echo "Error: Failed to create directory. Aborting." >&2
                    return 1
                end
                echo "Directory created."
            else
                echo "Cancelled."
                return 1
            end
        end
        return 0
    end

    # --- Helper: configure template file ---
    function _jnal_configure_template
        set -l prompt_text $argv[1]
        set -l state_dir $argv[2]
        set -l template_config $argv[3]
        
        echo "$prompt_text"
        echo ""
        echo "Enter the path to your journal template file."
        echo "Example: ~/Documents/journal_template.md"
        echo ""
        echo "Leave empty to use no template (header only)."
        echo ""
        read -P "Template file (optional): " template_input

        # Allow empty input (no template)
        if test -z "$template_input"
            mkdir -p "$state_dir"
            echo "" > "$template_config"
            echo ""
            echo "Configuration saved: No template (header only)"
            return 0
        end

        # Expand tilde
        set -l new_template (string replace -r '^~' $HOME $template_input)

        # Verify file exists
        if not test -f "$new_template"
            echo ""
            echo "Warning: File does not exist: $new_template"
            read -P "Save this path anyway? (y/N): " answer
            if not string match -q -i y "$answer"
                echo "Cancelled."
                return 1
            end
        end

        # Save configuration
        mkdir -p "$state_dir"
        echo "$new_template" > "$template_config"
        echo ""
        echo "Configuration saved to: $template_config"
        echo "Template file: $new_template"

        return 0
    end

    # --- Helper: configure base directory ---
    function _jnal_configure_base_dir
        set -l prompt_text $argv[1]
        set -l state_dir $argv[2]
        set -l config_file $argv[3]
        
        echo "$prompt_text"
        echo ""
        echo "Enter the base directory for your journals."
        echo "Example: ~/Documents/Journals"
        echo ""
        read -P "Base directory: " base_dir_input

        if test -z "$base_dir_input"
            echo "Cancelled."
            return 1
        end

        # Expand tilde
        set -l new_base_dir (string replace -r '^~' $HOME $base_dir_input)

        # Verify or create directory
        if not test -d "$new_base_dir"
            echo ""
            echo "Directory does not exist: $new_base_dir"
            read -P "Create it? (y/N): " answer
            if string match -q -i y "$answer"
                mkdir -p "$new_base_dir"
                if test $status -ne 0
                    echo "Error: Failed to create directory." >&2
                    return 1
                end
                echo "Directory created."
            else
                echo "Cancelled."
                return 1
            end
        end

        # Save configuration
        mkdir -p "$state_dir"
        echo "$new_base_dir" > "$config_file"
        echo ""
        echo "Configuration saved to: $config_file"
        echo "Base directory: $new_base_dir"

        return 0
    end

    # --- Parse option ---
    set -l action navigate
    if test (count $argv) -gt 0
        switch $argv[1]
            case -t --today
                set action today
            case -s --stats
                set action stats
            case -h --help
                set action help
            case --config
                set action config
            case --set-template
                set action set_template
            case --show-config
                set action show_config
            case '*'
                echo "Error: Unknown option '$argv[1]'" >&2
                echo "Use 'jnal --help' for usage information." >&2
                return 1
        end
    end

    # --- Action: help ---
    if test "$action" = help
        echo "Usage: jnal [OPTION]"
        echo ""
        echo "Manage daily journal entries organized by year and quarter."
        echo ""
        echo "Options:"
        echo "  (none)           Navigate to current quarter directory"
        echo "  -t, --today      Create/open today's journal entry"
        echo "  -s, --stats      Show journal statistics by quarter and month"
        echo "  -h, --help       Show this help message"
        echo ""
        echo "Configuration:"
        echo "  --config         Change base directory interactively"
        echo "  --set-template   Change template file interactively"
        echo "  --show-config    Display current configuration"
        echo ""
        echo "Environment Variables:"
        echo "  EDITOR           Editor to use (required)"
        echo ""
        echo "Files:"
        echo "  ~/.local/state/jnal/base_dir    Base directory configuration"
        echo "  ~/.local/state/jnal/template    Template file configuration"
        return 0
    end

    # --- Action: config ---
    if test "$action" = config
        _jnal_configure_base_dir "jnal: Change configuration" "$state_dir" "$config_file"
        return $status
    end

    # --- Action: set-template ---
    if test "$action" = set_template
        _jnal_configure_template "jnal: Set template file" "$state_dir" "$template_config"
        return $status
    end

    # --- Load base directory ---
    set -l base_dir
    if test -f "$config_file"
        set base_dir (string trim (cat "$config_file"))
    end

    # --- Load template file ---
    set -l template_file
    if test -f "$template_config"
        set template_file (string trim (cat "$template_config"))
    end

    # --- Action: show-config ---
    if test "$action" = show_config
        echo "=== jnal Configuration ==="
        echo ""
        
        # Base directory
        echo "Base Directory:"
        if test -n "$base_dir"
            echo "  Path:   $base_dir"
            echo "  Config: $config_file"
            if test -d "$base_dir"
                echo "  Status: ✓ Directory exists"
            else
                echo "  Status: ✗ Directory does not exist"
            end
        else
            echo "  Status: Not configured"
            echo "  Run 'jnal --config' to set up."
        end
        
        echo ""
        
        # Template file
        echo "Template File:"
        if test -n "$template_file"
            echo "  Path:   $template_file"
            echo "  Config: $template_config"
            if test -f "$template_file"
                echo "  Status: ✓ File exists"
            else
                echo "  Status: ✗ File does not exist"
            end
        else
            echo "  Status: Not configured (header only)"
            echo "  Run 'jnal --set-template' to set up."
        end
        
        return 0
    end

    # --- First-time setup ---
    if test -z "$base_dir"
        _jnal_configure_base_dir "jnal: First-time setup" "$state_dir" "$config_file"
        or return 1
        
        # Reload base_dir after configuration
        if test -f "$config_file"
            set base_dir (string trim (cat "$config_file"))
        else
            echo "Error: Configuration file was not created." >&2
            return 1
        end
    end

    # Verify base_dir is valid
    if not test -d "$base_dir"
        echo "Error: Configured base directory does not exist: $base_dir" >&2
        echo "Run 'jnal --config' to reconfigure." >&2
        return 1
    end

    # --- Action: stats ---
    if test "$action" = stats
        echo "=== Journal Statistics ==="
        echo ""

        # Quarter statistics - collect and sort properly
        echo "Entries by Quarter:"
        set -l quarter_dirs (find "$base_dir" -maxdepth 1 -type d -name "*_Q[1-4]" | sort -r)
        for quarter_dir in $quarter_dirs
            set -l count (find "$quarter_dir" -name "*_diary.md" -type f 2>/dev/null | wc -l | string trim)
            set -l quarter_name (basename "$quarter_dir")
            printf "  %-10s: %3d entries\n" $quarter_name $count
        end

        echo ""
        echo "Entries by Month (last 12 months):"

        # Collect all diary files from last 12 months, ordered newest to oldest
        for i in (seq 0 11)
            set -l month_date (date -d "$i months ago" +%Y%m)
            set -l month_name (date -d "$i months ago" +"%b %Y")
            set -l count (find "$base_dir" -name "$month_date*_diary.md" -type f 2>/dev/null | wc -l | string trim)
            printf "  %-10s: %3d entries\n" $month_name $count
        end

        return 0
    end

    # --- Resolve target directory ---
    set -l year (date +%Y)
    set -l month (date +%m)
    set -l date_stamp (date +%Y%m%d)
    set -l quarter (_jnal_get_quarter (math "$month"))
    set -l target_dir "$base_dir/$year"_"$quarter"

    _jnal_ensure_dir "$target_dir"; or return 1

    # --- Action: today ---
    if test "$action" = today
        set -l file_path "$target_dir/$date_stamp"_diary.md

        if not test -f "$file_path"
            # Create header
            echo "# $date_stamp" > "$file_path"
            echo "" >> "$file_path"
            
            # Append template content if available and valid
            if test -n "$template_file" -a -f "$template_file"
                cat "$template_file" >> "$file_path"
                echo "Created file with header + template: $file_path"
            else
                echo "Created file with header only: $file_path"
            end
        else
            echo "File already exists: $file_path"
        end

        cd "$target_dir"

         echo "Opening $file_path with $editor_cmd..."
         $editor_cmd "$file_path"
        if test $status -ne 0
            echo "Error: Failed to open editor." >&2
            return 1
        end

        return 0
    end

    # --- Action: navigate (default) ---
    cd "$target_dir"
end
