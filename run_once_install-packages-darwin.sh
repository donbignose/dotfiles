#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║          macOS Package Install (Homebrew)                   ║
# ║     Runs once via chezmoi apply on first setup              ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

# Only run on macOS
[[ "$(uname)" != "Darwin" ]] && exit 0

echo "══════════════════════════════════════════════════"
echo "  Installing macOS packages (Homebrew)"
echo "══════════════════════════════════════════════════"

# Ensure Homebrew is installed
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── CLI tools (shared with Linux) ────────────────────────────
FORMULAE=(
    neovim
    tmux
    eza
    bat
    btop
    lazygit
    ripgrep
    fd
    yazi
    fzf
    zoxide
    starship
    git-delta
    jq
    curl
    wget

    # Dev tools
    node
    python3
    go
    gcc
    make

    # Shell plugins
    zsh-autosuggestions
    zsh-syntax-highlighting

    # Yazi dependencies
    ffmpegthumbnailer
    p7zip
    poppler
    imagemagick
)

echo "Installing formulae..."
brew install "${FORMULAE[@]}"

# ── macOS window management ──────────────────────────────────
echo "Installing yabai and skhd..."
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

# ── Casks ────────────────────────────────────────────────────
CASKS=(
    kitty
    font-jetbrains-mono-nerd-font
)

echo "Installing casks..."
brew install --cask "${CASKS[@]}"

# ── Post-install ─────────────────────────────────────────────

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

# Install tmux plugin manager if missing
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo ""
echo "══════════════════════════════════════════════════"
echo "  Done! Remember to:"
echo "  1. Start yabai and skhd services"
echo "  2. Run 'tmux' and press prefix+I to install plugins"
echo "  3. Grant accessibility permissions to yabai/skhd"
echo "══════════════════════════════════════════════════"
