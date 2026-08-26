#!/usr/bin/env bash

makoctl history -j |
    jq -r '
        .[] |
        [
            .id,
            (.app_name // "Unknown"),
            (.summary // ""),
            (.body // "")
        ] |
        @tsv
    ' |
    while IFS="$(printf '\t')" read -r id app summary body; do
        # Collapse newlines in notification bodies
        body=$(printf '%s' "$body" | tr '\n' ' ')

        # Keep the notification compact
        if [ -n "$body" ]; then
            printf '%s\t%s — %s: %s\n' \
                "$app" "$summary" "$body"
        else
            printf '%s\t%s — %s\n' \
                "$app" "$summary"
        fi
    done |
    wofi \
        --dmenu \
        --allow-images \
        --parse-search \
        --prompt "Notifications" \
        --width 1500 \
        --height 1000 \
        --image-size 48 \
        --cache-file /dev/null \
        # --no-actions
