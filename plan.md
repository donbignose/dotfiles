# Linux Dotfiles Integration Plan — Kanagawa Wave Theme

## Overview
Migrate from sway to Hyprland, unify all configs under Kanagawa Wave theme,
and add missing shell/utility configs. All managed via chezmoi with OS-specific
`.chezmoiignore` logic.

## Kanagawa Wave Color Reference
```
bg:         #1F1F28    fg:         #DCD7BA
bg_dark:    #16161D    comment:    #727169
red:        #C34043    orange:     #FFA066
yellow:     #DCA561    green:      #76946A
cyan:       #6A9589    blue:       #7E9CD8
magenta:    #957FB8    white:      #C8C093
sel_bg:     #2D4F67    border:     #54546D
```

---

## Phase 1: Remove sway, set up Hyprland

### 1.1 Delete sway configs
- `dot_config/sway/config`
- `dot_config/sway/lockman.sh`

### 1.2 Create `dot_config/hypr/hyprland.conf`
- Monitor: `DP-1, 3840x2160@60, 0x0, 1.5` (4K scaled to effective 2560x1440)
- Keyboard: Swiss-German (`ch`, variant `de`), caps→escape
- Kanagawa border colors (active: `#7E9CD8`, inactive: `#54546D`)
- Gaps: inner 5, outer 5, border 2px
- Keybindings: port all sway bindings (Super+hjkl focus, Shift+Super+hjkl move, workspaces 1-10, etc.)
- Terminal: kitty, Browser: firefox, Launcher: fuzzel
- Screenshot: grim + slurp (same screenshot mode logic)
- Clipboard: wl-paste + clipman
- Startup apps: waybar, hypridle, hyprpaper, firefox (ws2), thunderbird (ws5)
- Window rules: float Calculator, System Settings

### 1.3 Create `dot_config/hypr/hyprpaper.conf`
- Wallpaper: `~/Pictures/wallpaper.jpg` (user sets their own)
- Preload + wallpaper on DP-1

### 1.4 Create `dot_config/hypr/hypridle.conf`
- 300s → hyprlock
- 600s → dpms off

### 1.5 Create `dot_config/hypr/hyprlock.conf`
- Kanagawa-themed lock screen (dark bg, blue accent input field)

---

## Phase 2: Update waybar for Hyprland + Kanagawa

### 2.1 Update `dot_config/waybar/config`
- Replace `sway/workspaces` → `hyprland/workspaces`
- Replace `sway/window` → `hyprland/window`
- Keep all right-side modules (cpu, memory, disk, temp, network, audio, tray)
- Keep clock, weather

### 2.2 Update `dot_config/waybar/style.css`
- Kanagawa color scheme throughout
- Background: `#1F1F28`, module bg: `#2A2A37`
- Text: `#DCD7BA`, accent colors from Kanagawa palette

---

## Phase 3: Clean kitty config

### 3.1 Replace `dot_config/kitty/kitty.conf`
- Kanagawa Wave colors
- Font: JetBrains Mono Nerd Font, size 11
- Background opacity: 0.85
- Cursor: Kanagawa blue (#7E9CD8)
- Tab bar: Kanagawa styled
- Sensible defaults (scrollback, mouse, copy behavior)

---

## Phase 4: Create shell configs

### 4.1 Create `dot_zshrc`
- Starship prompt init
- Aliases: ls→eza, cat→bat, common git aliases
- PATH: `~/.local/bin`
- History settings
- Vi mode (bindkey -v)
- Plugin sourcing hooks (zsh-autosuggestions, zsh-syntax-highlighting — user installs)

### 4.2 Create `dot_config/starship.toml`
- Kanagawa-colored modules
- Git status, directory, language versions (node, python, rust, go)
- Minimal but informative prompt

---

## Phase 5: Create notification/launcher configs

### 5.1 Create `dot_config/dunst/dunstrc`
- Kanagawa colors (bg: #1F1F28, fg: #DCD7BA)
- Low: green border, Normal: blue border, Critical: red border
- Font: JetBrains Mono Nerd Font 10
- Corner radius, icon size, positioning

### 5.2 Create `dot_config/fuzzel/fuzzel.ini`
- Kanagawa colors
- Font: JetBrains Mono Nerd Font
- Replaces rofi as Wayland-native launcher

---

## Phase 6: Update cross-platform configs to Kanagawa

### 6.1 Update `dot_config/nvim/lua/plugins/colorscheme.lua`
- Replace catppuccin → `rebelot/kanagawa.nvim`
- Variant: `wave`
- Keep existing integrations (gitsigns, telescope, treesitter)

### 6.2 Update `dot_tmux.conf`
- Replace `janoamaral/tokyo-night-tmux` → `Jedsek/kanagawa-tmux` or manual Kanagawa status line
- Keep all keybindings and functionality unchanged

### 6.3 Lazygit — keep as-is
- Custom commit helpers are theme-independent (they're functional, not visual)

---

## Phase 7: Update chezmoi config

### 7.1 Update `.chezmoiignore`
- Remove sway references
- Add hypr, dunst, fuzzel to Linux-only section
- Keep macOS exclusions unchanged
```
{{ if ne .chezmoi.os "linux" }}
.config/hypr/
.config/waybar/
.config/kitty/
.config/dunst/
.config/fuzzel/
{{ end }}
```

---

## File Summary

| Action  | File                                    |
|---------|-----------------------------------------|
| DELETE  | `dot_config/sway/config`                |
| DELETE  | `dot_config/sway/lockman.sh`            |
| CREATE  | `dot_config/hypr/hyprland.conf`         |
| CREATE  | `dot_config/hypr/hyprpaper.conf`        |
| CREATE  | `dot_config/hypr/hypridle.conf`         |
| CREATE  | `dot_config/hypr/hyprlock.conf`         |
| CREATE  | `dot_config/dunst/dunstrc`              |
| CREATE  | `dot_config/fuzzel/fuzzel.ini`          |
| CREATE  | `dot_zshrc`                             |
| CREATE  | `dot_config/starship.toml`              |
| MODIFY  | `dot_config/waybar/config`              |
| MODIFY  | `dot_config/waybar/style.css`           |
| MODIFY  | `dot_config/kitty/kitty.conf`           |
| MODIFY  | `dot_config/nvim/lua/plugins/colorscheme.lua` |
| MODIFY  | `dot_tmux.conf`                         |
| MODIFY  | `.chezmoiignore`                        |

## Post-deploy (manual steps for user)
1. Install packages: `hyprland hyprpaper hyprlock hypridle waybar kitty dunst fuzzel grim slurp wl-clipboard starship eza bat zsh`
2. Install font: JetBrains Mono Nerd Font
3. Set wallpaper: place desired image at `~/Pictures/wallpaper.jpg`
4. Install zsh plugins: `zsh-autosuggestions`, `zsh-syntax-highlighting`
5. Run `chezmoicd ~ && chezmoi apply` to deploy
6. Adjust monitor scale in hyprland.conf if 1.5 doesn't feel right (try 1.25 or 1.75)
