// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Message Bubble (Refined)

import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import "../../themes"

Item {
    id: root
    
    property string message: ""
    property string timestamp: ""
    property bool sent: false
    property bool delivered: false
    property bool read: false
    
    implicitWidth: Math.min(contentColumn.width + 24, parent.width * 0.75)
    implicitHeight: contentColumn.height + 24
    
    // Shadow layer for dark mode
    DropShadow {
        anchors.fill: bubble
        source: bubble
        horizontalOffset: 0
        verticalOffset: 1
        radius: sent ? 3 : 4
        samples: 8
        color: PremiumTheme.messageShadow
        visible: true
    }
    
    Rectangle {
        id: bubble
        anchors.fill: parent
        radius: 12
        color: sent ? PremiumTheme.messageSent : PremiumTheme.messageReceived
        border.width: 0
        border.color: PremiumTheme.border
        
        Column {
            id: contentColumn
            anchors.centerIn: parent
            spacing: 4
            
            Text {
                text: root.message
                font.family: PremiumTheme.fontFamily
                font.pixelSize: 15
                color: sent ? PremiumTheme.textOnSent : PremiumTheme.textPrimary
                wrapMode: Text.Wrap
                width: Math.min(implicitWidth, root.parent.width * 0.75 - 24)
            }
            
            Row {
                spacing: 4
                anchors.right: parent.right
                
                Text {
                    text: timestamp
                    font.family: PremiumTheme.fontFamily
                    font.pixelSize: 11
                    color: sent ? "rgba(240, 242, 245, 0.6)" : PremiumTheme.textTertiary
                }
                
                Text {
                    visible: sent
                    text: read ? "✓✓" : (delivered ? "✓✓" : "✓")
                    font.family: PremiumTheme.fontFamily
                    font.pixelSize: 11
                    color: read ? PremiumTheme.primary : "rgba(240, 242, 245, 0.6)"
                }
            }
        }
    }
    
    // Hover effect
    Rectangle {
        anchors.fill: bubble
        radius: bubble.radius
        color: PremiumTheme.hoverOverlay
        opacity: mouseArea.containsMouse ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: PremiumTheme.durationFast }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
    
    Component.onCompleted: {
        opacity = 0
        y = y + 20
        opacityAnim.start()
        slideAnim.start()
    }
    
    NumberAnimation {
        id: opacityAnim
        target: root
        property: "opacity"
        from: 0
        to: 1
        duration: 250
        easing.type: Easing.OutCubic
    }
    
    NumberAnimation {
        id: slideAnim
        target: root
        property: "y"
        from: root.y
        to: root.y - 20
        duration: 250
        easing.type: Easing.OutCubic
    }
}
