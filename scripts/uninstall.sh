#!/usr/bin/env bash

# Author:  Alexander Levy
# Blob:    The purpose of this script is to completely remove all packages added by the installer.
# Version: v0.0.2

# Include core utils
script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_path/core.sh"

# Variables
packages=(
    ttf-jetbrains-mono-nerd ttf-jetbrains-mono                                   # fonts
    brightnessctl xdg-desktop-portal-hyprland                                    # system utils 
    hyprland hyprpaper hyprlock hyprshot hyprpicker hyprshutdown hyprpolkitagent # window manager & tools
    kitty waybar swaync bluetui wiremix fastfetch wl-clipboard                   # desktop shell & elements
    bat curl eza lazygit fzf ncdu yazi btop                                      # console/terminal tools 
    neovim npm wget unzip ripgrep tree-sitter-cli                                # neovim(+ plugins) deps
    mpvpaper wlctl-bin
)

# Script #################################################################
banner "Levy's dotfiles Uninstaller..." ""
update_system # Update packages & database before starting the script 

aur_helper_check # Find AUR helper

# Remove all installed packages
section "Uninstalling packages..."
for pkg in "${packages[@]}"; do
    if $aur_helper -Rns --noconfirm "$pkg" &>/dev/null; then
        log info "Uninstalling $pkg..."
    else
        log warn "Failed to uninstall $pkg"
    fi
done
log info "Removing orphan packages..."
$aur_helper -Rns $($aur_helper -Qdtq) > /dev/null 2>&1

# Uninstall AUR Helpers
if [[ $yay_installed -eq 1 ]]; then    
    log info "Removing yay..."
    sudo pacman -Rns yay yay-debug --noconfirm > /dev/null 2>&1
fi
if [[ $paru_installed -eq 1 ]]; then    
    log info "Removing paru..."
    sudo pacman -Rns paru paru-debug --noconfirm > /dev/null 2>&1
fi
pacman -Rns $(pacman -Qdtq) > /dev/null 2>&1

# Deleting configurtations 
section "Removing configurtation files..."
for dir in "$dotfiles_path"/*/; do
    log info "  deleting $config_path/$(basename "$dir")..." 
    rm -rf "$config_path/$(basename "$dir")" 
done
log info "  deleting $wallpaper_path..." 
rm -rf "$wallpaper_path" 

