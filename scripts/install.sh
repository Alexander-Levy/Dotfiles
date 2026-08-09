#!/usr/bin/env bash

# Author: Alexander Levy
# Blob:   The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir. Asumes arch linux, will not work with debian and 
# fedora based systems.

version="v0.4.2"
# ChangeLog: .4.0 Added hyprland overview plugin install bit 
#            .4.1 reformated code for core change
#            .4.2 Cleaner code

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Script #################################################################
banner "Levy's dotfiles installer..." "$version Experimental release"
prime # Cache user password 
update_system # Update packages & database before starting the script 
aur_helper_check # Install aur helper if one is not found

# Verify that the necessary packages are installed 
section "Checking packages..."
install_missing_packages # Install missing packages, exit early if fails

# Symlink configurtations 
sync_config

