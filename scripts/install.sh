#!/usr/bin/env bash

# Author: Alexander Levy
# Blob:   The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir. Asumes minimal arch linux, will not work with 
# debian and fedora based systems.

version="v0.4.5"
# ChangeLog: .4.5 Just Better

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Script #################################################################
banner "Levy's dotfiles installer..." "$version Experimental release"
prime                    # Cache user password 
update_system            # Update systems database & packages
aur_helper_check         # Find aur helper to use [asks for install if none is found]
install_missing_packages # Install missing packages, exit early if fails
sync_config              # Apply configurtations and wallpapers

