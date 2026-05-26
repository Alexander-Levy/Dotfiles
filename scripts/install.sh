#!/usr/bin/env bash

# Author: Alexander Levy
# Blob:   The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir. Asumes arch linux, will not work with debian and 
# fedora based systems.

version="v0.3.0"

# Variables
aur_helper=""
failed=()
missing=()
packages=(
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd                                   # fonts
    brightnessctl power-profiles-daemon wl-clipboard xdg-desktop-portal-hyprland # system utils 
    pipewire pipewire-alsa pipewire-jack pipewire-audio pipewire-pulse           # audio 
    hyprland hyprpaper hyprlock hyprshot hyprpicker hyprshutdown hyprpolkitagent # window manager & tools
    kitty waybar swaync bluetui wiremix fastfetch                                # desktop shell & elements
    bat curl eza git fzf vim fish ncdu yazi btop                                 # console/terminal tools 
    neovim npm wget unzip ripgrep tree-sitter-cli                                # neovim(+ plugins) deps
    mpvpaper wlctl-bin vicinae-bin snappy-switcher                               # aur pkgs 
)

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
for dir in "$dotfiles_path"/*/; do
    symlink "$(basename "$dir")" "$dotfiles_path" "$config_path/$(basename "$dir")" 
done
symlink "Wallpapers" "$current_path" "$wallpaper_path" # symlink wallpapers

