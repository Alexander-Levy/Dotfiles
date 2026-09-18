# Author:  Alexander Levy
# Blob:    Helper functions used for managing dotfiles with symlinks
# Version: v0.6.0 Removed AUR dependencies

# Variables
failed=()
missing=()
packages=(
    # Fonts
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd
    # System utils 
    bc brightnessctl eza power-profiles-daemon xdg-desktop-portal-hyprland wl-clipboard cliphist jq 
    # Audio 
    pipewire pipewire-alsa pipewire-jack pipewire-audio pipewire-pulse
    # Hyprland & related pkgs 
    hyprland hyprpaper hyprlock hyprshot hyprpicker hyprsunset hyprshutdown hyprpolkitagent 
    # Desktop shell & elements
    wofi kitty waybar mako bluetui wiremix fastfetch swayosd 
    # Terminal tools 
    bat btop cmake curl git lazygit fzf vim fish ncdu yazi
    # Neovim(+ plugins) deps
    neovim npm wget unzip ripgrep tree-sitter-cli
)
protected_packages=( fish git unzip vim brightnessctl power-profiles-daemon )

# Paths
current_path="$(realpath "../$(dirname "$0")")"
dotfiles_path="$current_path/dotfiles"
config_path="$HOME/.config"
wallpaper_path="$HOME/Wallpapers"
backup_path="$HOME/.dotfiles-backup"

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
# Core functions
##########################################################################################
prime() {
# Cache password so that its only asked once to the user
    sudo -i
}

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
                log warn "found ${#orphans[@]} file(s) not present in src:"
                printf '       - %s\n' "${orphans[@]}"
                read -r -p "     Back up and remove these? [y/N] " reply
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
                    log info "      removing $rel, backup in $backup_path."
                else
                    log warn "      skipped $rel."
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

sync_config() {
# Helper func; syncs all dotfiles and wallpapers
    section "Syncing files..."
    for dir in "$dotfiles_path"/*/; do
        symlink "$(basename "$dir")" "$dotfiles_path" "$config_path/$(basename "$dir")" 
    done
    symlink "Wallpapers" "$current_path" "$wallpaper_path"
}

del_config() {
# Helper func; deletes all configurtations and wallpapers
    section "Removing configurtation files..."
    for dir in "$dotfiles_path"/*/; do
        log info "  deleting $config_path/$(basename "$dir")..." 
        rm -rf "$config_path/$(basename "$dir")" 
    done
    log info "  deleting $wallpaper_path..." 
    rm -rf "$wallpaper_path" 
}

install_missing_packages() {
# Installs all packages in $missing variable using pacman as 
# the package manager.
    section "Checking packages..."
    for pkg in "${packages[@]}"; do
        if pacman -Q "$pkg" &>/dev/null; then
            log ok   "  [OKAY] $pkg"
        else
            log warn "  [MISS] $pkg"
            missing+=("$pkg")
        fi
    done
    if [[ ${#missing[@]} -eq 0 ]]; then
        log ok "[Success] All dependencies already installed!\n"
        return 0
    fi
    read -rp "Install ${#missing[@]} missing package(s)? [y/N] " answer
    [[ "$answer" =~ ^[yY] ]] || exit 0
    for pkg in "${missing[@]}"; do
        log infono "Installing $pkg... "
        if pacman -S --noconfirm "$pkg" > /tmp/pkg_err 2>&1; then
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

uninstall_shell() {
# Uninstalls all pkgs used by the shell; except for protected pkgs
# protected pkgs are specified in protected_packages variable
    section "Uninstalling packages..."
    for pkg in "${packages[@]}"; do
        # Check if package is protected
        if [[ " ${protected_packages[*]} " == *" $pkg "* ]]; then
            log info "Skipping protected package: $pkg"
            continue
        fi
        # Remove unprotected pkgs 
        if pacman -Rns --noconfirm "$pkg" &>/dev/null; then
            log info "Uninstalling $pkg..."
        else
            log warn "Failed to uninstall $pkg"
        fi
    done
    log info "Removing orphan packages..."
    pacman -Rns $(pacman -Qdtq) > /dev/null 2>&1
}

update_system() {
# Alias to update system database and packages
    section "Updating operating system..."
    sudo pacman -Syu --noconfirm > /dev/null 2>&1
    log ok "Update completed!"
}

##########################################################################################
# Build functions
##########################################################################################
install_mpvpaper() {}

install_wlctl() {}
