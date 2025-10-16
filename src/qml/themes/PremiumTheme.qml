// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium UI Theme System

pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme
    
    // ═══════════════════════════════════════════════════════════════
    // DESIGN PHILOSOPHY: WhatsApp/Telegram Premium Aesthetic
    // - Glassmorphism effects
    // - Smooth gradients and shadows
    // - Perfect rounded corners (16px+)
    // - 60 FPS animations
    // - Micro-interactions
    // ═══════════════════════════════════════════════════════════════
    
    property bool isDark: false
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM COLORS - WhatsApp/Telegram Inspired
    // ═══════════════════════════════════════════════════════════════
    
    // Brand Colors (WhatsApp green inspiration)
    readonly property color primary: isDark ? "#00a884" : "#25d366"
    readonly property color primaryHover: isDark ? "#00c69a" : "#1fbd5a"
    readonly property color primaryPressed: isDark ? "#008f6f" : "#1ea952"
    readonly property color primaryLight: isDark ? "#1a3e33" : "#dfffef"
    
    // Accent Colors (Telegram blue inspiration)
    readonly property color accent: isDark ? "#3390ec" : "#2481cc"
    readonly property color accentHover: isDark ? "#4ea4f6" : "#1f7bc0"
    readonly property color accentPressed: isDark ? "#2b7ed1" : "#1a6aa8"
    
    // Background - Glossy gradients
    readonly property color backgroundPrimary: isDark ? "#0b141a" : "#ffffff"
    readonly property color backgroundSecondary: isDark ? "#111b21" : "#f0f2f5"
    readonly property color backgroundTertiary: isDark ? "#1f2c33" : "#ffffff"
    readonly property color backgroundChat: isDark ? "#0b141a" : "#efeae2"
    
    // Surface colors with glassmorphism
    readonly property color surfaceElevated: isDark ? "rgba(31, 44, 51, 0.95)" : "rgba(255, 255, 255, 0.95)"
    readonly property color surfaceGlass: isDark ? "rgba(31, 44, 51, 0.8)" : "rgba(255, 255, 255, 0.8)"
    readonly property color surfaceOverlay: isDark ? "rgba(0, 0, 0, 0.7)" : "rgba(0, 0, 0, 0.4)"
    
    // Message bubbles - Premium design
    readonly property color messageSent: isDark ? "#005c4b" : "#d9fdd3"
    readonly property color messageSentHover: isDark ? "#006854" : "#c8f7c5"
    readonly property color messageReceived: isDark ? "#1f2c33" : "#ffffff"
    readonly property color messageReceivedHover: isDark ? "#2a3942" : "#f5f5f5"
    
    // Text colors - High contrast
    readonly property color textPrimary: isDark ? "#e9edef" : "#111b21"
    readonly property color textSecondary: isDark ? "#8696a0" : "#667781"
    readonly property color textTertiary: isDark ? "#667781" : "#8696a0"
    readonly property color textInverse: isDark ? "#111b21" : "#ffffff"
    readonly property color textOnPrimary: "#ffffff"
    readonly property color textOnAccent: "#ffffff"
    
    // Status colors
    readonly property color online: "#00d856"
    readonly property color away: "#ffa033"
    readonly property color busy: "#ff4444"
    readonly property color offline: "#8696a0"
    
    // Notification colors
    readonly property color unreadBadge: isDark ? "#00a884" : "#25d366"
    readonly property color mention: "#ff4444"
    readonly property color typing: primary
    
    // Border colors
    readonly property color border: isDark ? "rgba(134, 150, 160, 0.15)" : "rgba(0, 0, 0, 0.08)"
    readonly property color borderStrong: isDark ? "rgba(134, 150, 160, 0.3)" : "rgba(0, 0, 0, 0.15)"
    readonly property color divider: isDark ? "#2a3942" : "#e9edef"
    
    // ═══════════════════════════════════════════════════════════════
    // PREMIUM SHADOWS - Multi-layer depth
    // ═══════════════════════════════════════════════════════════════
    
    readonly property int shadowSmall: 4
    readonly property int shadowMedium: 8
    readonly property int shadowLarge: 16
    readonly property int shadowXLarge: 24
    
    readonly property color shadowColor: isDark ? "rgba(0, 0, 0, 0.6)" : "rgba(0, 0, 0, 0.12)"
    readonly property color shadowColorStrong: isDark ? "rgba(0, 0, 0, 0.8)" : "rgba(0, 0, 0, 0.2)"
    
    // ═══════════════════════════════════════════════════════════════
    // PERFECT BORDER RADIUS - WhatsApp/Telegram style
    // ═══════════════════════════════════════════════════════════════
    
    readonly property int radiusSmall: 8
    readonly property int radiusMedium: 12
    readonly property int radiusLarge: 16
    readonly property int radiusXLarge: 20
    readonly property int radiusFull: 999
    
    // Message bubble specific
    readonly property int radiusMessageSent: 8
    readonly property int radiusMessageReceived: 8
    
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
    readonly property real glassOpacity: isDark ? 0.8 : 0.95
    readonly property color glassTint: isDark ? "#1f2c33" : "#ffffff"
    
    // ═══════════════════════════════════════════════════════════════
    // GRADIENT DEFINITIONS
    // ═══════════════════════════════════════════════════════════════
    
    function primaryGradient() {
        return {
            start: Qt.point(0, 0),
            end: Qt.point(1, 1),
            stops: [
                { position: 0.0, color: isDark ? "#00a884" : "#25d366" },
                { position: 1.0, color: isDark ? "#00c69a" : "#1fbd5a" }
            ]
        }
    }
    
    function accentGradient() {
        return {
            start: Qt.point(0, 0),
            end: Qt.point(1, 1),
            stops: [
                { position: 0.0, color: isDark ? "#3390ec" : "#2481cc" },
                { position: 1.0, color: isDark ? "#4ea4f6" : "#1f7bc0" }
            ]
        }
    }
    
    function chatBackgroundGradient() {
        return {
            start: Qt.point(0, 0),
            end: Qt.point(0, 1),
            stops: isDark ? [
                { position: 0.0, color: "#0b141a" },
                { position: 1.0, color: "#111b21" }
            ] : [
                { position: 0.0, color: "#efeae2" },
                { position: 1.0, color: "#e5ddd5" }
            ]
        }
    }
    
    // ═══════════════════════════════════════════════════════════════
    // THEME SWITCHING
    // ═══════════════════════════════════════════════════════════════
    
    function toggleTheme() {
        isDark = !isDark
    }
    
    function setDarkTheme(dark) {
        isDark = dark
    }
}
