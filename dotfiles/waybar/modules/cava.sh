#!/bin/bash

# Author:  Alexander Levy
# Blob:    Shitty script to display audio visually
# Version: v0.1

# Variables
msg_length=14
chars=('▁' '▂' '▃' '▄' '▅' '▆' '▇' '█')

cava -p ~/.config/waybar/modules/cava | while IFS= read -r line; do
    # To hide when paused change to "$status" != "Playing"
    status=$(playerctl status 2>/dev/null) # Check if something is actively playing
    if [[ "$status" == "No players found" || "$status" == "" ]]; then
        # echo "{\"text\": \"\", \"class\": \"hidden\"}"
        echo ""
        continue
    fi

    output=""
    IFS=';' read -ra bars <<< "$line"
    for bar in "${bars[@]}"; do
        bar="${bar//[^0-9]/}"
        [[ -n "$bar" ]] && output+="${chars[$bar]}"
    done

    full=$(playerctl metadata --format '{{artist}} - {{title}}          ' 2>/dev/null)
    scroll_pos=$(( $(date +%s) % ${#full} ))
    track="${full:$scroll_pos:$msg_length}${full:0:$scroll_pos}"
    track="${track:0:$msg_length}"
    # echo "{\"text\": \" $output \", \"class\": \"cava\"}"
    echo " $track $output "
done

