# Keybinds Cheatsheet

## Hyprland (Super = Mod key)

### Apps & Menus
| Key | Action |
|-----|--------|
| `Super + Return` | Terminal (kitty) |
| `Super + D` | App launcher (rofi) |
| `Super + V` | Clipboard history |
| `Super + X` | Power menu |
| `Super + N` | Notification center |
| `Super + Escape` | Lock screen |
| `Super + Shift+W` | Wallpaper picker |
| `Super + Shift+Q` | Kill window |
| `Super + Shift+E` | Exit Hyprland |
| `Super + Shift+C` | Reload config |

### Navigation
| Key | Action |
|-----|--------|
| `Super + H/J/K/L` | Focus left/down/up/right |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + Ctrl + Left/Right` | Prev/next workspace |
| `Super + Tab` | Expose (all windows overview) |

### Layout
| Key | Action |
|-----|--------|
| `Super + F` | Fullscreen |
| `Super + B` | Toggle split |
| `Super + Shift+Space` | Toggle floating |
| `Super + Space` | Cycle focus |
| `Super + R` | Resize mode (then H/J/K/L, Esc to exit) |
| `Super + LMB` | Drag move window |
| `Super + RMB` | Drag resize window |

### Scratchpads (pyprland)
| Key | Action |
|-----|--------|
| `Super + -` | Dropdown terminal |
| `Super + Shift + -` | Dropdown btop |
| `Super + Shift + V` | Volume control (pavucontrol) |

### Screenshots
| Key | Action |
|-----|--------|
| `Super + Shift+P` | Screenshot/recording menu |

### Media
| Key | Action |
|-----|--------|
| `Volume keys` | Volume up/down/mute (with OSD) |
| `Brightness keys` | Brightness up/down (with OSD) |
| `Play/Next/Prev` | Media controls |

---

## tmux (Prefix = Ctrl+B)

### Panes
| Key | Action |
|-----|--------|
| `Prefix + \|` | Split vertical |
| `Prefix + -` | Split horizontal |
| `Ctrl + H/J/K/L` | Navigate panes (works in vim too) |
| `Prefix + H/J/K/L` | Resize pane |
| `Prefix + m` | Toggle zoom (fullscreen pane) |
| `Prefix + M` | Dev layout (nvim left, shell right) |

### Windows
| Key | Action |
|-----|--------|
| `Prefix + c` | New window |
| `Prefix + n/p` | Next/prev window |
| `Prefix + 0-9` | Switch to window |
| `Prefix + ,` | Rename window |
| `Prefix + &` | Kill window |

### Sessions
| Key | Action |
|-----|--------|
| `Prefix + d` | Detach |
| `Prefix + s` | List sessions |
| `Prefix + $` | Rename session |

### Copy Mode
| Key | Action |
|-----|--------|
| `Prefix + [` | Enter copy mode (vi keys) |
| `v` | Start selection |
| `y` | Copy selection |
| `q` | Exit copy mode |

---

## Zed (Vim mode, Space = leader)

### Navigation
| Key | Action |
|-----|--------|
| `Ctrl + H/J/K/L` | Navigate between panes |
| `Ctrl + P` | Find file |
| `gd` | Go to definition |
| `gr` | Go to references |
| `Ctrl + O / Ctrl+I` | Jump back / forward |
| `s{char}{char}` | Sneak jump (vim-sneak) |

### Leader (Space)
| Key | Action |
|-----|--------|
| `Space f` | Find file |
| `Space /` | Project search |
| `Space e` | Toggle file explorer |
| `Space \|` | Split right |
| `Space -` | Split down |
| `Space x` | Close tab |
| `Shift+H / Shift+L` | Prev / next tab |
| `Space ca` | Code actions |
| `Space rn` | Rename symbol |
| `Space d` | Diagnostics |
| `]d / [d` | Next / prev diagnostic |

### Editing
| Key | Action |
|-----|--------|
| `jk` | Escape to normal mode |
| `Ctrl + D` | Select next occurrence |
| `Ctrl + Shift+L` | Select all occurrences |
| `Ctrl + Enter` | Open Agent panel |

---

## Yazi (terminal file manager)

### Navigation
| Key | Action |
|-----|--------|
| `h/l` | Parent / enter directory |
| `j/k` | Move down / up |
| `gg / G` | Top / bottom |
| `~` | Go home |
| `/` | Search |
| `n/N` | Next / prev search result |

### File Operations
| Key | Action |
|-----|--------|
| `Space` | Toggle select |
| `V` | Visual select mode |
| `y` | Yank (copy) |
| `d` | Cut |
| `p` | Paste |
| `D` | Delete (trash) |
| `r` | Rename |
| `a` | Create file |
| `A` | Create directory |
| `.` | Toggle hidden files |

### Preview & Tabs
| Key | Action |
|-----|--------|
| `Enter` | Open file |
| `t` | New tab |
| `1-9` | Switch tab |
| `w` | Close tab |
| `z` | Jump (zoxide) |

---

## Shell (zsh + vi mode)

### Vi Mode
| Key | Action |
|-----|--------|
| `Esc` | Normal mode |
| `i / a` | Insert mode |
| `Up/Down` | Prefix history search |
| `Ctrl+R` | Fuzzy history search (fzf) |
| `Ctrl+T` | Fuzzy file search (fzf) |
| `Alt+C` | Fuzzy cd (fzf) |

### Aliases
| Alias | Command |
|-------|---------|
| `ls` | `eza --icons` |
| `ll` | `eza -la --icons` |
| `lt` | `eza --tree --level=2` |
| `cat` | `bat` |
| `y` | yazi (cd on exit) |
| `cc` | `claude` |
| `ccr` | `claude --continue` |
| `lg` | `lazygit` |
| `gs/ga/gc/gp/gl/gd` | git shortcuts |

---

## Lazygit

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `d` | Diff view |
| `[/]` | Switch panels |
| `?` | Help |
