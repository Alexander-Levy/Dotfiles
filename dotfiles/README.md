# Dotfiles

Configuration files for all programs managed by this repository. Each folder is a [stow](https://www.gnu.org/software/stow/) package that gets symlinked to `~/.config/` during installation.

## Structure

| Folder           | Description                                      |
|------------------|--------------------------------------------------|
| btop             | Resource monitor theme and layout                |
| fastfetch        | System info fetch tool config and custom logo    |
| fish             | Fish shell config, aliases and custom functions  |
| hypr             | Hyprland, hyprpaper, hyprlock config             |
| noctalia         | Complete desktop shell (wallpaper/bar/etc)       |
| nvim             | Neovim plugins, keybinds and LSP setup           |
| kitty            | Terminal emulator theme and keybinds             |
| yazi             | Terminal file manager config and keybinds        |

## Usage

Each folder can be symlinked individually with stow if you only want a specific config:

```bash
cd ~/Dotfiles/
stow --target="~/.config/<folder>" --dir="dotfiles" --restow <folder>
```

Or just run the install script from the root of the repo and it will handle everything automatically.
