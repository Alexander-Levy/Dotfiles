# Dotfiles
The purpose of this repository is simply to keep track of my dotfiles, feel free to use anything that you find useful here :D

## System Overview
Im currently using Arch (btw), this has not been tested on other distros and may not work. Some context on what software is running on my system.

| Program | Description |
|-- | -- |
| hyprland | Window manager |
| vicinae | App launcher, calculator, file seacher, etc |
| waybar | Status bar |
| hyprlock | Lockscreen backend|
| hyprpaper | Wallpaper backend (images) |
| mpvpaper | Wallpaper backend (gifs, videos) |
| swaync | Notification center & service |
| kitty | Terminal emulator |
| fish | Command Line Interpreter |
| ncdu | Disk usage analysis tool |
| nvim | Text editor |
| yazi | Terminal File Manager |
| btop | Task manager for the terminal |
| stow | Symlink manager |


## Installation Steps

### Automated
Run the install script (runs the manual installation steps for you) {tested only on my machine, run at your own risk}. I recommend reading the script before running.
```bash
chmod +x install.sh
./install.sh
```

### Manual 
1 . Install an AUR helper (paru or yay) 
2 . Make sure all dependencies are installed
```bash
paru -S hyprland hyprpaper hyprlock kitty waybar swaync bluetui wiremix wlctl-bin mpvpaper vicinae-bin git fzf vim fish nvim yazi btop stow ncdu fastfetch curl ripgrep tree-sitter-cli wget unzip npm ruby 
```
3 . Clone the repo & symlink the configuration files to local pc
```bash
git clone https://github.com/Alexander-Levy/Dotfiles.git
cd Dotfiles
stow <package>
```

## TODO
List is in no particular order and with no promise of completion.
- [X] Clean up the configuration code
- [X] Make list of nvim plugins
- [X] Make readme file not suck
- [X] Add wallpapers to repo
- [X] Make a quick install script for programs
- [ ] Add a readme file for each program
- [ ] Add hyprland keybinds
- [ ] Add custom neovim keybinds
- [ ] Make readme even better
