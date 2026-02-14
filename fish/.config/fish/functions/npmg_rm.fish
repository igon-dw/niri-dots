function npmg_rm --description "Uninstall npm package globally with sudo and log to pkgs_log.csv"
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
        if sudo npm uninstall -g $package
            printf '"%s",%s,"npm_remove"\n' $package $today >>$csv_file
        else
            echo "Failed to remove $package"
        end
    end
end
