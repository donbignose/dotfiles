# Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Platforms
- **macOS** — Yabai, skhd, Sketchybar
- **Linux (Arch)** — Hyprland, Waybar, Kitty, Rofi, swaync, SDDM

## Theme
**Everforest Dark** across all configs. Key colors:
- bg: `#2D353B`, surface: `#343F44`, border: `#475258`
- fg: `#D3C6AA`, muted: `#7A8478`
- green: `#A7C080`, aqua: `#83C092`, blue: `#7FBBB3`
- red: `#E67E80`, orange: `#E69875`, yellow: `#DBBC7F`, purple: `#D699B6`

## Chezmoi Workflow
Chezmoi was initialized from the GitHub URL (not local folder).
Changes require: `git commit` → `git push` → `chezmoi update`
- `run_once_*` scripts run on first setup only
- `run_onchange_*` scripts re-run when their content changes
- System files (SDDM, keyd) are deployed via run scripts with sudo

## Hyprland Gotchas
- Use new rule syntax: `windowrule = float on, match:class <name>` (not `windowrulev2`)
- Layer rules: `layerrule = blur on, match:namespace waybar` (not `ignorezero`, use `ignore_alpha`)
- All rule fields need explicit values (e.g. `float on`, not just `float`)
- hyprpaper uses category syntax: `wallpaper { monitor = \n path = ... }`
- Monitor config uses `monitor = , preferred, auto, 1.5` (auto-detect, not hardcoded DP-x)

## Waybar Gotchas
- `"icon": true` on `hyprland/window` causes segfaults in waybar 0.15 — avoid
- Window-rewrite icons: use Python with `\U` escapes to write config (nerd font chars above BMP get lost with Write tool)
- Config is JSON (JSONC comments OK but strip them if debugging crashes)
- `group/` modules with `drawer` can also cause segfaults — test incrementally
- GTK CSS doesn't support `gap` — use `margin` instead
- **Separate pills in modules-center**: set `.modules-center { background: transparent; }` then target each module individually (`.modules-center #module-name { background: ...; border-radius: ...; margin: 0 8px; }`) — groups and `> *` selectors don't work for this

## Key Tools
- **Rofi** — launcher, clipboard, power menu, screenshot menu, wallpaper picker
- **swaync** — notification center (replaced dunst)
- **swayosd** — volume/brightness OSD popups
- **pyprland** — scratchpads and expose
- **keyd** — kernel-level key remapping (fixes Logitech TLDE/LSGT swap)
- **grimblast** — screenshots, **wf-recorder** — screen recording

## Shell
- zsh with vi mode, fzf (Everforest colors), zoxide (`cd` aliased)
- `cc` = claude, `ccr` = claude --continue, `y` = yazi with cd-on-exit
