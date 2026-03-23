# Hybrid macOS + Linux Dotfiles — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make this chezmoi-managed dotfiles repo deploy correctly on both macOS and Arch Linux, using chezmoi's built-in templating and OS detection.

**Architecture:** Use `.chezmoiignore` for whole-directory exclusions (platform-specific apps), chezmoi `.tmpl` files for shared configs that need per-OS logic (shell configs), and separate `run_once_*` scripts per OS for package installation.

**Tech Stack:** chezmoi, zsh, Homebrew (macOS), pacman (Linux)

---

## Current State

Configs currently deploy fine on Linux. On macOS, several issues:

| Issue | Impact |
|-------|--------|
| `.chezmoiignore` missing Linux-only exclusions | rofi, swaync, swayosd, pypr, wlogout, gtk, local/bin scripts all deploy to macOS |
| `dot_zshrc` plugin paths are Linux-only | zsh-autosuggestions and syntax-highlighting won't load |
| `dot_zprofile` empty | Homebrew PATH never gets set |
| No macOS install script | No automated package installation |
| `run_onchange_install-sddm-theme.sh` not excluded | Would try to run on macOS |

---

### Task 1: Fix `.chezmoiignore` — complete platform exclusions

**Files:**
- Modify: `.chezmoiignore`

- [ ] **Step 1: Add all missing Linux-only exclusions to the non-Linux block**

```
{{ if ne .chezmoi.os "linux" }}
.config/hypr/
.config/waybar/
.config/kitty/
.config/dunst/
.config/fuzzel/
.config/rofi/
.config/swaync/
.config/swayosd/
.config/pypr/
.config/wlogout/
.config/gtk-3.0/
.config/gtk-4.0/
.local/bin/
run_once_install-packages-linux.sh
run_onchange_install-sddm-theme.sh
{{ end }}
```

- [ ] **Step 2: Add macOS install script exclusion to the non-Darwin block**

```
{{ if ne .chezmoi.os "darwin" }}
.config/skhd/
.config/yabai/
.config/sketchybar/
run_once_install-packages-darwin.sh
{{ end }}
```

- [ ] **Step 3: Verify with `chezmoi managed`**

```bash
chezmoi managed --include=files | grep -E "(rofi|swaync|swayosd|pypr|wlogout|gtk-|local/bin|sddm)"
```
Expected: no output (all excluded on macOS)

- [ ] **Step 4: Commit**

```bash
git add .chezmoiignore
git commit -m "fix: exclude all Linux-only configs on macOS in chezmoiignore"
```

---

### Task 2: Template `dot_zprofile` for Homebrew PATH

**Files:**
- Rename: `dot_zprofile` → `dot_zprofile.tmpl`

- [ ] **Step 1: Rename to template**

```bash
git mv dot_zprofile dot_zprofile.tmpl
```

- [ ] **Step 2: Write the templated content**

```
# ╔══════════════════════════════════════════════════════════════╗
# ║                       Zsh Profile                          ║
# ╚══════════════════════════════════════════════════════════════╝

{{ if eq .chezmoi.os "darwin" -}}
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
{{- end }}
```

- [ ] **Step 3: Verify template renders**

```bash
chezmoi cat ~/.zprofile
```
Expected on macOS: shows the Homebrew eval line. On Linux: just the header.

- [ ] **Step 4: Commit**

```bash
git add dot_zprofile.tmpl
git commit -m "feat: template zprofile with Homebrew PATH for macOS"
```

---

### Task 3: Template `dot_zshrc` for cross-platform plugin paths

**Files:**
- Rename: `dot_zshrc` → `dot_zshrc.tmpl`

Plugin paths differ per OS:
- **Linux (Arch):** `/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh`
- **macOS (Homebrew):** `/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh`

- [ ] **Step 1: Rename to template**

```bash
git mv dot_zshrc dot_zshrc.tmpl
```

- [ ] **Step 2: Replace the Plugins section with OS-conditional paths**

Only the plugins block (lines 103-110) changes. Replace with:

```
# ── Plugins ──────────────────────────────────────────────────
{{ if eq .chezmoi.os "linux" -}}
# zsh-autosuggestions
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last plugin)
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
{{- else if eq .chezmoi.os "darwin" -}}
# zsh-autosuggestions
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last plugin)
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
{{- end }}
```

- [ ] **Step 3: Verify template renders**

```bash
chezmoi cat ~/.zshrc | tail -15
```
Expected on macOS: `/opt/homebrew/share/...` paths.

- [ ] **Step 4: Commit**

```bash
git add dot_zshrc.tmpl
git commit -m "feat: template zshrc with cross-platform plugin paths"
```

---

### Task 4: Create macOS install script

**Files:**
- Create: `run_once_install-packages-darwin.sh`
- Modify: `.chezmoiignore` (already handled in Task 1)

- [ ] **Step 1: Review Linux install script for shared tools**

Check `run_once_install-packages-linux.sh` to identify which CLI tools are cross-platform.

- [ ] **Step 2: Create the install script**

```bash
#!/bin/bash
# Install packages on macOS via Homebrew
[[ "$(uname)" != "Darwin" ]] && exit 0

# Ensure Homebrew is installed
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── CLI tools (shared with Linux) ────────────────────────────
brew install \
  neovim \
  tmux \
  eza \
  bat \
  fd \
  ripgrep \
  fzf \
  zoxide \
  starship \
  yazi \
  lazygit \
  git-delta \
  node \
  python3

# ── Zsh plugins ──────────────────────────────────────────────
brew install \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# ── macOS window management ──────────────────────────────────
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

# ── Casks ────────────────────────────────────────────────────
brew install --cask kitty

# ── TPM (tmux plugin manager) ────────────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "macOS packages installed. Run 'tmux' then press prefix+I to install tmux plugins."
```

- [ ] **Step 3: Make executable**

```bash
chmod +x run_once_install-packages-darwin.sh
```

- [ ] **Step 4: Commit**

```bash
git add run_once_install-packages-darwin.sh
git commit -m "feat: add macOS package install script via Homebrew"
```

---

### Task 5: Verify full deployment (dry run)

- [ ] **Step 1: Run chezmoi diff on macOS**

```bash
chezmoi diff
```

Review: should only show changes to files that belong on macOS. No Linux-only files.

- [ ] **Step 2: Apply on macOS**

```bash
chezmoi apply -v
```

Verify: zsh plugins load, aliases work, tmux starts, nvim works.

- [ ] **Step 3: Final push**

```bash
git push -u origin hybrid-setup
```
