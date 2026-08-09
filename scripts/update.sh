#!/usr/bin/env bash

# Author: Alexander Levy
# Blob:   Update dotfiles files & backup old configs

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Script #################################################################
banner "Levy's dotfiles updater..." ""
sync_config

