# Levy's Dotfiles
The purpose of this repository is simply to keep track of my dotfiles, feel free to use anything that you find useful here :D

## Preview 
![screenshot of desktop](./Wallpapers/dark-city.jpg)

## System Overview
This configuration was made using Arch, other distros have not been tested and may not work. Below is a list of the software configured

| Program | Description |
|-- | -- |
| hyprland | Window manager |
| waybar | Status bar & modules |
| swaync | Notification daemon |
| kitty | Terminal emulator |
| neovim | Text editor |
| yazi | File manager |
| btop | System monitor |
| fish | Command-line interpreter |

## Installation Steps
### Automated
Clone the repo and run the installation script. It will detect and download all missing dependencies and then apply my configurations.
```bash
chmod +x install.sh
./install.sh
```

### Manual 
1. Install an AUR helper (paru or yay) 
2. Make sure all dependencies are installed
3. Clone the repo & symlink the desired configuration files to local pc
```bash
git clone https://github.com/Alexander-Levy/Dotfiles.git
cd Dotfiles
stow --target="<target-dir>" --dir="<source-dir>" --restow <package>
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
