// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Contact Card (Telegram-style)

import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import "../../themes"

Item {
    id: root
    
    // ═══════════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════
    
    property string name: ""
    property string lastMessage: ""
    property string timestamp: ""
    property string avatarText: ""  // Initials for avatar
    property color avatarColor: PremiumTheme.primary
    property bool online: false
    property int unreadCount: 0
    property bool selected: false
    property bool typing: false
    
    signal clicked()
    
    implicitWidth: parent.width
    implicitHeight: 72
    
    // ═══════════════════════════════════════════════════════════════
    // CARD BACKGROUND - Glossy surface
    // ═══════════════════════════════════════════════════════════════
    
    Rectangle {
        id: cardBackground
        anchors.fill: parent
        color: selected ? 
            (PremiumTheme.isDark ? "rgba(255, 255, 255, 0.08)" : "rgba(0, 0, 0, 0.05)") :
            PremiumTheme.backgroundPrimary
        
        // Hover overlay
        Rectangle {
            id: hoverOverlay
            anchors.fill: parent
            color: PremiumTheme.isDark ? "rgba(255, 255, 255, 0.04)" : "rgba(0, 0, 0, 0.03)"
            opacity: 0
            
            Behavior on opacity {
                NumberAnimation {
                    duration: PremiumTheme.durationFast
                    easing.type: PremiumTheme.easingStandard
                }
            }
        }
        
        // Press overlay
        Rectangle {
            id: pressOverlay
            anchors.fill: parent
            color: PremiumTheme.isDark ? "rgba(255, 255, 255, 0.06)" : "rgba(0, 0, 0, 0.05)"
            opacity: 0
            
            Behavior on opacity {
                NumberAnimation {
                    duration: PremiumTheme.durationInstant
                    easing.type: PremiumTheme.easingStandard
                }
            }
        }
        
        // Selected indicator (left border)
        Rectangle {
            visible: selected
            width: 4
            height: parent.height
            color: PremiumTheme.primary
            anchors.left: parent.left
            
            // Smooth grow animation
            transform: Scale {
                origin.y: height / 2
                yScale: selectedIndicatorScale.yScale
            }
            
            NumberAnimation on transform {
                id: selectedIndicatorScale
                property real yScale: 1.0
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // CONTENT LAYOUT
    // ═══════════════════════════════════════════════════════════════
    
    Row {
        anchors.fill: parent
        anchors.margins: PremiumTheme.spacingMd
        spacing: PremiumTheme.spacingMd
        
        // ═══════════════════════════════════════════════════════════
        // AVATAR - Premium circular design
        // ═══════════════════════════════════════════════════════════
        
        Item {
            width: PremiumTheme.avatarSizeLarge
            height: PremiumTheme.avatarSizeLarge
            anchors.verticalCenter: parent.verticalCenter
            
            // Avatar background with gradient
            Rectangle {
                id: avatar
                anchors.fill: parent
                radius: width / 2
                color: avatarColor
                
                // Initials text
                Text {
                    anchors.centerIn: parent
                    text: avatarText
                    font.family: PremiumTheme.fontFamily
                    font.pixelSize: PremiumTheme.fontSizeLg
                    font.weight: PremiumTheme.fontWeightMedium
                    color: "white"
                }
                
                // Glossy ring
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: 2
                    border.color: "rgba(255, 255, 255, 0.15)"
                }
            }
            
            // Online status indicator
            Rectangle {
                visible: online
                width: 16
                height: 16
                radius: width / 2
                color: PremiumTheme.online
                anchors.bottom: avatar.bottom
                anchors.right: avatar.right
                anchors.bottomMargin: 2
                anchors.rightMargin: 2
                border.width: 3
                border.color: PremiumTheme.backgroundPrimary
                
                // Pulse animation
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    running: online
                    NumberAnimation { from: 1.0; to: 1.2; duration: 1000; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 1.2; to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                }
            }
            
            // Premium shadow
            DropShadow {
                anchors.fill: avatar
                source: avatar
                horizontalOffset: 0
                verticalOffset: 2
                radius: 4
                samples: 9
                color: PremiumTheme.shadowColor
                opacity: 0.2
                cached: true
            }
        }
        
        // ═══════════════════════════════════════════════════════════
        // TEXT CONTENT
        // ═══════════════════════════════════════════════════════════
        
        Column {
            width: parent.width - PremiumTheme.avatarSizeLarge - PremiumTheme.spacingMd * 3 - 60
            anchors.verticalCenter: parent.verticalCenter
            spacing: PremiumTheme.spacing2xs
            
            // Contact name
            Text {
                text: name
                font.family: PremiumTheme.fontFamily
                font.pixelSize: PremiumTheme.fontSizeMd
                font.weight: unreadCount > 0 ? PremiumTheme.fontWeightSemibold : PremiumTheme.fontWeightMedium
                color: PremiumTheme.textPrimary
                elide: Text.ElideRight
                width: parent.width
            }
            
            // Last message or typing indicator
            Row {
                spacing: PremiumTheme.spacing2xs
                width: parent.width
                
                // Typing indicator
                Row {
                    visible: typing
                    spacing: 4
                    
                    Repeater {
                        model: 3
                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: PremiumTheme.primary
                            
                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                running: typing
                                PauseAnimation { duration: index * 150 }
                                NumberAnimation { from: 0.3; to: 1.0; duration: 400 }
                                NumberAnimation { from: 1.0; to: 0.3; duration: 400 }
                            }
                        }
                    }
                    
                    Text {
                        text: "typing"
                        font.family: PremiumTheme.fontFamily
                        font.pixelSize: PremiumTheme.fontSizeSm
                        color: PremiumTheme.primary
                        font.italic: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                // Last message text
                Text {
                    visible: !typing
                    text: lastMessage
                    font.family: PremiumTheme.fontFamily
                    font.pixelSize: PremiumTheme.fontSizeSm
                    color: PremiumTheme.textSecondary
                    elide: Text.ElideRight
                    width: parent.width - (typing ? 80 : 0)
                }
            }
        }
        
        // ═══════════════════════════════════════════════════════════
        // RIGHT SIDE - Timestamp and badge
        // ═══════════════════════════════════════════════════════════
        
        Column {
            width: 60
            anchors.verticalCenter: parent.verticalCenter
            spacing: PremiumTheme.spacing2xs
            
            // Timestamp
            Text {
                text: timestamp
                font.family: PremiumTheme.fontFamily
                font.pixelSize: PremiumTheme.fontSizeXs
                color: unreadCount > 0 ? PremiumTheme.primary : PremiumTheme.textTertiary
                font.weight: unreadCount > 0 ? PremiumTheme.fontWeightMedium : PremiumTheme.fontWeightRegular
                anchors.right: parent.right
            }
            
            // Unread badge
            Rectangle {
                visible: unreadCount > 0
                width: Math.max(PremiumTheme.badgeSize, badgeText.width + 8)
                height: PremiumTheme.badgeSize
                radius: height / 2
                color: PremiumTheme.unreadBadge
                anchors.right: parent.right
                
                Text {
                    id: badgeText
                    text: unreadCount > 99 ? "99+" : unreadCount.toString()
                    anchors.centerIn: parent
                    font.family: PremiumTheme.fontFamily
                    font.pixelSize: PremiumTheme.fontSizeXs
                    font.weight: PremiumTheme.fontWeightBold
                    color: "white"
                }
                
                // Pulse animation for new messages
                SequentialAnimation on scale {
                    loops: 3
                    running: unreadCount > 0
                    NumberAnimation { from: 1.0; to: 1.15; duration: 200; easing.type: Easing.OutQuad }
                    NumberAnimation { from: 1.15; to: 1.0; duration: 200; easing.type: Easing.InQuad }
                    PauseAnimation { duration: 800 }
                }
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // DIVIDER - Subtle bottom border
    // ═══════════════════════════════════════════════════════════════
    
    Rectangle {
        width: parent.width - PremiumTheme.spacingMd - PremiumTheme.avatarSizeLarge - PremiumTheme.spacingMd
        height: 1
        color: PremiumTheme.divider
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: PremiumTheme.spacingMd
    }
    
    // ═══════════════════════════════════════════════════════════════
    // INTERACTION - Smooth micro-animations
    // ═══════════════════════════════════════════════════════════════
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            hoverOverlay.opacity = 1.0
        }
        
        onExited: {
            hoverOverlay.opacity = 0
            pressOverlay.opacity = 0
        }
        
        onPressed: {
            pressOverlay.opacity = 1.0
        }
        
        onReleased: {
            pressOverlay.opacity = 0
        }
        
        onClicked: {
            root.clicked()
        }
    }
}
