#!/usr/bin/env bash

# Author:   Alexander Levy
# Version:  v0.1.2
# Blob:     The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir (~/.config/ for most). Asumes arch linux, will not
# work with debian and fedora based systems.

# Variables
failed=()
missing=()
packages=(
    hyprland hyprpaper hyprlock             # window manager
    kitty waybar swaync bluetui wiremix     # de shell / elements
    mpvpaper wlctl-bin vicinae-bin          # aur de shell / elements
    bat eza stow ncdu fastfetch             # qof tools
    curl git fzf vim fish neovim yazi btop  # console tools 
    npm wget unzip ripgrep tree-sitter-cli  # neovim deps
)

# Paths
current_path="$(realpath "$(dirname "$0")")"
dotfiles_path="$(realpath "$(dirname "$0")")/dotfiles"
config_path="$HOME/.config"
wallpaper_path="$HOME/Wallpapers"

# Start program :D (idk how to make it pretty :( yet ;))
echo "Levy's dotfiles installer..."

# Install paru if not installed
echo "Checking if paru is installed..."
if command -v paru &>/dev/null; then
    echo "Success! paru is installed"
else 
    echo "Program was not found, installing..."
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    rm -rf /tmp/paru
    echo "Succesfully installed paru!"
fi

# Verify necesary pkgs
echo "Checking packages..."
for pkg in "${packages[@]}"; do
    if paru -Q "$pkg" &>/dev/null; then
        echo "  [OK]        $pkg"
    else
        echo "  [MISSING]   $pkg"
        missing+=("$pkg")
    fi
done

# Install missing packages
if [[ ${#missing[@]} -eq 0 ]]; then
    echo "All packages installed!"
else
    read -rp "Install ${#missing[@]} missing package(s)? [y/N] " answer
    [[ "$answer" =~ ^[yY] ]] || exit 0
    # Install pks one by one
    for pkg in "${missing[@]}"; do
        echo -n "  Installing $pkg... "
        if paru -S --noconfirm "$pkg" 2>/tmp/pkg_err; then
            echo "done"
        else
            echo "FAILED"
            echo "  Reason: $(cat /tmp/pkg_err | tail -1)"
            failed+=("$pkg")
        fi
    done
    if [[ ${#failed[@]} -eq 0 ]]; then
        echo "Installed all packages succesfully!"
    else 
        echo
        echo "Failed to install:"
        for pkg in "${failed[@]}"; do
            echo "  - $pkg"
        done
        exit 1
    fi
fi

# Create symlinks
echo "Symlinking dotfiles..."
for dir in "$dotfiles_path"/*/; do
    name=$(basename "$dir")
    if [[ ! -d "$config_path/$name" ]]; then 
        mkdir -p "$config_path/$name" 
        echo "Created ~/.config/$name"
    fi
    stow --target="$config_path/$name" --dir="$dotfiles_path" --restow "$name"
    echo "  [LINKED] $name"
done
if [[ ! -d "$wallpaper_path" ]]; then
    mkdir -p "$wallpaper_path" 
    echo "Created ~/Wallpapers"
fi
stow --target="$wallpaper_path" --dir="$current_path" --restow Wallpapers
echo "  [LINKED] Wallpapers"

# Exit message (did you get the joke?xD)
echo "Done :D paru!"

