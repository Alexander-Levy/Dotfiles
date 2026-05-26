#!/usr/bin/env bash

# Author:   Alexander Levy
# Blob:     The purpose of this script is to install all necesary packages and create symlinks
# with configuration files to the correct dir (~/.config/ for most). Asumes arch linux, will not
# work with debian and fedora based systems.

version="v0.2.10"
# ChangeLog: .2.8  Updated install and log output
#            .2.9  Script now ask to chose: paru or yay
#            .2.10 Cleaned up the script section {easier to follow}

# TODO:
#      migrate hardcoded paru to generic $aur_helper variable

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
    local width=44
    local border=$(printf '─%.0s' $(seq 1 $width))

    echo -e "\e[34m┌${border}┐"
    printf "│%*s%*s│\n" $(( (width + ${#message}) / 2 )) "$message" $(( (width - ${#message}) / 2 )) ""
    echo -e "└${border}┘\e[0m"
}

# Better echo
# ok: green, err: red, info: blue, warn: yellow
log() {
    local green="\e[32m" 
    local red="\e[31m" 
    local blue="\e[34m" 
    local yellow="\e[33m" 
    local reset="\e[0m"
    [[ "$1" == "ok"     ]] && echo -e "${green} $2${reset}"
    [[ "$1" == "err"    ]] && echo -e "${red} $2${reset}"
    [[ "$1" == "info"   ]] && echo -e "${blue} $2${reset}"
    [[ "$1" == "warn"   ]] && echo -e "${yellow} $2${reset}"
    [[ "$1" == "okno"   ]] && echo -e -n "${green}$2${reset}"
    [[ "$1" == "infono" ]] && echo -e -n "${blue}$2${reset}"
}

# Download and install an AUR helper
# Supported options: paru or yay
aur_helper_install() {
    local aur_helper="$1"
    if [[ "$aur_helper" != "paru" && "$aur_helper" != "yay" ]]; then
        return 1
    fi
    sudo pacman -S --needed base-devel git --noconfirm > /dev/null 2>&1
    git clone https://aur.archlinux.org/$aur_helper.git  /tmp/$aur_helper > /dev/null 2>&1
    log err "Unsupported AUR helper: $aur_helper"
    (cd /tmp/$aur_helper && makepkg -si --noconfirm) > /dev/null 2>&1
    rm -rf /tmp/$aur_helper
}

# Check if an AUR helper is installed, if not prompts to install helper.
aur_helper_check() {
    section "Checking if an AUR Helper is installed... "
    if command -v paru &>/dev/null; then
        log ok "[Success] paru found!\n"
    elif command -v yay &>/dev/null; then
        log ok "[Success] yay found!\n"
    else
        log warn "No AUR helper found."
        log info "Please select one to install:"
        log info "1) paru"
        log info "2) yay"
        log info "3) Don't install AUR helper, exit script."
        read -rp "Enter your choice [1-3]: " choice

        case $choice in
            1) aur_helper_install paru && log ok "[Success] Installed paru!\n" ;;
            2) aur_helper_install yay  && log ok "[Success] Installed yay!\n" ;;
            3) log warn "Exiting..."; exit 0 ;;
            *) log warn "Invalid option, exiting..."; exit 1 ;;
        esac
    fi
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
        log info "files symlinked, nothing to do"
    fi
}

install_missing_packages() {
    if [[ ${#missing[@]} -eq 0 ]]; then
        log ok "[Success] All dependencies already installed!\n"
        return 0
    fi
    read -rp "Install ${#missing[@]} missing package(s)? [y/N] " answer
    [[ "$answer" =~ ^[yY] ]] || exit 0
    for pkg in "${missing[@]}"; do
        log infono "Installing $pkg... "
        if paru -S --noconfirm "$pkg" > /tmp/pkg_err 2>&1; then
            log ok "done!"
        else
            log warn "failed to install"
            log warn "  Reason: $(tail -1 /tmp/pkg_err)"
            failed+=("$pkg")
        fi
    done
    if [[ ${#failed[@]} -eq 0 ]]; then
        log ok "Installed all packages successfully!\n"
    else
        log err "Failed to install:"
        for pkg in "${failed[@]}"; do
            log warn "  - $pkg"
        done
        exit 1
    fi
}

# Alias to update system database and packages
update_system() {
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
}

##########################################################################################
# Script
##########################################################################################
# Prepare system quietly 
banner "Levy's dotfiles installer..." "$version Prototype model unit-01 "
update_system # Update packages & database before starting the script 

# Verify that the necessary packages are installed 
aur_helper_check # Install aur helper if one is not found
section "Checking packages..."
for pkg in "${packages[@]}"; do
    if paru -Q "$pkg" &>/dev/null; then
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

