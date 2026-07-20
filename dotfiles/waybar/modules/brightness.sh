#!/bin/bash

# Author:  Alexander Levy
# Blob:    Output bar with brightness value and percentage
# Version: v0.1

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$((brightness * 100 / max_brightness))

# Format json output
echo "{\"text\":\"$percent%\"}"

