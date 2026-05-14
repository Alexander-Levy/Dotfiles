# Dotfiles
The purpose of this repository is simply to keep track of my dotfiles, feel free to use anything that you find useful here :D

## System Overview
Some context on what software is running on my system

    Desktop Enviroment:
        Window Manager:             hyprland
        App Launcher:               wofi
        Status bar:                 waybar
        Lockscreen:                 hyprlock
        Wallpaper{Image}:           hyprpaper
        Wallpaper{Live}:            mpvpaper
        Notifications:              swaync
        Terminal emulator:          kitty
        Command Line Shell:         fish
    
    Programs:
        Disk Usage:             ncdu
        Text editor:            nvim
        File Manager:           yazi
        Task Manager:           btop
        Symlink Manager:        stow
        System Information:     fastfetch


## Installation

Download the following packages to use custom desktop enviroment (my preferred window manager + desktop components) 
```bash
sudo pacman -Syu fish kitty wofi waybar hyprland hyprlock hyprpaper mpvpaper swaync
```

Download the following packages to use my preferred programs
```bash
sudo pacman -Syu ncdu nvim yazi btop stow fastfetch
```

Neovim dependencies:
```bash
sudo pacman -Syu git fzf curl ripgrep tree-sitter-cli  
```


### TODO
This repository was quickly thrown together out of need, will make it less worse in the future (maybe?). List is in no particular order.
- [ ] Add wallpapers to repo
- [ ] Make list of nvim plugins
- [<] Make readme file not suck
- [ ] Clean up the configuration code
- [ ] Add a readme file for each program
- [ ] Make a quick install script for programs

