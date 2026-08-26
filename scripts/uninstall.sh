#!/usr/bin/env bash

# Author:  Alexander Levy
# Blob:    The purpose of this script is to completely remove all packages added by the installer.
version="v0.1.4"

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Script #################################################################
banner "Levy's dotfiles Uninstaller..." "$version Test version"
prime
update_system    # Update packages & database before starting the script 
aur_helper_check # Find AUR helper
uninstall_shell  # Remove all pkgs installed; except for neccesary ones
del_config       # Removes symlinks created in the user's home dir

