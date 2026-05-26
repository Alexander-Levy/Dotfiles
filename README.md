# Levy's Dotfiles

The purpose of this repository is simply to keep track of my dotfiles, feel free to use anything that you find useful here :D. This configuration was made using Arch, other distros have not been tested and may not work. Below is a list of the software configured

## Preview 

![screenshot of desktop](./media/desktop.png)

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
stow --target="$HOME/.config/<package>" --dir="dotfiles" <package>
```

## TODO

List is in no particular order and with no promise of completion.
- [X] Add a readme file for each program
- [ ] Add hyprland keybinds
- [ ] Add custom neovim keybinds

