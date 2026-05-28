# Levy's Dotfiles

The purpose of this repository is simply to keep track of my dotfiles, feel free to use anything that you find useful here :D. This configuration was made using Arch, other distros have not been tested and may not work.

### Preview 

![screenshot of desktop](./media/desktop.png)

## Usage

### Hyprland keybinds

| Binds                        | Keybind description                   |
|------------------------------|---------------------------------------|
| Alt + Space                  | Open app launcher                     |
| Ctrl + Space                 | Open terminal                         |
| Super + Q                    | Close window                          |
| Super + B                    | Open firefox (browser)                |
| Super + E                    | Open yazi (terminal file manager)     |
| Super + G                    | Open steam (game launcher)            |
| Super + V                    | Open clipboard manager                |
| Super + N                    | Toggle notification center            |
| Super + P                    | Use colorpicker and copy to clipboard |
| Alt + Tab, Alt + Shift + Tab | Cycle througth opened windows         |

### Neovim keybinds

Only custom keybinds are shown here as all the usual keybindings from neovim (vimmotions, yanking, pasting, changing, etc) work as usual and have their default values.

| Binds                        | Keybind description                   |
|------------------------------|---------------------------------------|
| Alt + w                      | Save file                             |
| Alt + q                      | Close file                            |
| Alt + r                      | Source file                           |
| Alt + t                      | Open new tab                          |
| Alt + e                      | Open file tree                        |
| Alt + m                      | Toggle Markview                       |
| Alt + f                      | Find files using telescope            |
| Alt + g                      | Fuzzy find using telescope            |
| Alt + m                      | Toggle Markview                       |
| Shift + k                    | Lsp hover on cursor                   |
| Ctrl + c                     | Change colorscheme                    |
| Alt + up, Alt + down         | Move current line up or down          |

## Installation Steps

### Automated 

Clone the repo and run the installation script. It will detect and download all missing dependencies and sync the configuration files.

```bash
git clone https://github.com/Alexander-Levy/Dotfiles.git
cd Dotfiles/scripts
./install.sh
```
### Manual 

 1. Ensure that all dependencies are installed.
 2. Clone the repository and symlink the desired configuration files 

```bash
stow --target="<target_dir>" --dir="<../source_dir>" <package>
```

## TODO
- [ ] Complete list of hyprland & neovim binds
