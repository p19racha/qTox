// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Button Component

import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../../themes"

Item {
    id: root
    
    // ═══════════════════════════════════════════════════════════════
    // PUBLIC API
    // ═══════════════════════════════════════════════════════════════
    
    property string text: ""
    property string icon: ""
    property bool primary: false
    property bool accent: false
    property bool outlined: false
    property bool loading: false
    property bool enabled: true
    
    signal clicked()
    
    // Size
    implicitWidth: contentRow.width + PremiumTheme.spacingXl * 2
    implicitHeight: PremiumTheme.buttonHeightMedium
    
    // ═══════════════════════════════════════════════════════════════
    // BUTTON BACKGROUND - Glossy with gradient
    // ═══════════════════════════════════════════════════════════════
    
    Rectangle {
        id: background
        anchors.fill: parent
        radius: PremiumTheme.radiusLarge
        
        // Dynamic background color
        color: {
            if (!root.enabled) return PremiumTheme.isDark ? "#1f2c33" : "#f0f2f5"
            if (outlined) return "transparent"
            if (primary) return PremiumTheme.primary
            if (accent) return PremiumTheme.accent
            return PremiumTheme.surfaceElevated
        }
        
        // Border for outlined variant
        border.width: outlined ? 2 : 0
        border.color: {
            if (primary) return PremiumTheme.primary
            if (accent) return PremiumTheme.accent
            return PremiumTheme.border
        }
        
        // Glossy overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "rgba(255, 255, 255, 0.15)" }
                GradientStop { position: 0.5; color: "rgba(255, 255, 255, 0.05)" }
                GradientStop { position: 1.0; color: "rgba(0, 0, 0, 0.05)" }
            }
            visible: !outlined && root.enabled
        }
        
        // Hover overlay
        Rectangle {
            id: hoverOverlay
            anchors.fill: parent
            radius: parent.radius
            color: outlined ? 
                (primary ? PremiumTheme.primaryLight : 
                 accent ? "rgba(51, 144, 236, 0.1)" :
                 PremiumTheme.isDark ? "rgba(255, 255, 255, 0.05)" : "rgba(0, 0, 0, 0.05)") :
                "rgba(255, 255, 255, 0.1)"
            opacity: 0
            
            Behavior on opacity {
                NumberAnimation {
                    duration: PremiumTheme.durationFast
                    easing.type: PremiumTheme.easingStandard
                }
            }
        }
        
        // Pressed overlay
        Rectangle {
            id: pressOverlay
            anchors.fill: parent
            radius: parent.radius
            color: outlined ? 
                (primary ? PremiumTheme.primaryLight : 
                 accent ? "rgba(51, 144, 236, 0.15)" :
                 PremiumTheme.isDark ? "rgba(255, 255, 255, 0.08)" : "rgba(0, 0, 0, 0.08)") :
                "rgba(0, 0, 0, 0.15)"
            opacity: 0
            
            Behavior on opacity {
                NumberAnimation {
                    duration: PremiumTheme.durationInstant
                    easing.type: PremiumTheme.easingStandard
                }
            }
        }
        
        // Smooth scale animation
        transform: Scale {
            id: scaleTransform
            origin.x: background.width / 2
            origin.y: background.height / 2
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
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM SHADOW - Multi-layer depth
    // ═══════════════════════════════════════════════════════════════
    
    // Bottom shadow layer
    DropShadow {
        anchors.fill: background
        source: background
        horizontalOffset: 0
        verticalOffset: 4
        radius: PremiumTheme.shadowMedium
        samples: 17
        color: PremiumTheme.shadowColor
        visible: root.enabled && !outlined
        opacity: 0.3
        cached: true
        
        Behavior on opacity {
            NumberAnimation {
                duration: PremiumTheme.durationNormal
                easing.type: PremiumTheme.easingStandard
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // CONTENT - Icon + Text
    // ═══════════════════════════════════════════════════════════════
    
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: PremiumTheme.spacingSm
        opacity: root.enabled ? 1.0 : 0.5
        
        // Icon (if provided)
        Text {
            visible: icon !== "" && !loading
            text: icon
            font.family: PremiumTheme.fontFamily
            font.pixelSize: PremiumTheme.iconSizeMedium
            color: {
                if (outlined) {
                    if (primary) return PremiumTheme.primary
                    if (accent) return PremiumTheme.accent
                    return PremiumTheme.textPrimary
                }
                if (primary || accent) return PremiumTheme.textOnPrimary
                return PremiumTheme.textPrimary
            }
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Loading spinner
        Item {
            visible: loading
            width: PremiumTheme.iconSizeMedium
            height: PremiumTheme.iconSizeMedium
            anchors.verticalCenter: parent.verticalCenter
            
            Rectangle {
                id: spinner
                width: parent.width
                height: parent.height
                radius: width / 2
                color: "transparent"
                border.width: 2
                border.color: {
                    if (outlined || (!primary && !accent)) return PremiumTheme.primary
                    return PremiumTheme.textOnPrimary
                }
                
                Rectangle {
                    width: parent.width / 4
                    height: parent.height / 4
                    radius: width / 2
                    color: border.color
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                RotationAnimator {
                    target: spinner
                    from: 0
                    to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: loading
                }
            }
        }
        
        // Text label
        Text {
            visible: text !== ""
            text: root.text
            font.family: PremiumTheme.fontFamily
            font.pixelSize: PremiumTheme.fontSizeMd
            font.weight: PremiumTheme.fontWeightMedium
            color: {
                if (outlined) {
                    if (primary) return PremiumTheme.primary
                    if (accent) return PremiumTheme.accent
                    return PremiumTheme.textPrimary
                }
                if (primary || accent) return PremiumTheme.textOnPrimary
                return PremiumTheme.textPrimary
            }
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: PremiumTheme.durationFast
                easing.type: PremiumTheme.easingStandard
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // INTERACTION - Smooth micro-animations
    // ═══════════════════════════════════════════════════════════════
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled && !loading
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            hoverOverlay.opacity = 1.0
            scaleTransform.xScale = 1.02
            scaleTransform.yScale = 1.02
        }
        
        onExited: {
            hoverOverlay.opacity = 0
            pressOverlay.opacity = 0
            scaleTransform.xScale = 1.0
            scaleTransform.yScale = 1.0
        }
        
        onPressed: {
            pressOverlay.opacity = 1.0
            scaleTransform.xScale = 0.98
            scaleTransform.yScale = 0.98
        }
        
        onReleased: {
            pressOverlay.opacity = 0
            if (containsMouse) {
                scaleTransform.xScale = 1.02
                scaleTransform.yScale = 1.02
            } else {
                scaleTransform.xScale = 1.0
                scaleTransform.yScale = 1.0
            }
        }
        
        onClicked: {
            root.clicked()
            
            // Haptic feedback animation
            rippleAnimation.start()
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // RIPPLE EFFECT - Premium touch feedback
    // ═══════════════════════════════════════════════════════════════
    
    Rectangle {
        id: ripple
        width: 0
        height: 0
        radius: width / 2
        color: "rgba(255, 255, 255, 0.3)"
        opacity: 0
        anchors.centerIn: parent
        
        ParallelAnimation {
            id: rippleAnimation
            
            NumberAnimation {
                target: ripple
                property: "width"
                from: 0
                to: root.width * 2
                duration: PremiumTheme.durationSlow
                easing.type: PremiumTheme.easingDecelerate
            }
            
            NumberAnimation {
                target: ripple
                property: "height"
                from: 0
                to: root.width * 2
                duration: PremiumTheme.durationSlow
                easing.type: PremiumTheme.easingDecelerate
            }
            
            SequentialAnimation {
                NumberAnimation {
                    target: ripple
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: PremiumTheme.durationInstant
                }
                NumberAnimation {
                    target: ripple
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: PremiumTheme.durationNormal
                    easing.type: PremiumTheme.easingDecelerate
                }
            }
        }
    }
}
