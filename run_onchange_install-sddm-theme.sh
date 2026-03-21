#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║       SDDM Kanagawa Theme — deployed by chezmoi             ║
# ║   Re-runs automatically when this script's content changes  ║
# ╚══════════════════════════════════════════════════════════════╝

set -euo pipefail

[[ "$(uname)" != "Linux" ]] && exit 0
command -v sddm &>/dev/null || exit 0

THEME_DIR="/usr/share/sddm/themes/kanagawa"

echo "Installing Kanagawa SDDM theme..."
sudo mkdir -p "$THEME_DIR"

# ── metadata.desktop ───────────────────────────────────────────
sudo tee "$THEME_DIR/metadata.desktop" > /dev/null << 'METADATA'
[SddmGreeterTheme]
Name=Kanagawa
Description=Minimal Kanagawa Wave theme for SDDM
Author=donbignose
License=MIT
Type=sddm-theme
Version=1.0
MainScript=Main.qml
ConfigFile=theme.conf
Theme-Id=kanagawa
Theme-API=2.0
METADATA

# ── theme.conf ─────────────────────────────────────────────────
sudo tee "$THEME_DIR/theme.conf" > /dev/null << 'THEMECONF'
[General]
background=/home/leo/Pictures/wallpaper.jpg
THEMECONF

