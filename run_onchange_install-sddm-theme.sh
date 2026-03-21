#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║    SDDM Astronaut Theme — Kanagawa Wave config              ║
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
    sudo cp "$HOME/Pictures/wallpaper.png" "$THEME_DIR/Backgrounds/kanagawa.png"
    BG_FILE="Backgrounds/kanagawa.png"
elif [[ -f "$HOME/Pictures/wallpaper.jpg" ]]; then
    sudo cp "$HOME/Pictures/wallpaper.jpg" "$THEME_DIR/Backgrounds/kanagawa.jpg"
    BG_FILE="Backgrounds/kanagawa.jpg"
else
    BG_FILE="Backgrounds/japanese_aesthetic.png"
fi

# ── Write Kanagawa theme config ────────────────────────────────
sudo tee "$THEME_DIR/Themes/kanagawa.conf" > /dev/null << CONF
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

HeaderTextColor="#DCD7BA"
DateTextColor="#727169"
TimeTextColor="#DCD7BA"

FormBackgroundColor="#1F1F28"
BackgroundColor="#1F1F28"
DimBackgroundColor="#16161D"

LoginFieldBackgroundColor="#2A2A37"
PasswordFieldBackgroundColor="#2A2A37"
LoginFieldTextColor="#DCD7BA"
PasswordFieldTextColor="#DCD7BA"
UserIconColor="#727169"
PasswordIconColor="#727169"

PlaceholderTextColor="#727169"
WarningColor="#C34043"

LoginButtonTextColor="#1F1F28"
LoginButtonBackgroundColor="#98BB6C"
SystemButtonsIconsColor="#727169"
SessionButtonTextColor="#727169"
VirtualKeyboardButtonTextColor="#727169"

DropdownTextColor="#DCD7BA"
DropdownSelectedBackgroundColor="#2A2A37"
DropdownBackgroundColor="#1F1F28"

HighlightTextColor="#DCD7BA"
HighlightBackgroundColor="#98BB6C"
HighlightBorderColor="#54546D"

HoverUserIconColor="#DCD7BA"
HoverPasswordIconColor="#DCD7BA"
HoverSystemButtonsIconsColor="#DCD7BA"
HoverSessionButtonTextColor="#DCD7BA"
HoverVirtualKeyboardButtonTextColor="#DCD7BA"

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

# ── Point the theme at our Kanagawa config ─────────────────────
sudo sed -i 's|ConfigFile=Themes/.*\.conf|ConfigFile=Themes/kanagawa.conf|' "$THEME_DIR/metadata.desktop"

# ── Set as active theme ────────────────────────────────────────
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf > /dev/null << 'SDDMCONF'
[Theme]
Current=sddm-astronaut-theme
SDDMCONF

echo "SDDM Astronaut theme configured with Kanagawa colors."
