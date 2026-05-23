# Dotfiles
The purpose of this repository is simply to keep track of my dotfiles, feel free to use anything that you find useful here :D

## System Overview
Im currently using Arch(btw), this has not been tested on other distros and may not work. Some context on what software is running on my system.

| Program function | Program name |
|-- | -- |
| Window manager | hyprland |
| Program launcher | vicinae |
| Status bar | waybar |
| Lockscreen | hyprlock |
| Wallpaper backend (images) | hyprpaper |
| Wallpaper backend (gifs, videos) | mpvpaper |
| Notification center | swaync |
| Terminal emulator | kitty |
| Command Line Shell | fish |
| Disk Usage | ncdu |
| Text editor | nvim |
| File Manager | yazi |
| Task Manager | btop |
| Symlink Manager | stow |
| System Information | fastfetch |


List of neovim plugins:

| Plugin function | Plugin name  |
| -- | --  |
| Colorscheme | eldritch |
| Powerbar | lualine |
| Syntax highligthing | nvim-treesitter |
| File explorer | neo-tree |
| Autocomplete | nvim-cmp |
| Dashboard | dashboard-nvim |
| Language Servers | mason, mason-lspconfig, nvim-lspconfig  |
| Preview md & css colors | markview, nvim-highligth-colors |
| Quality of Life | autoclose, indentmini |


## Installation Steps
Install an AUR helper (pacman for aur)
```bash
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

Download hyprland and some related utilities 
```bash
sudo pacman -S hyprland hyprpaper hyprlock 
```

Download shell elements (status bar, terminal emulator, notifications, etc)
```bash
sudo pacman -S kitty waybar swaync bluetui wiremix
paru -S wlctl-bin mpvpaper vicinae-bin 
```

Download terminal programs (text editor, file manager, task manager, etc)
```bash
sudo pacman -S git fzf vim fish nvim yazi btop stow ncdu fastfetch
```

Download neovim dependencies 
```bash
sudo pacman -S curl ripgrep tree-sitter-cli unzip npm ruby 
```

Clone the repo & symlink the configuration files to local pc
```bash
git clone https://github.com/Alexander-Levy/Dotfiles.git
cd Dotfiles
stow <package>
```

### TODO
List is in no particular order and with no promise of completion.
- [X] Clean up the configuration code
- [X] Make list of nvim plugins
- [X] Make readme file not suck
- [X] Add wallpapers to repo
- [ ] Add a readme file for each program
- [ ] Make a quick install script for programs
- [ ] Add hyprland keybinds
- [ ] Add custom neovim keybinds
