function flat_rm --description "Write a log entry to pkgs_log.csv"
    # CSV file path
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
        if flatpak uninstall $package
            printf '"%s",%s,\"flatpak_uninstall\"\n' $package $today >>$csv_file
        else
            echo "Failed to uninstall $package"
        end
    end
end
