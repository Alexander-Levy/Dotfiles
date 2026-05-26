# Dotfiles

Configuration files for all programs managed by this repository. Each folder is a [stow](https://www.gnu.org/software/stow/) package that gets symlinked to `~/.config/` during installation.

## Structure

| Folder           | Description                                      |
|------------------|--------------------------------------------------|
| btop             | Resource monitor theme and layout                |
| fastfetch        | System info fetch tool config and custom logo    |
| fish             | Fish shell config, aliases and custom functions  |
| hypr             | Hyprland, hyprpaper, hyprlock config             |
| kitty            | Terminal emulator theme and keybinds             |
| nvim             | Neovim plugins, keybinds and LSP setup           |
| snappy-switcher  | Window switcher theme and behavior               |
| swaync           | Notification center styling and config           |
| waybar           | Status bar modules, layout and styling           |
| yazi             | Terminal file manager config and keybinds        |

## Usage

Each folder can be symlinked individually with stow if you only want a specific config:

```bash
cd ~/Dotfiles/
stow --target="~/.config/<folder>" --dir="dotfiles" --restow <folder>
```

Or just run the install script from the root of the repo and it will handle everything automatically.
