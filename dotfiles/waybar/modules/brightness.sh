#!/bin/bash

# Author:  Alexander Levy
# Blob:    Output bar with brightness value and percentage
# Version: v0.1

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$((brightness * 100 / max_brightness))

# Create ASCII bar
filled=$((percent / 10))
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

# Format json output
echo "{\"text\":\"$percent%$ascii_bar \"}"

