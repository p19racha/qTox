// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import "../components"
import themes

/**
 * Modern Dialog Component
 * Base dialog with smooth animations and modern styling
 */
Dialog {
    id: modernDialog
    
    // Custom properties
    property string iconEmoji: ""
    property color accentColor: Theme.accentColor
    property bool showCloseButton: true
    
    modal: true
    dim: true
    
    // Center in parent
    anchors.centerIn: parent
    
    // Modern styling
    background: Rectangle {
        color: Theme.surfaceColor
        radius: Theme.radiusLarge
        border.width: 1
        border.color: Theme.borderColor
        
        // Drop shadow effect
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 16.0
            samples: 17
            color: Qt.rgba(0, 0, 0, 0.15)
        }
    }
    
    // Smooth enter animation
    enter: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: Theme.animationNormal
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                property: "scale"
                from: 0.9
                to: 1.0
                duration: Theme.animationNormal
                easing.type: Easing.OutCubic
            }
        }
    }
    
    // Smooth exit animation
    exit: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: Theme.animationFast
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                property: "scale"
                from: 1.0
                to: 0.95
                duration: Theme.animationFast
                easing.type: Easing.InCubic
            }
        }
    }
    
    // Overlay dimming
    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.5)
        
        Behavior on opacity {
            NumberAnimation { duration: Theme.animationFast }
        }
    }
    
    // Header with icon and close button
    header: Rectangle {
        implicitHeight: iconEmoji.length > 0 ? 80 : 60
        color: "transparent"
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacing * 2
            spacing: Theme.spacing * 1.5
            
            // Icon emoji
            Label {
                visible: iconEmoji.length > 0
                text: iconEmoji
                font.pixelSize: 32
            }
            
            // Title
            Label {
                Layout.fillWidth: true
                text: modernDialog.title
                font.pixelSize: Theme.fontSizeLarge
                font.weight: Font.Bold
                color: Theme.textPrimaryColor
            }
            
            // Close button
            ModernButton {
                visible: showCloseButton
                text: "✕"
                outlined: true
                buttonColor: Theme.textSecondaryColor
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                font.pixelSize: Theme.fontSizeLarge
                
                onClicked: modernDialog.reject()
            }
        }
    }
    
    // Footer with action buttons (customizable via footer property)
    footer: Item {
        implicitHeight: footerLayout.implicitHeight + Theme.spacing * 3
        visible: footerLayout.children.length > 0
        
        Rectangle {
            anchors.fill: parent
            color: Theme.backgroundColor
            radius: Theme.radiusLarge
        }
        
        RowLayout {
            id: footerLayout
            anchors.fill: parent
            anchors.margins: Theme.spacing * 2
            spacing: Theme.spacing
            
            Item { Layout.fillWidth: true }
        }
    }
}
