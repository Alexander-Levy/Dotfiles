#!/usr/bin/env bash

# Author:   Alexander Levy
# Blob:     The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir (~/.config/ for most). Asumes arch linux, will not
# work with debian and fedora based systems.

version="v0.2.7 "
# ChangeLog: .2.5 Made paru installation silent and changed banner msg 
#            .2.6 Add counter to checker and updated script output
#            .2.7 Added output message in case nothing was done.

##########################################################################################
# Parameters
##########################################################################################
# Variables
failed=()
missing=()
packages=(
    brightnessctl power-profiles-daemon wl-clipboard xdg-desktop-portal-hyprland # system utils [monitor, power mode, clipboard]
    pipewire pipewire-alsa pipewire-jack pipewire-audio pipewire-pulse           # audio dependencies
    hyprland hyprpaper hyprlock hyprshot hyprpicker hyprshutdown hyprpolkitagent # window manager & utils
    kitty waybar swaync bluetui wiremix fastfetch                                # desktop shell / elements
    bat curl eza git fzf vim fish ncdu yazi btop                                 # console/terminal tools 
    neovim npm wget unzip ripgrep tree-sitter-cli                                # neovim(+ plugins) dependencies
    mpvpaper wlctl-bin vicinae-bin snappy-switcher                               # aur pkgs for desktop shell / elements
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
    [[ "$1" == "okno"   ]] && echo -e -n "${green}$2${reset}"
}

# Install paru AUR helper
paru_install() {
    sudo pacman -S --needed base-devel git --noconfirm > /dev/null 2>&1
    git clone https://aur.archlinux.org/paru.git /tmp/paru > /dev/null 2>&1
    (cd /tmp/paru && makepkg -si --noconfirm) > /dev/null 2>&1
    rm -rf /tmp/paru
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
        log warn "  [$pkg_name] directory not found! Creating it..." 
        mkdir -p "$pkg_target"
        log ok   "  Created directory for [$pkg_name]!" 
    else
        log okno "  [$pkg_name]" 
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
    local linked_counter=0
    find "$pkg_src/$pkg_name" -not -type d | while IFS= read -r file; do
        rel_file="${file#"$pkg_src/$pkg_name"/}"
        target_file="$pkg_target/$rel_file"
        # Symlink the files if they aren't already 
        if [[ ! -L "$target_file" ]]; then
            ((linked_counter++))
            log info "    symlinking $rel_file..."
            mkdir -p "$pkg_target/$(dirname "$rel_file")"
            ln -sf "$file" "$pkg_target/$rel_file"
        fi
    done
    if [ $linked_counter -eq 0 ]; then    
        log info " files symlinked, nothing to do"
    fi
}

##########################################################################################
# Script
##########################################################################################
# Welcome message
banner "Levy's dotfiles installer..." "$version Look at it go!"

# Prepare system quietly 
sudo pacman -Syu --noconfirm > /dev/null 2>&1

# Install paru if not Installed
section "Checking if paru is installed..."
if command -v paru &>/dev/null; then
    log ok "[Success] paru found!\n"
else 
    log warn "Program was not found, installing paru..."
    paru_install
    log ok "[Success] Installed paru!\n"
fi

# Verify necesary pkgs
section "Checking packages..."
pkg_counter=0
for pkg in "${packages[@]}"; do
    if paru -Q "$pkg" &>/dev/null; then
        log ok   "[$pkg_counter/${#packages[@]}]  [OKAY] $pkg"
    else
        log warn "[$pkg_counter/${#packages[@]}]  [MISS] $pkg"
        missing+=("$pkg")
    fi
    ((pkg_counter++))
done

# Install missing packages one by one, log if install fails and exit early
if [[ ${#missing[@]} -eq 0 ]]; then
    log ok "[Success] All dependencies already installed!\n"
else
    read -rp "Install ${#missing[@]} missing package(s)? [y/N] " answer
    [[ "$answer" =~ ^[yY] ]] || exit 0
    for pkg in "${missing[@]}"; do
        log info "Installing $pkg... "
        if paru -S --noconfirm "$pkg" > /tmp/pkg_err 2>&1; then
            log ok "done"
        else
            log warn "FAILED"
            log warn "  Reason: $(cat /tmp/pkg_err | tail -1)"
            failed+=("$pkg")
        fi
    done
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
section "Syncing files..."
for dir in "$dotfiles_path"/*/; do
    name=$(basename "$dir")
    symlink "$name" "$dotfiles_path" "$config_path/$name" 
done
symlink "Wallpapers" "$current_path" "$wallpaper_path" # symlink wallpapers

