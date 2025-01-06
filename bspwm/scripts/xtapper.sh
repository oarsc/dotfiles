#!/bin/bash

pipe="/tmp/bspwm-xtapper-pipe"

if [[ ! -p $pipe ]]; then
    rm "$pipe"
    mkfifo "$pipe"
    notify-send "Creating pipe $pipe"
fi

function xTapper {
    execution="${1%"${1##*[![:space:]]}"}" # trim spaces at the end
    
    pids=$(pgrep -f "$(basename "$execution")$")
    if [ "$(echo "$pids" | wc -w)" -gt 1 ]; then
        if fuser "$pipe" &>/dev/null; then
            echo "$execution" > "$pipe"
        fi
        exit 0
    elif fuser "$pipe" &>/dev/null; then
        echo "QUIT" > "$pipe"
    fi
    
    response=$($2)

    i=3
    while [ $i -le $# ]; do
        eval "timeout=\${$i}"

        if read -t $timeout msg <>"$pipe"; then
            if [[ "$msg" == "$execution" ]]; then
                eval "fun=\${$((i + 1))}"
                response=$($fun $response)
                ((i+=2))
                continue
            fi
        fi
        break
    done
}

function clear_xTapper {
    if fuser "$pipe" &>/dev/null; then
        echo "QUIT" > "$pipe"
    fi
}
