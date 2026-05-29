# Author:  Alexander Levy
# Blob:    Core helper functions used for managing dotfiles with symlinks
# Version: v0.2.2

##########################################################################################
# Core functions
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
    aur_helper="$1"
    if [[ "$aur_helper" != "paru" && "$aur_helper" != "yay" ]]; then
        log err "Unsupported AUR helper: $aur_helper"
        return 1
    else
        log info "Installing $aur_helper..."
        sudo pacman -S --needed base-devel git --noconfirm > /dev/null 2>&1
        git clone https://aur.archlinux.org/$aur_helper.git  /tmp/$aur_helper > /dev/null 2>&1
        (cd /tmp/$aur_helper && makepkg -si --noconfirm) > /dev/null 2>&1
        rm -rf /tmp/$aur_helper
        log ok "[Success] Installed $aur_helper!\n"
    fi
}

# Helper funcs; shows all currently available aur helpers
aur_helper_install_selection() {
    log info "Please select one to install:"
    log info "1) paru"
    log info "2) yay"
    log info "3) Why not both?"
    log info "4) Don't install an AUR helper, exit script."
    read -rp "Enter your choice [1-4]: " choice
    case $choice in
        1)  aur_helper_install paru ;;
        2)  aur_helper_install yay  ;;
        3)  aur_helper_install yay  ;  
            aur_helper_install paru ;;
        4)  log warn "Exiting..."; exit 0 ;;
        *)  log warn "Invalid option, exiting..."; exit 1 ;;
    esac
}

# Check if an AUR helper is installed, if not prompts to install helper.
aur_helper_check() {
    local yay_installed=0
    local paru_installed=0

    section "Checking if an AUR Helper is installed... "
    if command -v paru &>/dev/null; then
        paru_installed=1
        log ok "[Success] paru found!\n"
    fi
    if command -v yay &>/dev/null; then
        yay_installed=1
        log ok "[Success] yay found!\n"
    fi

    # If both are installed choose which one to use
    if [[ $yay_installed -eq 1 && $paru_installed -eq 1 ]]; then    
        log info "Both paru and yay are installed, please select which one to use:"
        log info "1) paru"
        log info "2) yay"
        read -rp "Enter your choice [1-2]: " choice
        case $choice in
            1)  aur_helper="paru" ;;
            2)  aur_helper="yay"  ;;
            *)  aur_helper="paru" ;;
        esac
    elif [[ $yay_installed -eq 0 && $paru_installed -eq 1 ]]; then
        aur_helper="paru"
    elif [[ $yay_installed -eq 1 && $paru_installed -eq 0 ]]; then
        aur_helper="yay"
    # If no aur helpers are found, go to install 
    elif [[ $yay_installed -eq 0 && $paru_installed -eq 0 ]]; then    
        log warn "No AUR helper found."
        aur_helper_install_selection
    fi
}

# Verify that target dir exists, create backup of existing files
# and symlink configuration.
# Arguments: pkg:[name][../src][target]
symlink() {
    local pkg_name="$1"
    local pkg_src="$2"
    local pkg_target="$3"
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
    # Symlink files one by one and handle special case
    linked_counter=0
    while IFS= read -r file; do
        rel_file="${file#"$pkg_src/$pkg_name"/}"
        target_file="$pkg_target/$rel_file"
        # Symlink the files if they aren't already 
        if [[ ! -L "$target_file" ]]; then
            linked_counter=1
            log info "symlinking $rel_file..."
            mkdir -p "$pkg_target/$(dirname "$rel_file")"
            ln -sf "$file" "$pkg_target/$rel_file"
        fi
    done< <(find "$pkg_src/$pkg_name" -not -type d)
    if (( linked_counter == 0 )); then    
        log info "files symlinked, nothing to do"
    fi
}

# Installs all packages in $missing variable using $aur_helper as 
# the package manager.
install_missing_packages() {
    if [[ ${#missing[@]} -eq 0 ]]; then
        log ok "[Success] All dependencies already installed!\n"
        return 0
    fi
    read -rp "Install ${#missing[@]} missing package(s)? [y/N] " answer
    [[ "$answer" =~ ^[yY] ]] || exit 0
    for pkg in "${missing[@]}"; do
        log infono "Installing $pkg... "
        if $aur_helper -S --noconfirm "$pkg" > /tmp/pkg_err 2>&1; then
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
