#!/usr/bin/env bash

# Author:   Alexander Levy
# Version:  v0.1.10
# Blob:     The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir (~/.config/ for most). Asumes arch linux, will not
# work with debian and fedora based systems.
#
# ChangeLog: .1.10 Added brightnessctl to pkg list

##########################################################################################
# Parameters
##########################################################################################
# Variables
failed=()
missing=()
packages=(
    brightnessctl                                   # deps
    hyprland hyprpaper hyprlock hyprshot            # window manager
    kitty waybar swaync bluetui wiremix             # de shell / elements
    mpvpaper wlctl-bin vicinae-bin snappy-switcher  # aur de shell / elements
    bat eza stow ncdu fastfetch                     # qof tools
    curl git fzf vim fish neovim yazi btop          # console tools 
    npm wget unzip ripgrep tree-sitter-cli          # neovim deps
)

# Paths
current_path="$(realpath "$(dirname "$0")")"
dotfiles_path="$(realpath "$(dirname "$0")")/dotfiles"
config_path="$HOME/.config"
wallpaper_path="$HOME/Wallpapers"
backup_path="$HOME/.dotfiles-backup"

##########################################################################################
# Helper functions
##########################################################################################

# Prints message inside pretty banner
# Arguments: [title] [subtitle]
banner() {
    local title="$1" subtitle="$2"
    local width=75
    local border=$(printf '═%.0s' $(seq 1 $width))

    echo -e "\e[34m╔${border}╗"
    printf "║%*s%*s ║\n" $(( (width + ${#title})     / 2 )) "$title"     $(( (width - ${#title})     / 2 )) ""
    printf "║%*s%*s ║\n" $(( (width + ${#subtitle})  / 2 )) "$subtitle"  $(( (width - ${#subtitle})  / 2 )) ""
    echo -e "╚${border}╝\e[0m"
}

# Prints message inside section 
# Arguments: [message]
section() {
    local message="$1"
    local width=34
    local border=$(printf '─%.0s' $(seq 1 $width))

    echo -e "\e[34m┌${border}┐"
    printf "│%*s%*s│\n" $(( (width + ${#message}) / 2 )) "$message" $(( (width - ${#message}) / 2 )) ""
    echo -e "└${border}┘\e[0m"
}

# Better logging
# ok: green, err: red, info: blue, warn: yellow
log() {
    local green="\e[32m" 
    local red="\e[31m" 
    local blue="\e[34m" 
    local yellow="\e[33m" 
    local reset="\e[0m"
    [[ "$1" == "ok"   ]] && echo -e "${green}   $2${reset}"
    [[ "$1" == "err"  ]] && echo -e "${red}   $2${reset}"
    [[ "$1" == "info" ]] && echo -e "${blue}   $2${reset}"
    [[ "$1" == "warn" ]] && echo -e "${yellow}   $2${reset}"
}

# Verify that target dir exists, create backup of existing files
# and symlink configuration.
# Arguments: pkg:[name][../src][target]
symlink() {
    local pkg_name="$1"     # ie nvim
    local pkg_src="$2"      # ie ./dotfiles (dir)
    local pkg_target="$3"   # ie ~/.config/nvim (dir)

    # Ensure target dir exists
    if [[ ! -d "$pkg_target" ]]; then
        log err "  [$pkg_name] directory not found! Creating it..." 
        mkdir -p "$pkg_target"
    else
        log ok  "  [$pkg_name]" 
        for file in "$pkg_target"/*; do
            rel="${file#"$pkg_target"/}"
            # Create a backup of the existing config files
            if [[ -e "$file" && ! -L "$file" && ! -d "$file" ]]; then
                mkdir -p "$backup_path/$pkg_name"
                cp -r "$file" "$backup_path/$pkg_name/"
                rm -rf "$file"
                log info "    backing up $rel..."
            fi
        done
    fi
    # Symlink files
    find "$pkg_src/$pkg_name" -not -type d | while IFS= read -r file; do
        rel_file="${file#"$pkg_src/$pkg_name"/}"
        target_file="$pkg_target/$rel_file"
        # Symlink the files if they aren't already 
        if [[ ! -L "$target_file" ]]; then
            echo "    Symlinking $rel_file..."
            mkdir -p "$pkg_target/$(dirname "$rel_file")"
            ln -sf "$file" "$pkg_target/$rel_file"
        fi
    done
}

##########################################################################################
# Script
##########################################################################################
# Welcome message
banner "Levy's dotfiles installer..." " v0.1.10 nice rigth? :D"

# Install paru if not Installed
section "Checking if paru is installed..."
if command -v paru &>/dev/null; then
    log ok "[Success] paru found!\n"
else 
    log warn "Program was not found, installing paru..."
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    rm -rf /tmp/paru
    log ok "[Success] Installed paru!\n"
fi

# Verify necesary pkgs
section "Checking packages..."
for pkg in "${packages[@]}"; do
    if paru -Q "$pkg" &>/dev/null; then
        log ok   "[OK]      $pkg"
    else
        log warn "[MISSING] $pkg"
        missing+=("$pkg")
    fi
done

# Install missing packages
if [[ ${#missing[@]} -eq 0 ]]; then
    log ok "[Success] All dependencies already installed!\n"
else
    read -rp "Install ${#missing[@]} missing package(s)? [y/N] " answer
    [[ "$answer" =~ ^[yY] ]] || exit 0
    # Install pks one by one
    for pkg in "${missing[@]}"; do
        log info "Installing $pkg... "
        if paru -S --noconfirm "$pkg" 2>/tmp/pkg_err; then
            log ok "done"
        else
            log warn "FAILED"
            log warn "  Reason: $(cat /tmp/pkg_err | tail -1)"
            failed+=("$pkg")
        fi
    done

    # If failed to install log and exit 
    if [[ ${#failed[@]} -eq 0 ]]; then
        log ok "Installed all packages succesfully!\n"
    else 
        log err "Failed to install:"
        for pkg in "${failed[@]}"; do
            log warn "  - $pkg"
        done
        exit 1
    fi
fi

# Symlink configurtations 
section "Creating symlinks..."
for dir in "$dotfiles_path"/*/; do
    name=$(basename "$dir")
    symlink "$name" "$dotfiles_path" "$config_path/$name" 
done

# Symlink wallpapers
symlink "Wallpapers" "$current_path" "$wallpaper_path" 

