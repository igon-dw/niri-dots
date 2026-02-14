function weblio --description "Search word on Weblio (Japanese dictionary)"
    # Error handling when no argument is passed
    if test -z "$argv[1]"
        echo "Usage: weblio <word>" >&2
        return 1
    end

    # Open Weblio search results in Firefox
    firefox -private-window https://ejje.weblio.jp/content/"$argv[1]"
end
