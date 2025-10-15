// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../themes"
import "."

/**
 * Add Friend Dialog
 * Modern dialog for adding new contacts
 */
ModernDialog {
    id: addFriendDialog
    
    title: "Add Friend"
    iconEmoji: "👤"
    width: 500
    height: contentLayout.implicitHeight + 180
    
    signal friendAdded(string toxId, string message)
    
    contentItem: ColumnLayout {
        id: contentLayout
        spacing: Theme.spacing * 2
        
        // Instructions
        Label {
            Layout.fillWidth: true
            text: "Enter your friend's Tox ID to send them a friend request"
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.textSecondaryColor
            wrapMode: Text.WordWrap
        }
        
        // Tox ID input
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing / 2
            
            Label {
                text: "Tox ID *"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.DemiBold
                color: Theme.textPrimaryColor
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                color: Theme.backgroundColor
                radius: Theme.radiusMedium
                border.width: toxIdField.activeFocus ? 2 : 1
                border.color: {
                    if (toxIdField.activeFocus) return Theme.accentColor
                    if (!toxIdField.acceptableInput && toxIdField.text.length > 0) return "#FF3B30"
                    return Theme.borderColor
                }
                
                Behavior on border.color {
                    ColorAnimation { duration: Theme.animationFast }
                }
                
                TextField {
                    id: toxIdField
                    anchors.fill: parent
                    anchors.margins: Theme.spacing
                    background: Item {}
                    placeholderText: "76 character Tox ID..."
                    color: Theme.textPrimaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    font.family: "monospace"
                    
                    // Tox ID validation (76 hex characters)
                    validator: RegularExpressionValidator {
                        regularExpression: /^[0-9A-Fa-f]{76}$/
                    }
                    
                    onTextChanged: {
                        errorLabel.visible = false
                    }
                }
            }
            
            // Validation hint
            Label {
                text: "A Tox ID is 76 hexadecimal characters"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textSecondaryColor
                opacity: 0.7
            }
        }
        
        // Optional message
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing / 2
            
            Label {
                text: "Message (optional)"
                font.pixelSize: Theme.fontSizeSmall
                font.weight: Font.DemiBold
                color: Theme.textPrimaryColor
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: Theme.backgroundColor
                radius: Theme.radiusMedium
                border.width: messageField.activeFocus ? 2 : 1
                border.color: messageField.activeFocus ? Theme.accentColor : Theme.borderColor
                
                Behavior on border.color {
                    ColorAnimation { duration: Theme.animationFast }
                }
                
                ScrollView {
                    anchors.fill: parent
                    anchors.margins: Theme.spacing
                    clip: true
                    
                    TextArea {
                        id: messageField
                        background: Item {}
                        placeholderText: "Hi! I'd like to add you to my contacts"
                        color: Theme.textPrimaryColor
                        font.pixelSize: Theme.fontSizeNormal
                        wrapMode: TextArea.Wrap
                        
                        text: "Hi! I'd like to add you to my contacts."
                    }
                }
            }
            
            Label {
                text: messageField.length + " / 1024 characters"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textSecondaryColor
                opacity: 0.7
            }
        }
        
        // Error message
        Label {
            id: errorLabel
            Layout.fillWidth: true
            visible: false
            text: "Invalid Tox ID. Please check and try again."
            color: "#FF3B30"
            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
        }
    }
    
    // Footer buttons
    footer: Item {
        implicitHeight: 72
        
        Rectangle {
            anchors.fill: parent
            color: Theme.backgroundColor
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing * 2
            spacing: Theme.spacing
            
            Item { Layout.fillWidth: true }
            
            ModernButton {
                text: "Cancel"
                outlined: true
                buttonColor: Theme.textSecondaryColor
                Layout.preferredWidth: 100
                
                onClicked: addFriendDialog.reject()
            }
            
            ModernButton {
                text: "Send Request"
                buttonColor: Theme.accentColor
                Layout.preferredWidth: 140
                enabled: toxIdField.acceptableInput
                
                onClicked: {
                    if (toxIdField.acceptableInput) {
                        addFriendDialog.friendAdded(toxIdField.text, messageField.text)
                        addFriendDialog.accept()
                    } else {
                        errorLabel.visible = true
                    }
                }
            }
        }
    }
    
    // Reset on close
    onClosed: {
        toxIdField.text = ""
        messageField.text = "Hi! I'd like to add you to my contacts."
        errorLabel.visible = false
    }
    
    // Focus Tox ID field when opened
    onOpened: {
        toxIdField.forceActiveFocus()
    }
}
