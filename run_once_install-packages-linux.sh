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
        awww
        hyprlock
        hypridle
        waybar
        xdg-desktop-portal-hyprland
        keyd

        # Terminal & shell
        ghostty
        zsh
        starship

        # Notifications, launcher & OSD
        swaync
        rofi
        swayosd

        # Screenshot & clipboard
        grim
        slurp
        wl-clipboard
        wf-recorder
        cliphist

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
        yazi
        fzf
        zoxide
        ffmpegthumbnailer
        p7zip
        poppler
        imagemagick

        # Dev tools
        docker
        docker-compose
        git
        git-delta
        gcc
        make
        nodejs
        npm
        go
        jq
        curl
        wget
        openssh
        unzip

        # Audio
        pipewire
        wireplumber
        pavucontrol

        # Display & input
        brightnessctl

        # Network & Bluetooth
        networkmanager
        bluez
        bluez-utils

        # Font
        ttf-jetbrains-mono-nerd

        # Display manager
        sddm
        qt5-graphicaleffects
        qt5-quickcontrols2

        # Authentication
        hyprpolkitagent

        # Shell plugins
        zsh-autosuggestions
        zsh-syntax-highlighting

        # Applications
        thunderbird
        spotify-launcher

        # Misc
        playerctl
        pacman-contrib
    )

    echo "Installing pacman packages..."
    sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

    # ── AUR packages (requires yay or paru) ──────────
    AUR_PACKAGES=(
        bibata-cursor-theme-bin
        colloid-everforest-gtk-theme-git
        everforest-icon-theme-git
        grimblast-git
        pyprland
        rofi-bluetooth-git
        sddm-astronaut-theme
        zen-browser-bin
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
        # Dev tools
        docker.io
        docker-compose
        git
        gcc
        make
        nodejs
        npm
        golang-go
        jq
        curl
        wget
        openssh-client
        unzip

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

# Enable NetworkManager
if command -v NetworkManager &>/dev/null; then
    echo "Enabling NetworkManager..."
    sudo systemctl enable --now NetworkManager
fi

# Enable SwayOSD
if command -v swayosd-server &>/dev/null; then
    systemctl --user enable --now swayosd-libinput-backend.service 2>/dev/null || true
fi

# Enable SDDM display manager
if command -v sddm &>/dev/null; then
    echo "Enabling SDDM display manager..."
    sudo systemctl enable sddm
fi

# Configure keyd (fix Logitech swapped TLDE/LSGT keys)
if command -v keyd &>/dev/null; then
    echo "Configuring keyd key remapping..."
    sudo mkdir -p /etc/keyd
    sudo tee /etc/keyd/default.conf > /dev/null << 'KEYD'
[ids]
*

[main]
102nd = grave
grave = 102nd
KEYD
    sudo systemctl enable --now keyd
fi

# Enable and start Docker
if command -v docker &>/dev/null; then
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
fi

# Install Rust via rustup if not present
if ! command -v rustup &>/dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Set zsh as default shell if not already
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

# Install Everforest cursors
if [ ! -d "$HOME/.icons/everforest-cursors" ]; then
    echo "Installing Everforest cursors..."
    mkdir -p "$HOME/.icons"
    wget -cO- https://github.com/talwat/everforest-cursors/releases/latest/download/everforest-cursors-variants.tar.bz2 | tar xfj - -C "$HOME/.icons"
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
echo "  1. Place wallpaper at ~/Pictures/wallpaper.png"
echo "  2. Log out and select Hyprland as session"
echo "  3. Run 'tmux' and press prefix+I to install plugins"
echo "  4. Log out/in for docker group to take effect"
echo "══════════════════════════════════════════════════"
