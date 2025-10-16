// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium UI Theme System

pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme
    
    // ═══════════════════════════════════════════════════════════════
    // DESIGN PHILOSOPHY: Telegram Premium Dark Theme
    // - Dark mode only for consistency and eye comfort
    // - Clean, minimal design
    // - Smooth animations
    // - Perfect rounded corners (12px+)
    // - 60 FPS animations
    // - Telegram blue as primary color
    // ═══════════════════════════════════════════════════════════════
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM COLORS - Telegram Dark Theme
    // ═══════════════════════════════════════════════════════════════
    
    // Brand Colors (Telegram blue primary)
    readonly property color primary: "#5288c1"
    readonly property color primaryHover: "#6ba1db"
    readonly property color primaryPressed: "#4376a8"
    readonly property color primaryLight: "#2a4a6b"
    
    // Accent Colors (Telegram blue inspiration)
    readonly property color accent: "#3390ec"
    readonly property color accentHover: "#4ea4f6"
    readonly property color accentPressed: "#2b7ed1"
    
    // Background - Clean Telegram dark style
    readonly property color backgroundPrimary: "#0e1621"
    readonly property color backgroundSecondary: "#17212b"
    readonly property color backgroundTertiary: "#1d2733"
    readonly property color backgroundChat: "#0e1621"
    
    // Surface colors
    readonly property color surfaceElevated: "#17212b"
    readonly property color surfaceGlass: Qt.rgba(23/255, 33/255, 43/255, 0.8)
    readonly property color surfaceOverlay: Qt.rgba(0, 0, 0, 0.7)
    
    // Message bubbles - Telegram design
    readonly property color messageSent: "#2b5278"
    readonly property color messageSentHover: "#376190"
    readonly property color messageReceived: "#182533"
    readonly property color messageReceivedHover: "#1f2e3f"
    
    // Text colors - High contrast
    readonly property color textPrimary: "#e9edef"
    readonly property color textSecondary: "#8696a0"
    readonly property color textTertiary: "#667781"
    readonly property color textInverse: "#000000"
    readonly property color textOnPrimary: "#ffffff"
    readonly property color textOnAccent: "#ffffff"
    readonly property color textOnSent: "#ffffff"
    
    // Status colors
    readonly property color online: "#00d856"
    readonly property color away: "#ffa033"
    readonly property color busy: "#ff4444"
    readonly property color offline: "#8696a0"
    
    // Notification colors
    readonly property color unreadBadge: "#5288c1"
    readonly property color mention: "#ff4444"
    readonly property color typing: "#5288c1"
    
    // Border colors
    readonly property color border: Qt.rgba(134/255, 150/255, 160/255, 0.15)
    readonly property color borderStrong: Qt.rgba(134/255, 150/255, 160/255, 0.3)
    readonly property color divider: "#2a3942"
    
    // Hover and interaction colors
    readonly property color hoverOverlay: Qt.rgba(1, 1, 1, 0.08)
    readonly property color pressedOverlay: Qt.rgba(1, 1, 1, 0.12)
    readonly property color selectedOverlay: Qt.rgba(82/255, 136/255, 193/255, 0.2)
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM SHADOWS - Multi-layer depth
    // ═══════════════════════════════════════════════════════════════
    
    readonly property int shadowSmall: 4
    readonly property int shadowMedium: 8
    readonly property int shadowLarge: 16
    readonly property int shadowXLarge: 24
    
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.6)
    readonly property color shadowColorStrong: Qt.rgba(0, 0, 0, 0.8)
    readonly property color messageShadow: Qt.rgba(0, 0, 0, 0.4)
    
    // ═══════════════════════════════════════════════════════════════
    // PERFECT BORDER RADIUS - Telegram style
    // ═══════════════════════════════════════════════════════════════
    
    readonly property int radiusSmall: 6
    readonly property int radiusMedium: 10
    readonly property int radiusLarge: 12
    readonly property int radiusXLarge: 16
    readonly property int radiusFull: 999
    
    // Message bubble specific
    readonly property int radiusMessageSent: 12
    readonly property int radiusMessageReceived: 12
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM SPACING - 4px grid system
    // ═══════════════════════════════════════════════════════════════
    
    readonly property int spacing2xs: 4
    readonly property int spacingXs: 8
    readonly property int spacingSm: 12
    readonly property int spacingMd: 16
    readonly property int spacingLg: 20
    readonly property int spacingXl: 24
    readonly property int spacing2xl: 32
    readonly property int spacing3xl: 48
    
    // ═══════════════════════════════════════════════════════════════
    // SMOOTH ANIMATIONS - 60 FPS guaranteed
    // ═══════════════════════════════════════════════════════════════
    
    // Duration (in milliseconds)
    readonly property int durationInstant: 100
    readonly property int durationFast: 150
    readonly property int durationNormal: 250
    readonly property int durationSlow: 350
    readonly property int durationSlower: 500
    
    // Easing curves - Premium feel
    readonly property int easingStandard: Easing.OutCubic
    readonly property int easingDecelerate: Easing.OutQuart
    readonly property int easingAccelerate: Easing.InQuart
    readonly property int easingSpring: Easing.OutBack
    readonly property int easingBounce: Easing.OutElastic
    
    // ═══════════════════════════════════════════════════════════════
    // TYPOGRAPHY - System fonts with fallbacks
    // ═══════════════════════════════════════════════════════════════
    
    readonly property string fontFamily: "SF Pro Display, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, Arial, sans-serif"
    readonly property string fontFamilyMono: "SF Mono, Consolas, Monaco, Courier New, monospace"
    
    // Font sizes
    readonly property int fontSizeXs: 11
    readonly property int fontSizeSm: 13
    readonly property int fontSizeMd: 15
    readonly property int fontSizeLg: 17
    readonly property int fontSizeXl: 20
    readonly property int fontSize2xl: 24
    readonly property int fontSize3xl: 32
    
    // Font weights
    readonly property int fontWeightLight: 300
    readonly property int fontWeightRegular: 400
    readonly property int fontWeightMedium: 500
    readonly property int fontWeightSemibold: 600
    readonly property int fontWeightBold: 700
    
    // Line heights
    readonly property real lineHeightTight: 1.2
    readonly property real lineHeightNormal: 1.5
    readonly property real lineHeightRelaxed: 1.7
    
    // ═══════════════════════════════════════════════════════════════
    // COMPONENT DIMENSIONS
    // ═══════════════════════════════════════════════════════════════
    
    // Buttons
    readonly property int buttonHeightSmall: 32
    readonly property int buttonHeightMedium: 40
    readonly property int buttonHeightLarge: 48
    
    // Input fields
    readonly property int inputHeight: 44
    readonly property int inputHeightSmall: 36
    
    // Avatar sizes
    readonly property int avatarSizeSmall: 32
    readonly property int avatarSizeMedium: 40
    readonly property int avatarSizeLarge: 56
    readonly property int avatarSizeXLarge: 72
    
    // Icon sizes
    readonly property int iconSizeSmall: 16
    readonly property int iconSizeMedium: 20
    readonly property int iconSizeLarge: 24
    readonly property int iconSizeXLarge: 32
    
    // Badge size
    readonly property int badgeSize: 20
    readonly property int badgeSizeSmall: 16
    
    // ═══════════════════════════════════════════════════════════════
    // GLASSMORPHISM EFFECTS
    // ═══════════════════════════════════════════════════════════════
    
    readonly property real glassBlur: 20.0
    readonly property real glassOpacity: 0.8
    readonly property color glassTint: "#1f2c33"
    
    // ═══════════════════════════════════════════════════════════════
    // GRADIENT DEFINITIONS
    // ═══════════════════════════════════════════════════════════════
    
    function primaryGradient() {
        return {
            start: Qt.point(0, 0),
            end: Qt.point(1, 1),
            stops: [
                { position: 0.0, color: "#00a884" },
                { position: 1.0, color: "#00c69a" }
            ]
        }
    }
    
    function accentGradient() {
        return {
            start: Qt.point(0, 0),
            end: Qt.point(1, 1),
            stops: [
                { position: 0.0, color: "#3390ec" },
                { position: 1.0, color: "#4ea4f6" }
            ]
        }
    }
    
    function chatBackgroundGradient() {
        return {
            start: Qt.point(0, 0),
            end: Qt.point(0, 1),
            stops: [
                { position: 0.0, color: "#0b141a" },
                { position: 1.0, color: "#111b21" }
            ]
        }
    }
}
