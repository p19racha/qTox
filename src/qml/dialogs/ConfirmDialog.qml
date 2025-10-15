// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../themes"
import "."

/**
 * Confirm Dialog
 * Simple confirmation dialog with customizable message and actions
 */
ModernDialog {
    id: confirmDialog
    
    property string message: "Are you sure?"
    property string confirmText: "Confirm"
    property string cancelText: "Cancel"
    property color confirmColor: Theme.accentColor
    property bool destructive: false
    
    title: "Confirm Action"
    iconEmoji: destructive ? "⚠️" : "❓"
    width: 420
    height: contentLayout.implicitHeight + 160
    
    signal confirmed()
    signal cancelled()
    
    contentItem: ColumnLayout {
        id: contentLayout
        spacing: Theme.spacing * 2
        
        Label {
            Layout.fillWidth: true
            text: message
            font.pixelSize: Theme.fontSizeNormal
            color: Theme.textPrimaryColor
            wrapMode: Text.WordWrap
            lineHeight: 1.4
        }
        
        // Warning for destructive actions
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: warningLayout.implicitHeight + Theme.spacing * 2
            visible: destructive
            color: Qt.rgba(1, 0.23, 0.19, 0.1)
            radius: Theme.radiusMedium
            border.width: 1
            border.color: Qt.rgba(1, 0.23, 0.19, 0.3)
            
            RowLayout {
                id: warningLayout
                anchors.fill: parent
                anchors.margins: Theme.spacing * 1.5
                spacing: Theme.spacing
                
                Label {
                    text: "⚠️"
                    font.pixelSize: 20
                }
                
                Label {
                    Layout.fillWidth: true
                    text: "This action cannot be undone"
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.DemiBold
                    color: "#FF3B30"
                    wrapMode: Text.WordWrap
                }
            }
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
                text: cancelText
                outlined: true
                buttonColor: Theme.textSecondaryColor
                Layout.preferredWidth: 100
                
                onClicked: {
                    confirmDialog.cancelled()
                    confirmDialog.reject()
                }
            }
            
            ModernButton {
                text: confirmText
                buttonColor: destructive ? "#FF3B30" : confirmColor
                Layout.preferredWidth: 120
                
                onClicked: {
                    confirmDialog.confirmed()
                    confirmDialog.accept()
                }
            }
        }
    }
}
