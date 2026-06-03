#!/bin/bash

# Author:  Alexander Levy
# Blob:    Output volumen bar for waybar
# Version: v0.1

# Get raw volume and convert to int
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
vol_int=$(echo "$vol_raw * 100" | bc | awk '{ print int($1) }')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false) # Check mute status

# Icon logic
if [ "$is_muted" = true ]; then
  icon=""
  vol_int=0
elif [ "$vol_int" -lt 50 ]; then
  icon=""
else
  icon=""
fi

# Create ASCII bar
filled=$((vol_int / 10))
empty=$((10 - filled))
if [[ $filled -eq 0 ]]; then
    bar=''
else
    bar=$(printf '█%.0s' $(seq 1 $filled))
fi
if [[ $empty -eq 0 ]]; then
    pad=''
else 
    pad=$(printf '░%.0s' $(seq 1 $empty))
fi
ascii_bar="[$bar$pad]"

# Final JSON output
echo "{\"text\":\" $icon  $vol_int%$ascii_bar \"}"

