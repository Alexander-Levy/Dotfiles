#!/usr/bin/env bash

# Author:   Alexander Levy
# Version:  v0.0
# Blob:     The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir (~/.config/ for most). Asumes arch linux, will not
# work with debian and fedora based systems.

# Start program :D (idk how to make it pretty :( yet ;))
echo "Levy's dotfiles installer..."
failed=()
missing=()
packages=(
    hyprland hyprpaper hyprlock # window manager
    kitty waybar swaync bluetui wiremix # desktop shell 
    bat eza git fzf vim fish neovim yazi btop stow ncdu fastfetch # cli
    curl wget ripgrep unzip tree-sitter-cli npm #ruby # nvim deps
    ruby #htop ranger # test
)
current_path="$(realpath "$(dirname "$0")")"
dotfiles_path="$(realpath "$(dirname "$0")")/dotfiles"

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
    if [[ ! -d "$HOME/.config/$name" ]]; then 
        mkdir -p "$HOME/.config/$name" 
        echo "Created ~/.config/$name"
    fi
    stow --target="$HOME/.config/$name" --dir="$dotfiles_path" --restow "$name"
    echo "  [LINKED] $name"
done
if [[ ! -d "$HOME/Wallpapers" ]]; then
    mkdir -p "$HOME/Wallpapers" 
    echo "Created ~/Wallpapers"
fi
stow --target="$HOME" --dir="$current_path" --restow Wallpapers
echo "  [LINKED] Wallpapers"

# Exit message (did you get the joke?xD)
echo "Done :D paru!"