# ── Main.qml ──────────────────────────────────────────────────
sudo tee "$THEME_DIR/Main.qml" > /dev/null << 'QML'
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080

    // Kanagawa Wave palette
    readonly property color bgDark:     "#1F1F28"
    readonly property color bgDarker:   "#16161D"
    readonly property color fg:         "#DCD7BA"
    readonly property color fgMuted:    "#727169"
    readonly property color accent:     "#98BB6C"
    readonly property color red:        "#C34043"
    readonly property color surface:    "#2A2A37"
    readonly property color border:     "#54546D"

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
            statusMsg.color = root.accent
            statusMsg.text = textConstants.loginSucceeded
        }
        onLoginFailed: {
            passwordField.text = ""
            statusMsg.color = root.red
            statusMsg.text = textConstants.loginFailed
        }
        onInformationMessage: {
            statusMsg.color = root.red
            statusMsg.text = message
        }
    }

    // Wallpaper background
    Image {
        id: wallpaper
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        visible: false
    }

    // Blur the wallpaper
    FastBlur {
        anchors.fill: wallpaper
        source: wallpaper
        radius: 48
    }

    // Dark overlay
    Rectangle {
        anchors.fill: parent
        color: root.bgDark
        opacity: 0.55
    }

    // Clock at top
    Text {
        id: clock
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.fg
        font.family: "JetBrains Mono Nerd Font"
        font.pixelSize: 72
        font.weight: Font.Light
        text: Qt.formatTime(new Date(), "HH:mm")

        Timer {
            interval: 30000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatTime(new Date(), "HH:mm")
        }
    }

    Text {
        id: dateText
        anchors.top: clock.bottom
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.fgMuted
        font.family: "JetBrains Mono Nerd Font"
        font.pixelSize: 16
        text: Qt.formatDate(new Date(), "dddd, d MMMM")
    }

    // Login card
    Rectangle {
        id: card
        width: 340
        height: cardColumn.implicitHeight + 60
        anchors.centerIn: parent
        color: root.bgDark
        radius: 12
        border.width: 1
        border.color: root.border
        opacity: 0.92

        Column {
            id: cardColumn
            anchors.centerIn: parent
            width: parent.width - 60
            spacing: 16

            // User greeting
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Welcome"
                color: root.fg
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 20
                font.weight: Font.DemiBold
            }

            // Username field
            TextField {
                id: nameField
                width: parent.width
                height: 40
                placeholderText: "Username"
                text: userModel.lastUser
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 13
                color: root.fg
                selectionColor: root.accent
                leftPadding: 12

                background: Rectangle {
                    color: root.surface
                    radius: 6
                    border.width: nameField.activeFocus ? 2 : 1
                    border.color: nameField.activeFocus ? root.accent : root.border
                }

                placeholderTextColor: root.fgMuted

                KeyNavigation.tab: passwordField
                Keys.onReturnPressed: sddm.login(nameField.text, passwordField.text, sessionIndex)
            }

            // Password field
            TextField {
                id: passwordField
                width: parent.width
                height: 40
                placeholderText: "Password"
                echoMode: TextInput.Password
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 13
                color: root.fg
                selectionColor: root.accent
                leftPadding: 12

                background: Rectangle {
                    color: root.surface
                    radius: 6
                    border.width: passwordField.activeFocus ? 2 : 1
                    border.color: passwordField.activeFocus ? root.accent : root.border
                }

                placeholderTextColor: root.fgMuted

                KeyNavigation.tab: loginButton
                Keys.onReturnPressed: sddm.login(nameField.text, passwordField.text, sessionIndex)
            }

            // Status message
            Text {
                id: statusMsg
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 11
                color: root.red
                text: ""
                height: text ? implicitHeight : 0
            }

            // Login button
            Button {
                id: loginButton
                width: parent.width
                height: 40
                text: "Login"
                font.family: "JetBrains Mono Nerd Font"
                font.pixelSize: 13
                font.weight: Font.DemiBold

                contentItem: Text {
                    text: loginButton.text
                    font: loginButton.font
                    color: root.bgDark
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: loginButton.hovered ? Qt.lighter(root.accent, 1.15) : root.accent
                    radius: 6
                }

                onClicked: sddm.login(nameField.text, passwordField.text, sessionIndex)

                KeyNavigation.tab: nameField
                Keys.onReturnPressed: clicked()
            }
        }
    }

    // Session selector — bottom left
    ComboBox {
        id: session
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 20
        width: 180
        height: 32
        model: sessionModel
        currentIndex: sessionModel.lastIndex
        font.family: "JetBrains Mono Nerd Font"
        font.pixelSize: 12

        contentItem: Text {
            text: session.currentText
            color: root.fgMuted
            font: session.font
            leftPadding: 10
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            color: root.bgDark
            radius: 6
            border.width: 1
            border.color: root.border
            opacity: 0.8
        }

        delegate: ItemDelegate {
            width: session.width
            contentItem: Text {
                text: model.name
                color: root.fg
                font: session.font
            }
            background: Rectangle {
                color: highlighted ? root.surface : root.bgDark
            }
            highlighted: session.highlightedIndex === index
        }

        popup: Popup {
            y: -contentItem.implicitHeight - 4
            width: session.width
            implicitHeight: contentItem.implicitHeight
            padding: 1

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: session.popup.visible ? session.delegateModel : null
                ScrollIndicator.vertical: ScrollIndicator {}
            }

            background: Rectangle {
                color: root.bgDark
                radius: 6
                border.width: 1
                border.color: root.border
            }
        }

        indicator: Text {
            x: session.width - width - 10
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: root.fgMuted
            font.family: "JetBrains Mono Nerd Font"
            font.pixelSize: 10
        }
    }

    // Power buttons — bottom right
    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 12

        Text {
            text: "Reboot"
            color: root.fgMuted
            font.family: "JetBrains Mono Nerd Font"
            font.pixelSize: 12

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = root.fg
                onExited: parent.color = root.fgMuted
                onClicked: sddm.reboot()
            }
        }

        Text {
            text: "|"
            color: root.border
            font.family: "JetBrains Mono Nerd Font"
            font.pixelSize: 12
        }

        Text {
            text: "Shutdown"
            color: root.fgMuted
            font.family: "JetBrains Mono Nerd Font"
            font.pixelSize: 12

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = root.fg
                onExited: parent.color = root.fgMuted
                onClicked: sddm.powerOff()
            }
        }
    }

    Component.onCompleted: {
        if (nameField.text === "")
            nameField.focus = true
        else
            passwordField.focus = true
    }
}
QML

# ── Set as active theme ────────────────────────────────────────
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=kanagawa" | sudo tee /etc/sddm.conf.d/theme.conf > /dev/null

echo "Kanagawa SDDM theme installed and activated."
