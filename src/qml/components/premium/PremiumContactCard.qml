// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Contact Card (Refined)

import QtQuick
import QtQuick.Controls
import "../../themes"

Rectangle {
    id: root
    
    property string name: ""
    property string lastMessage: ""
    property string timestamp: ""
    property string avatarText: ""
    property color avatarColor: PremiumTheme.primary
    property bool online: false
    property int unreadCount: 0
    property bool selected: false
    property bool typing: false
    
    signal clicked()
    
    width: parent.width
    height: 72
    color: selected ? PremiumTheme.selectedOverlay : PremiumTheme.backgroundPrimary
    
    // Hover overlay
    Rectangle {
        anchors.fill: parent
        color: PremiumTheme.hoverOverlay
        opacity: !selected && mouseArea.containsMouse ? 1 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: PremiumTheme.durationFast }
        }
    }
    
    Row {
        anchors.fill: parent
        anchors.margins: PremiumTheme.spacingMd
        spacing: PremiumTheme.spacingMd
        
        // Avatar
        Rectangle {
            width: 56
            height: 56
            radius: 28
            color: avatarColor
            anchors.verticalCenter: parent.verticalCenter
            
            Text {
                text: avatarText
                anchors.centerIn: parent
                font.family: PremiumTheme.fontFamily
                font.pixelSize: 17
                font.weight: 500
                color: "white"
            }
            
            // Online indicator with pulse animation
            Rectangle {
                visible: online
                width: 14
                height: 14
                radius: 7
                color: PremiumTheme.online
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: 2
                border.width: 2
                border.color: root.color
                
                SequentialAnimation on scale {
                    running: online
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.2; duration: 1000; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 1.2; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                }
            }
        }
        
        Column {
            width: parent.width - 56 - 80 - PremiumTheme.spacingMd * 2
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            
            Text {
                text: name
                font.family: PremiumTheme.fontFamily
                font.pixelSize: 15
                font.weight: unreadCount > 0 ? 600 : 500
                color: PremiumTheme.textPrimary
                elide: Text.ElideRight
                width: parent.width
            }
            
            Text {
                text: typing ? "typing..." : lastMessage
                font.family: PremiumTheme.fontFamily
                font.pixelSize: 13
                color: typing ? PremiumTheme.primary : PremiumTheme.textSecondary
                font.italic: typing
                elide: Text.ElideRight
                width: parent.width
                font.weight: unreadCount > 0 ? 500 : 400
                
                // Typing animation
                SequentialAnimation on opacity {
                    running: typing
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 0.5; duration: 600 }
                    NumberAnimation { from: 0.5; to: 1.0; duration: 600 }
                }
            }
        }
        
        Column {
            width: 60
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
            
            Text {
                text: timestamp
                font.family: PremiumTheme.fontFamily
                font.pixelSize: 11
                color: unreadCount > 0 ? PremiumTheme.primary : PremiumTheme.textTertiary
                font.weight: unreadCount > 0 ? 600 : 400
                anchors.right: parent.right
            }
            
            Rectangle {
                visible: unreadCount > 0
                width: Math.max(18, badgeText.width + 8)
                height: 18
                radius: 9
                color: PremiumTheme.unreadBadge
                anchors.right: parent.right
                
                Text {
                    id: badgeText
                    text: unreadCount > 99 ? "99+" : unreadCount.toString()
                    anchors.centerIn: parent
                    font.family: PremiumTheme.fontFamily
                    font.pixelSize: 10
                    font.weight: 700
                    color: "white"
                }
            }
        }
    }
    
    // Bottom divider
    Rectangle {
        width: parent.width - 16
        height: 1
        color: PremiumTheme.divider
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
    
    // Selection indicator
    Rectangle {
        visible: selected
        width: 4
        height: parent.height
        color: PremiumTheme.primary
        anchors.left: parent.left
        
        Behavior on width {
            NumberAnimation { duration: PremiumTheme.durationNormal; easing.type: PremiumTheme.easingStandard }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
