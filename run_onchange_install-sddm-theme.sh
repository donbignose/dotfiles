#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║    SDDM Astronaut Theme — Everforest Dark config            ║
# ║   Re-runs automatically when this script's content changes  ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

[[ "$(uname)" != "Linux" ]] && exit 0
command -v sddm &>/dev/null || exit 0

THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

# ── Clean up old custom kanagawa theme if present ──
[[ -d "/usr/share/sddm/themes/kanagawa" ]] && sudo rm -rf /usr/share/sddm/themes/kanagawa

# ── Copy wallpaper into theme directory (SDDM can't read /home) ──
if [[ -f "$HOME/Pictures/wallpaper.png" ]]; then
    sudo cp "$HOME/Pictures/wallpaper.png" "$THEME_DIR/Backgrounds/everforest.png"
    BG_FILE="Backgrounds/everforest.png"
elif [[ -f "$HOME/Pictures/wallpaper.jpg" ]]; then
    sudo cp "$HOME/Pictures/wallpaper.jpg" "$THEME_DIR/Backgrounds/everforest.jpg"
    BG_FILE="Backgrounds/everforest.jpg"
else
    BG_FILE="Backgrounds/japanese_aesthetic.png"
fi

# ── Write Everforest theme config ──────────────────────────────
sudo tee "$THEME_DIR/Themes/everforest.conf" > /dev/null << CONF
[General]
#################### General ####################

Font="JetBrains Mono Nerd Font"
FontSize=""
RoundCorners="12"

Locale=""
HourFormat="HH:mm"
DateFormat="dddd, d MMMM"

HeaderText=""

#################### Background ####################

Background="$BG_FILE"
DimBackground="0.3"
CropBackground="true"

#################### Colors ####################

HeaderTextColor="#D3C6AA"
DateTextColor="#7A8478"
TimeTextColor="#D3C6AA"

FormBackgroundColor="#2D353B"
BackgroundColor="#2D353B"
DimBackgroundColor="#232A2E"

LoginFieldBackgroundColor="#343F44"
PasswordFieldBackgroundColor="#343F44"
LoginFieldTextColor="#D3C6AA"
PasswordFieldTextColor="#D3C6AA"
UserIconColor="#7A8478"
PasswordIconColor="#7A8478"

PlaceholderTextColor="#7A8478"
WarningColor="#E67E80"

LoginButtonTextColor="#2D353B"
LoginButtonBackgroundColor="#A7C080"
SystemButtonsIconsColor="#7A8478"
SessionButtonTextColor="#7A8478"
VirtualKeyboardButtonTextColor="#7A8478"

DropdownTextColor="#D3C6AA"
DropdownSelectedBackgroundColor="#343F44"
DropdownBackgroundColor="#2D353B"

HighlightTextColor="#D3C6AA"
HighlightBackgroundColor="#A7C080"
HighlightBorderColor="#475258"

HoverUserIconColor="#D3C6AA"
HoverPasswordIconColor="#D3C6AA"
HoverSystemButtonsIconsColor="#D3C6AA"
HoverSessionButtonTextColor="#D3C6AA"
HoverVirtualKeyboardButtonTextColor="#D3C6AA"

#################### Form ####################

PartialBlur="true"
FullBlur="false"
BlurMax="48"
Blur="2.0"

HaveFormBackground="true"
FormPosition="left"

#################### Interface Behavior ####################

HideVirtualKeyboard="true"
HideSystemButtons="false"
HideLoginButton="false"

ForceLastUser="true"
PasswordFocus="true"
HideCompletePassword="true"
AllowEmptyPassword="false"
AllowUppercaseLettersInUsernames="false"
CONF

# ── Point the theme at our Everforest config ───────────────────
sudo sed -i 's|ConfigFile=Themes/.*\.conf|ConfigFile=Themes/everforest.conf|' "$THEME_DIR/metadata.desktop"

# ── Set as active theme ────────────────────────────────────────
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf > /dev/null << 'SDDMCONF'
[Theme]
Current=sddm-astronaut-theme
SDDMCONF

echo "SDDM Astronaut theme configured with Everforest colors."
