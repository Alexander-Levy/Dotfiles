#!/usr/bin/env bash

# Author: Alexander Levy
# Blob:   The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir. Asumes arch linux, will not work with debian and 
# fedora based systems.

version="v0.4.1"
# ChangeLog: .4.0 Added hyprland overview plugin install bit 
#            .4.1 reformated code for core change

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Script #################################################################
banner "Levy's dotfiles installer..." "$version Testing release"
update_system # Update packages & database before starting the script 
aur_helper_check # Install aur helper if one is not found

# Verify that the necessary packages are installed 
section "Checking packages..."
for pkg in "${packages[@]}"; do
    if $aur_helper -Q "$pkg" &>/dev/null; then
        log ok   "  [OKAY] $pkg"
    else
        log warn "  [MISS] $pkg"
        missing+=("$pkg")
    fi
done
install_missing_packages # Install missing packages, exit early if fails

# Symlink configurtations 
section "Syncing files..."
symlink "Wallpapers" "$current_path" "$wallpaper_path"
for dir in "$dotfiles_path"/*/; do
    symlink "$(basename "$dir")" "$dotfiles_path" "$config_path/$(basename "$dir")" 
done

# Setup Hyprland overview plugin
hyprpm add https://github.com/yayuuu/hyprland-scroll-overview.git
hyprpm update
hyprpm enable scrolloverview

