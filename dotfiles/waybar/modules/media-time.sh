#!/usr/bin/env bash

# Author:  Alexander Levy
# Blob:    Audio playing time info
# Version: v0.1

playerctl metadata --format '{{duration(position)}}/{{duration(mpris:length)}} ' 2>/dev/null

