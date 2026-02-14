function pacrs --description "Write a log entry to pkgs_log.csv"
    if type -q yay
        echo "Running with yay command."
        set pkg_mgr yay
    else if type -q paru
        echo "Running with paru command."
        set pkg_mgr paru
    else
        echo "Required command not found."
        exit 1
    end

    set csv_file ~/pkgs_log.csv

    # Get date and time (UTC)
    set today (date -u +%Y-%m-%dT%H:%M:%S)

    # Check if CSV file exists, create if not
    if not test -e $csv_file
        touch $csv_file
        echo 'package,date,event' >$csv_file
    end

    # Append arguments to CSV file
    for package in $argv
        if $pkg_mgr -Rs $package
            printf '"%s",%s,\"remove\"\n' $package $today >>$csv_file
        else
            echo "Failed to remove $package"
        end
    end
end
