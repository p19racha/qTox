// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"
import "dialogs"
import "themes"

/**
 * Dialogs Demo Application
 * Showcases all modern dialog components
 */
ApplicationWindow {
    id: dialogsDemoWindow
    
    visible: true
    width: 800
    height: 600
    minimumWidth: 600
    minimumHeight: 400
    title: "qTox Modern Dialogs - Demo"
    
    color: Theme.backgroundColor
    
    // Dialogs
    AddFriendDialog {
        id: addFriendDialog
        
        onFriendAdded: function(toxId, message) {
            statusLabel.text = "✓ Friend request sent!"
            statusLabel.color = "#34C759"
        }
    }
    
    FileTransferDialog {
        id: fileTransferDialog
        fileName: "Ubuntu-24.04-desktop-amd64.iso"
        fileSize: 5 * 1024 * 1024 * 1024 // 5 GB
    }
    
    ConfirmDialog {
        id: confirmDialog
        message: "Do you want to clear all chat history? This will delete all messages permanently."
        confirmText: "Clear History"
        destructive: true
        
        onConfirmed: {
            statusLabel.text = "⚠️ History would be cleared (demo)"
            statusLabel.color = "#FF3B30"
        }
    }
    
    ConfirmDialog {
        id: simpleConfirm
        message: "Would you like to enable desktop notifications for new messages?"
        confirmText: "Enable"
        title: "Enable Notifications"
        iconEmoji: "🔔"
        
        onConfirmed: {
            statusLabel.text = "✓ Notifications enabled (demo)"
            statusLabel.color = "#34C759"
        }
    }
    
    // Main content
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacing * 3
        spacing: Theme.spacing * 3
        
        // Header
        Label {
            text: "Modern Dialog Components"
            font.pixelSize: 28
            font.weight: Font.Bold
            color: Theme.textPrimaryColor
        }
        
        Label {
            Layout.fillWidth: true
            text: "Click the buttons below to preview each dialog component with smooth animations"
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.textSecondaryColor
            wrapMode: Text.WordWrap
        }
        
        // Dialog buttons
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: Theme.spacing * 2
            columnSpacing: Theme.spacing * 2
            
            // Add Friend Dialog
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: Theme.surfaceColor
                radius: Theme.radiusLarge
                border.width: 1
                border.color: Theme.borderColor
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing * 2
                    spacing: Theme.spacing
                    
                    Label {
                        text: "👤"
                        font.pixelSize: 32
                    }
                    
                    Label {
                        text: "Add Friend Dialog"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                        color: Theme.textPrimaryColor
                    }
                    
                    Label {
                        Layout.fillWidth: true
                        text: "Form with validation, custom message"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondaryColor
                        wrapMode: Text.WordWrap
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    ModernButton {
                        text: "Show Dialog"
                        buttonColor: Theme.accentColor
                        Layout.preferredWidth: 120
                        
                        onClicked: addFriendDialog.open()
                    }
                }
            }
            
            // File Transfer Dialog
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: Theme.surfaceColor
                radius: Theme.radiusLarge
                border.width: 1
                border.color: Theme.borderColor
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing * 2
                    spacing: Theme.spacing
                    
                    Label {
                        text: "📁"
                        font.pixelSize: 32
                    }
                    
                    Label {
                        text: "File Transfer Dialog"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                        color: Theme.textPrimaryColor
                    }
                    
                    Label {
                        Layout.fillWidth: true
                        text: "Progress bar, speed, ETA display"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondaryColor
                        wrapMode: Text.WordWrap
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    ModernButton {
                        text: "Show Dialog"
                        buttonColor: Theme.accentColor
                        Layout.preferredWidth: 120
                        
                        onClicked: fileTransferDialog.open()
                    }
                }
            }
            
            // Destructive Confirm
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: Theme.surfaceColor
                radius: Theme.radiusLarge
                border.width: 1
                border.color: Theme.borderColor
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing * 2
                    spacing: Theme.spacing
                    
                    Label {
                        text: "⚠️"
                        font.pixelSize: 32
                    }
                    
                    Label {
                        text: "Destructive Confirm"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                        color: Theme.textPrimaryColor
                    }
                    
                    Label {
                        Layout.fillWidth: true
                        text: "Warning style for irreversible actions"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondaryColor
                        wrapMode: Text.WordWrap
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    ModernButton {
                        text: "Show Dialog"
                        buttonColor: "#FF3B30"
                        Layout.preferredWidth: 120
                        
                        onClicked: confirmDialog.open()
                    }
                }
            }
            
            // Simple Confirm
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: Theme.surfaceColor
                radius: Theme.radiusLarge
                border.width: 1
                border.color: Theme.borderColor
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing * 2
                    spacing: Theme.spacing
                    
                    Label {
                        text: "❓"
                        font.pixelSize: 32
                    }
                    
                    Label {
                        text: "Simple Confirm"
                        font.pixelSize: Theme.fontSizeMedium
                        font.weight: Font.DemiBold
                        color: Theme.textPrimaryColor
                    }
                    
                    Label {
                        Layout.fillWidth: true
                        text: "Basic yes/no confirmation dialog"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondaryColor
                        wrapMode: Text.WordWrap
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    ModernButton {
                        text: "Show Dialog"
                        buttonColor: Theme.accentColor
                        Layout.preferredWidth: 120
                        
                        onClicked: simpleConfirm.open()
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true }
        
        // Status label
        Label {
            id: statusLabel
            Layout.fillWidth: true
            text: "Click a button above to see the dialogs in action"
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.textSecondaryColor
            horizontalAlignment: Text.AlignHCenter
        }
        
        // Features list
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: featuresList.implicitHeight + Theme.spacing * 3
            color: Theme.surfaceColor
            radius: Theme.radiusLarge
            border.width: 1
            border.color: Theme.borderColor
            
            ColumnLayout {
                id: featuresList
                anchors.fill: parent
                anchors.margins: Theme.spacing * 2
                spacing: Theme.spacing
                
                Label {
                    text: "✨ Dialog Features"
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.Bold
                    color: Theme.textPrimaryColor
                }
                
                Repeater {
                    model: [
                        "Smooth fade + scale animations (200ms)",
                        "Modern card-style design with shadows",
                        "Full keyboard support (Esc to close)",
                        "Customizable icons, colors, and buttons",
                        "Responsive layout adapts to content",
                        "Modal overlay with dimming effect"
                    ]
                    
                    Label {
                        text: "• " + modelData
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textSecondaryColor
                    }
                }
            }
        }
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
    
    Shortcut {
        sequence: "Ctrl+W"
        onActivated: Qt.quit()
    }
    
    Shortcut {
        sequence: "Ctrl+1"
        onActivated: addFriendDialog.open()
    }
    
    Shortcut {
        sequence: "Ctrl+2"
        onActivated: fileTransferDialog.open()
    }
    
    Shortcut {
        sequence: "Ctrl+3"
        onActivated: confirmDialog.open()
    }
    
    Shortcut {
        sequence: "Ctrl+4"
        onActivated: simpleConfirm.open()
    }
}
