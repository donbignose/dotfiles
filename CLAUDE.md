# Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Platforms

- **macOS** — Yabai (tiling WM), skhd (hotkeys), Sketchybar (status bar)
- **Linux (EndeavourOS / Arch)** — Hyprland (Wayland compositor), Waybar, Kitty, Fuzzel (launcher), Dunst (notifications), Hyprlock, Hypridle, SDDM (display manager)

Platform-specific configs are filtered via `.chezmoiignore` so only relevant files are deployed on each OS.

## Theme

**Kanagawa Wave** across all configs. Core palette:

| Role        | Hex       |
|-------------|-----------|
| Background  | `#1F1F28` |
| Foreground  | `#DCD7BA` |
| Blue        | `#7E9CD8` |
| Green       | `#76946A` |
| Purple      | `#957FB8` |
| Teal        | `#6A9589` |
| Orange      | `#DCA561` |
| Red         | `#C34043` |
| Pink        | `#D27E99` |

## Shared (both platforms)

- **Shell**: zsh with vi mode, starship prompt, eza/bat/ripgrep/fd
- **Editor**: Neovim (Kanagawa colorscheme via `rebelot/kanagawa.nvim`)
- **Multiplexer**: tmux with TPM
- **Git**: lazygit
- **Aliases**: `ls`→eza, `cat`→bat, `lg`→lazygit, standard git shortcuts

## Linux package install

`run_once_install-packages-linux.sh` runs once on `chezmoi apply`. Supports pacman (Arch) and apt (Debian/Ubuntu). AUR packages installed via yay/paru.

## Applying changes

```bash
chezmoi apply        # deploy all configs
chezmoi diff         # preview changes before applying
chezmoi add <file>   # track a new dotfile
```

## Structure

```
dot_config/
  hypr/          # Hyprland, hyprlock, hypridle (Linux)
  waybar/        # Waybar config + style (Linux)
  kitty/         # Kitty terminal (Linux)
  fuzzel/        # Fuzzel launcher (Linux)
  dunst/         # Dunst notifications (Linux)
  yabai/         # Yabai tiling WM (macOS)
  skhd/          # skhd hotkey daemon (macOS)
  sketchybar/    # Sketchybar status bar (macOS)
  nvim/          # Neovim config (both)
  lazygit/       # Lazygit config (both)
  starship.toml  # Starship prompt (both)
dot_tmux.conf    # tmux config (both)
dot_zshrc        # zsh config (both)
dot_zprofile     # zsh profile (both)
```
