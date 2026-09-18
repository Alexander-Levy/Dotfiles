# Levy's Dotfiles

The purpose of this repository is simply to keep track of my dotfiles, feel free to grab anything that you find useful here :D. This configuration was made using Arch, other distros will not work. It includes configuration files for the packages i use, some wallpapers and few scripts to act as a sorts of dotfile installer/manager. 

### Preview 

![screenshot of desktop](./assets/desktop.png)

## Installation Steps

### Manual 

1. Install an AUR helper if you don't have one installed already. 
2. Ensure that all dependencies are installed.
3. Clone the repository and copy the desired configuration files 

```bash
git clone https://github.com/Alexander-Levy/Dotfiles.git
cp <source> <target>
```

### Automated 

Clone the repo and run the installation script. It will detect & download all missing dependencies, install an AUR helper if one is not installed already, and sync the configuration files. 
```bash
git clone https://github.com/Alexander-Levy/Dotfiles.git
cd Dotfiles/scripts
./install.sh
```
If you already installed and want something new that was added simply run the update script, no need to resintall :D.
```bash
cd Dotfiles/scripts
./update.sh
```
