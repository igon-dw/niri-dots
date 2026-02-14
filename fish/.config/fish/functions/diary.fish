function diary --description "Manage daily journal entries"
    # --- Configuration ---
    if not set -q EDITOR_CMD
        set -g EDITOR_CMD nvim
    end
    set -l BASE_DIR "$HOME/CloudShare/LazyNotes/Journals"

    # --- Main Logic ---
    set -l YEAR (date +%Y)
    set -l MONTH (date +%m)
    set -l DATE_STAMP (date +%Y%m%d)

    # Determine the quarter of the year
    set -l QUARTER
    if test $MONTH -ge 1 -a $MONTH -le 3
        set QUARTER Q1
    else if test $MONTH -ge 4 -a $MONTH -le 6
        set QUARTER Q2
    else if test $MONTH -ge 7 -a $MONTH -le 9
        set QUARTER Q3
    else
        set QUARTER Q4
    end

    set -l TARGET_DIR $BASE_DIR/$YEAR"_"$QUARTER

    # --- Directory Handling ---
    if not test -d "$TARGET_DIR"
        echo "Directory does not exist: $TARGET_DIR"
        echo -n "Create it? (y/N): "
        read answer
        if string match -q -i y "$answer"
            mkdir -p "$TARGET_DIR"
            if test $status -ne 0
                echo "Error: Failed to create directory. Aborting." >&2
                return 1
            end
            echo "Directory created."
        else
            echo "Cancelled."
            return 0
        end
    end

    # --- Option Handling ---
    if test (count $argv) -gt 0; and test "$argv[1]" = -today
        set -l FILE_PATH "$TARGET_DIR/"$DATE_STAMP"_diary.md"
        if not test -f "$FILE_PATH"
            echo "# $DATE_STAMP" > "$FILE_PATH"
            echo "Created file: $FILE_PATH"
        else
            echo "File already exists: $FILE_PATH"
        end
        
        # Change to target directory
        cd "$TARGET_DIR"
        
        # Open file with editor
        echo "Opening $FILE_PATH with $EDITOR_CMD..."
        if not $EDITOR_CMD "$FILE_PATH"
            echo "Error: Failed to open editor." >&2
            return 1
        end
    else
        # Without option, only change directory
        cd "$TARGET_DIR"
    end
end
