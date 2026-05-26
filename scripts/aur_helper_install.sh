#!/usr/bin/env bash

# Author:  Alexander Levy
# Blob:    Presents install options for aur helpers available in core funcs
# Version: v0.1

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Selection of available aur helpers ##################################
banner "Levy's AUR Helper Installer..." "testing release "
update_system # Update packages & database before starting the script 
aur_helper_install_selection # Presents aur helper install options

