#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║          Linux Package Install (Arch-based)                ║
# ║     Runs once via chezmoi apply on first setup             ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# Only run on Linux
[[ "$(uname)" != "Linux" ]] && exit 0

# Detect package manager
if command -v pacman &>/dev/null; then
    PM="pacman"
elif command -v apt &>/dev/null; then
    PM="apt"
else
    echo "Unsupported package manager. Install packages manually."
    exit 0
fi

echo "══════════════════════════════════════════════════"
echo "  Installing Linux packages ($PM)"
echo "══════════════════════════════════════════════════"

if [[ "$PM" == "pacman" ]]; then
    # ── Pacman packages ──────────────────────────────
    PACKAGES=(
        # Window manager & Wayland
        hyprland
        hyprpaper
        hyprlock
        hypridle
        waybar
        xdg-desktop-portal-hyprland

        # Terminal & shell
        kitty
        zsh
        starship

        # Notifications & launcher
        dunst
        fuzzel

        # Screenshot & clipboard
        grim
        slurp
        wl-clipboard
        clipman

        # CLI tools
        python
        eza
        bat
        btop
        lazygit
        tmux
        neovim
        ripgrep
        fd

        # Audio
        pipewire
        wireplumber
        pavucontrol

        # Font
        ttf-jetbrains-mono-nerd

        # Misc
        playerctl
    )

    echo "Installing pacman packages..."
    sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

    # ── AUR packages (requires yay or paru) ──────────
    AUR_PACKAGES=(
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    if command -v yay &>/dev/null; then
        echo "Installing AUR packages via yay..."
        yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
    elif command -v paru &>/dev/null; then
        echo "Installing AUR packages via paru..."
        paru -S --needed --noconfirm "${AUR_PACKAGES[@]}"
    else
        echo "No AUR helper found. Install manually: ${AUR_PACKAGES[*]}"
    fi

elif [[ "$PM" == "apt" ]]; then
    # ── Apt packages (Debian/Ubuntu) ─────────────────
    # Note: Hyprland on Debian/Ubuntu may need external repos
    PACKAGES=(
        kitty
        zsh
        dunst
        grim
        slurp
        wl-clipboard
        eza
        bat
        btop
        tmux
        python3
        neovim
        ripgrep
        fd-find
        pipewire
        wireplumber
        pavucontrol
        playerctl
    )

    echo "Installing apt packages..."
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}"

    echo ""
    echo "NOTE: Hyprland, waybar, fuzzel, hyprlock, hypridle, starship,"
    echo "and JetBrains Mono Nerd Font may need manual installation on Debian/Ubuntu."
    echo "See: https://wiki.hyprland.org/Getting-Started/Installation/"
fi

# ── Post-install ─────────────────────────────────────────────

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

# Create screenshots directory
mkdir -p ~/Pictures/Screenshots

# Install tmux plugin manager if missing
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo ""
echo "══════════════════════════════════════════════════"
echo "  Done! Remember to:"
echo "  1. Place wallpaper at ~/Pictures/wallpaper.jpg"
echo "  2. Log out and select Hyprland as session"
echo "  3. Run 'tmux' and press prefix+I to install plugins"
echo "══════════════════════════════════════════════════"
