#!/bin/bash
# Sync CLIPBOARD to PRIMARY, one-way only

last_clipboard=""

while true; do
    # Read current clipboard content safely
    current=$(xclip -o -selection clipboard 2>/dev/null || echo "")

    # If the content changed, update PRIMARY
    if [[ "$current" != "$last_clipboard" ]]; then
        echo -n "$current" | xclip -i -selection primary
        last_clipboard="$current"
    fi

    sleep 0.4
done
