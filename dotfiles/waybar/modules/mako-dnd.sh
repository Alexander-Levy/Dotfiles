#!/usr/bin/env bash

# Author:  Alexander Levy
# Blob:    Toggle do not disturb mode for mako
# Version: v1.0

if makoctl mode | grep -q '^do-not-disturb$'; then
    printf '{"text":"","tooltip":"Do Not Disturb: ON","class":"dnd"}\n'
else
    printf '{"text":"","tooltip":"Do Not Disturb: OFF","class":"normal"}\n'
fi
