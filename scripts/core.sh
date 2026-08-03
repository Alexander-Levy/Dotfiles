# Author:  Alexander Levy
# Blob:    Helper functions used for managing dotfiles with symlinks
# Version: v0.3.1

##########################################################################################
# Logging functions
##########################################################################################
banner() {
# Prints message inside pretty banner
# Arguments: [title] [subtitle]
    local title="$1" subtitle="$2"
    local width=75
    local border=$(printf '═%.0s' $(seq 1 $width))
    echo -e "\e[34m╔${border}╗"
    printf "║%*s%*s ║\n" $(( (width + ${#title})     / 2 )) "$title"     $(( (width - ${#title})     / 2 )) ""
    printf "║%*s%*s ║\n" $(( (width + ${#subtitle})  / 2 )) "$subtitle"  $(( (width - ${#subtitle})  / 2 )) ""
    echo -e "╚${border}╝\e[0m"
}

section() {
# Prints message inside section box 
# Arguments: [message]
    local message="$1"
    local width=44
    local border=$(printf '─%.0s' $(seq 1 $width))
    echo -e "\e[34m┌${border}┐"
    printf "│%*s%*s│\n" $(( (width + ${#message}) / 2 )) "$message" $(( (width - ${#message}) / 2 )) ""
    echo -e "└${border}┘\e[0m"
}

log() {
# Better echo
# ok: green, err: red, info: blue, warn: yellow
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

##########################################################################################
# AUR related functions
##########################################################################################
aur_helper_install() {
# Download and install an AUR helper
# Supported options: paru or yay
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

aur_helper_install_selection() {
# Helper funcs; shows all currently available aur helpers
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

aur_helper_check() {
# Check if an AUR helper is installed, if not prompts to install helper.
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

##########################################################################################
# Core functions
##########################################################################################
symlink() {
# I HATE this function, need to rewrite it, but im too lazy to do it now so whatever :P
# Sync the configuration files from a source directory to a target directory using symlinks
# while preserving directory structure. If the target directory already exist the files inside
# are saved to a backup location.
# Arguments: pkg:[name][../src][target] opt:[ask|force|skip]
    # Local variables
    local pkg_name="$1"
    local pkg_src="$2"
    local pkg_target="$3"
    local orphan_mode="${4:-ask}" # ask | force | skip
    
    local linked_counter=0
    local backed_up_counter=0

    # Verify that the target directory exists 
    if [[ ! -d "$pkg_target" ]]; then
        log warn "  [$pkg_name] directory not found! Creating it..."
        mkdir -p "$pkg_target"
        log ok   "  Created directory for [$pkg_name]!"
    else
        log okno "  [$pkg_name]"
        # Build a lookup of every relative path that *should* exist per src
        local -A expected=()
        local rel
        while IFS= read -r file; do
            rel="${file#"$pkg_src/$pkg_name"/}"
            expected["$rel"]=1
        done < <(find "$pkg_src/$pkg_name" -not -type d)

        # First pass: find orphans and ask about them up front (not one prompt per file)
        local -a orphans=()
        while IFS= read -r file; do
            rel="${file#"$pkg_target"/}"
            [[ -z "${expected[$rel]:-}" ]] && orphans+=("$rel")
        done < <(find "$pkg_target" -not -type d)
        local remove_orphans=true
        if (( ${#orphans[@]} > 0 )); then
            if [[ "$orphan_mode" == "skip" ]]; then
                remove_orphans=false
            elif [[ "$orphan_mode" == "ask" ]]; then
                log warn "  [$pkg_name] found ${#orphans[@]} file(s) not present in src:"
                printf '    - %s\n' "${orphans[@]}"
                read -r -p "  Back up and remove these? [y/N] " reply
                [[ "$reply" =~ ^[Yy]$ ]] || remove_orphans=false
            fi
            # orphan_mode == "force" falls through with remove_orphans=true
        fi

        # Second pass: back up/remove existing files and orphans
        while IFS= read -r file; do
            rel="${file#"$pkg_target"/}"
            if [[ -n "${expected[$rel]:-}" ]]; then
                # Belongs to this pkg: back it up only if it's a real file
                if [[ ! -L "$file" ]]; then
                    mkdir -p "$backup_path/$pkg_name/$(dirname "$rel")"
                    cp -a "$file" "$backup_path/$pkg_name/$rel"
                    rm -rf "$file"
                    backed_up_counter=1
                    log info "    backing up $rel..."
                fi
            else
                # Orphan: not part of src anymore
                if $remove_orphans; then
                    mkdir -p "$backup_path/$pkg_name/$(dirname "$rel")"
                    cp -a "$file" "$backup_path/$pkg_name/$rel"
                    rm -rf "$file"
                    backed_up_counter=1
                    log info "    removing $rel (backed up)..."
                else
                    log warn "    skipping $rel (left in place)"
                fi
            fi
        done < <(find "$pkg_target" -not -type d)
    fi

    # Symlink files one by one and handle special case
    local file rel_file target_file
    while IFS= read -r file; do
        rel_file="${file#"$pkg_src/$pkg_name"/}"
        target_file="$pkg_target/$rel_file"
        if [[ ! -L "$target_file" ]]; then
            linked_counter=1
            log info "symlinking $rel_file..."
            mkdir -p "$pkg_target/$(dirname "$rel_file")"
            ln -sf "$file" "$pkg_target/$rel_file"
        fi
    done < <(find "$pkg_src/$pkg_name" -not -type d)
    if (( linked_counter == 0 && backed_up_counter == 0 )); then
        log info "nothing to do"
    fi
}

install_missing_packages() {
# Installs all packages in $missing variable using $aur_helper as 
# the package manager.
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

update_system() {
# Alias to update system database and packages
    section "Updating operating system..."
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
    log ok "Update completed!"
}

