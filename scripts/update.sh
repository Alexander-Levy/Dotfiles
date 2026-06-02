#!/usr/bin/env bash

# Author: Alexander Levy
# Blob:   Update configuration files

# Paths
current_path="$(realpath "../$(dirname "$0")")"
dotfiles_path="$current_path/dotfiles"
config_path="$HOME/.config"
wallpaper_path="$HOME/Wallpapers"
backup_path="$HOME/.dotfiles-backup"

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Script #################################################################
banner "Levy's dotfiles updater..." ""

# Symlink configurtations 
section "Syncing files..."
for dir in "$dotfiles_path"/*/; do
    symlink "$(basename "$dir")" "$dotfiles_path" "$config_path/$(basename "$dir")" 
done
symlink "Wallpapers" "$current_path" "$wallpaper_path" # symlink wallpapers

