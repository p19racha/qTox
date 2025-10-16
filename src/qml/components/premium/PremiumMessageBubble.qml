// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Message Bubble (WhatsApp-style)

import QtQuick 2.15
import Qt5Compat.GraphicalEffects
import "../../themes"

Item {
    id: root
    
    // ═══════════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════
    
    property string message: ""
    property string timestamp: ""
    property bool sent: false  // true = sent by user, false = received
    property bool delivered: false
    property bool read: false
    property bool isGrouped: false  // Part of message group
    property bool isFirst: false    // First in group
    property bool isLast: false     // Last in group
    
    implicitWidth: Math.min(messageContent.width + PremiumTheme.spacingMd * 2, 
                           parent.width * 0.75)
    implicitHeight: messageContent.height + PremiumTheme.spacingMd * 2
    
    // ═══════════════════════════════════════════════════════════════
    // BUBBLE BACKGROUND - WhatsApp style with tail
    // ═══════════════════════════════════════════════════════════════
    
    Item {
        id: bubbleContainer
        anchors.fill: parent
        
        // Main bubble
        Rectangle {
            id: bubble
            anchors.fill: parent
            radius: PremiumTheme.radiusLarge
            
            // WhatsApp-style colors
            color: sent ? PremiumTheme.messageSent : PremiumTheme.messageReceived
            
            // Glossy overlay for depth
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "rgba(255, 255, 255, 0.08)" }
                    GradientStop { position: 0.5; color: "rgba(255, 255, 255, 0.02)" }
                    GradientStop { position: 1.0; color: "rgba(0, 0, 0, 0.03)" }
                }
            }
            
            // Hover effect
            Rectangle {
                id: hoverOverlay
                anchors.fill: parent
                radius: parent.radius
                color: sent ? PremiumTheme.messageSentHover : PremiumTheme.messageReceivedHover
                opacity: 0
                
                Behavior on opacity {
                    NumberAnimation {
                        duration: PremiumTheme.durationFast
                        easing.type: PremiumTheme.easingStandard
                    }
                }
            }
            
            // Subtle border
            border.width: sent ? 0 : 1
            border.color: sent ? "transparent" : PremiumTheme.border
            
            // Smooth scale on interaction
            transform: Scale {
                id: bubbleScale
                origin.x: sent ? bubble.width : 0
                origin.y: bubble.height / 2
                xScale: 1.0
                yScale: 1.0
                
                Behavior on xScale {
                    NumberAnimation {
                        duration: PremiumTheme.durationFast
                        easing.type: PremiumTheme.easingSpring
                    }
                }
                Behavior on yScale {
                    NumberAnimation {
                        duration: PremiumTheme.durationFast
                        easing.type: PremiumTheme.easingSpring
                    }
                }
            }
        }
        
        // WhatsApp-style tail (only for last message in group)
        Canvas {
            id: tail
            width: 12
            height: 12
            visible: isLast || !isGrouped
            anchors.bottom: bubble.bottom
            anchors.bottomMargin: 8
            anchors.left: sent ? undefined : bubble.left
            anchors.leftMargin: sent ? 0 : -6
            anchors.right: sent ? bubble.right : undefined
            anchors.rightMargin: sent ? -6 : 0
            
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                
                ctx.fillStyle = sent ? PremiumTheme.messageSent : PremiumTheme.messageReceived
                ctx.beginPath()
                
                if (sent) {
                    // Tail pointing right
                    ctx.moveTo(6, 0)
                    ctx.lineTo(0, 0)
                    ctx.quadraticCurveTo(6, 4, 12, 12)
                    ctx.lineTo(6, 0)
                } else {
                    // Tail pointing left
                    ctx.moveTo(6, 0)
                    ctx.lineTo(12, 0)
                    ctx.quadraticCurveTo(6, 4, 0, 12)
                    ctx.lineTo(6, 0)
                }
                
                ctx.closePath()
                ctx.fill()
            }
            
            // Redraw when theme changes
            Connections {
                target: PremiumTheme
                function onIsDarkChanged() {
                    tail.requestPaint()
                }
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM SHADOW - Soft depth
    // ═══════════════════════════════════════════════════════════════
    
    DropShadow {
        anchors.fill: bubble
        source: bubble
        horizontalOffset: 0
        verticalOffset: 2
        radius: PremiumTheme.shadowSmall
        samples: 9
        color: PremiumTheme.shadowColor
        opacity: 0.15
        cached: true
    }
    
    // ═══════════════════════════════════════════════════════════════
    // MESSAGE CONTENT
    // ═══════════════════════════════════════════════════════════════
    
    Column {
        id: messageContent
        anchors.centerIn: parent
        spacing: PremiumTheme.spacing2xs
        
        // Message text
        Text {
            id: messageText
            text: root.message
            font.family: PremiumTheme.fontFamily
            font.pixelSize: PremiumTheme.fontSizeMd
            font.weight: PremiumTheme.fontWeightRegular
            color: sent ? "#f0f2f5" : PremiumTheme.textPrimary
            wrapMode: Text.Wrap
            lineHeight: PremiumTheme.lineHeightNormal
            width: Math.min(implicitWidth, root.parent.width * 0.75 - PremiumTheme.spacingMd * 2)
        }
        
        // Timestamp and status row
        Row {
            spacing: PremiumTheme.spacing2xs
            anchors.right: parent.right
            
            // Timestamp
            Text {
                text: timestamp
                font.family: PremiumTheme.fontFamily
                font.pixelSize: PremiumTheme.fontSizeXs
                font.weight: PremiumTheme.fontWeightRegular
                color: sent ? "rgba(240, 242, 245, 0.6)" : PremiumTheme.textTertiary
                anchors.verticalCenter: parent.verticalCenter
            }
            
            // Read/delivered status (for sent messages)
            Text {
                visible: sent
                text: read ? "✓✓" : (delivered ? "✓✓" : "✓")
                font.family: PremiumTheme.fontFamily
                font.pixelSize: PremiumTheme.fontSizeXs
                color: read ? PremiumTheme.primary : "rgba(240, 242, 245, 0.6)"
                anchors.verticalCenter: parent.verticalCenter
                
                Behavior on color {
                    ColorAnimation {
                        duration: PremiumTheme.durationNormal
                        easing.type: PremiumTheme.easingStandard
                    }
                }
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // INTERACTION - Smooth hover effects
    // ═══════════════════════════════════════════════════════════════
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onEntered: {
            hoverOverlay.opacity = 0.5
            bubbleScale.xScale = 1.01
            bubbleScale.yScale = 1.01
        }
        
        onExited: {
            hoverOverlay.opacity = 0
            bubbleScale.xScale = 1.0
            bubbleScale.yScale = 1.0
        }
        
        onPressed: {
            bubbleScale.xScale = 0.99
            bubbleScale.yScale = 0.99
        }
        
        onReleased: {
            if (containsMouse) {
                bubbleScale.xScale = 1.01
                bubbleScale.yScale = 1.01
            } else {
                bubbleScale.xScale = 1.0
                bubbleScale.yScale = 1.0
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // ENTRANCE ANIMATION - Smooth slide and fade
    // ═══════════════════════════════════════════════════════════════
    
    Component.onCompleted: {
        // Start offscreen
        opacity = 0
        y = y + 20
        
        // Animate in
        entranceAnimation.start()
    }
    
    ParallelAnimation {
        id: entranceAnimation
        
        NumberAnimation {
            target: root
            property: "opacity"
            from: 0
            to: 1
            duration: PremiumTheme.durationNormal
            easing.type: PremiumTheme.easingDecelerate
        }
        
        NumberAnimation {
            target: root
            property: "y"
            from: root.y
            to: root.y - 20
            duration: PremiumTheme.durationNormal
            easing.type: PremiumTheme.easingDecelerate
        }
    }
}
