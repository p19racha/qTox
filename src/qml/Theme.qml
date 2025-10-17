// qTox Premium UI - Centralized Dark Theme
// Single source of truth for all colors, spacing, and styling
pragma Singleton
import QtQuick

QtObject {
    // === PRIMARY COLORS ===
    readonly property color background: "#0E1621"      // Main dark background
    readonly property color surface: "#1A2332"         // Cards, panels, sidebars
    readonly property color surfaceLight: "#232E3E"    // Hover states, elevated surfaces
    readonly property color surfaceHover: "#2A3A4E"    // Active hover
    
    // === ACCENT COLORS ===
    readonly property color primary: "#2AABEE"         // Telegram blue - primary actions
    readonly property color primaryHover: "#1E8BC3"    // Primary hover state
    readonly property color primaryLight: "#3BC1FF"    // Lighter primary variant
    
    // === TEXT COLORS ===
    readonly property color textPrimary: "#FFFFFF"     // Main text
    readonly property color textSecondary: "#8B98A5"   // Secondary text, labels
    readonly property color textTertiary: "#6B7885"    // Disabled, hints
    readonly property color textOnPrimary: "#FFFFFF"   // Text on primary color
    
    // === STATUS COLORS ===
    readonly property color online: "#4CAF50"          // Green - online status
    readonly property color away: "#FFA726"            // Orange - away status
    readonly property color busy: "#EF5350"            // Red - busy/DND status
    readonly property color offline: "#757575"         // Gray - offline
    
    // === SEMANTIC COLORS ===
    readonly property color success: "#4CAF50"         // Success messages
    readonly property color warning: "#FFA726"         // Warnings
    readonly property color error: "#EF5350"           // Errors, destructive actions
    readonly property color info: "#2AABEE"            // Info messages
    
    // === BORDERS & DIVIDERS ===
    readonly property color border: "#2A3A4E"          // Default borders
    readonly property color borderLight: "#3A4A5E"     // Lighter borders
    readonly property color divider: "#1E2A38"         // Subtle dividers
    
    // === CHAT COLORS ===
    readonly property color messageSent: "#2AABEE"     // Sent message bubble
    readonly property color messageReceived: "#1A2332" // Received message bubble
    readonly property color messageTimestamp: "#6B7885"
    
    // === SPACING & SIZING ===
    readonly property int spacingXS: 4
    readonly property int spacingS: 8
    readonly property int spacingM: 12
    readonly property int spacingL: 16
    readonly property int spacingXL: 20
    readonly property int spacingXXL: 24
    readonly property int spacingXXXL: 32
    
    // === BORDER RADIUS ===
    readonly property int radiusS: 8
    readonly property int radiusM: 12
    readonly property int radiusL: 16
    readonly property int radiusXL: 20
    readonly property int radiusRound: 999
    
    // === FONT SIZES ===
    readonly property int fontXS: 11
    readonly property int fontS: 13
    readonly property int fontM: 14
    readonly property int fontL: 15
    readonly property int fontXL: 18
    readonly property int fontXXL: 20
    readonly property int fontXXXL: 24
    readonly property int fontTitle: 28
    
    // === ICON SIZES ===
    readonly property int iconXS: 16
    readonly property int iconS: 20
    readonly property int iconM: 24
    readonly property int iconL: 32
    readonly property int iconXL: 48
    
    // === SHADOWS ===
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.2)
    readonly property int shadowRadius: 16
    readonly property int shadowOffsetY: 4
    
    // === TRANSITIONS ===
    readonly property int animationFast: 150
    readonly property int animationNormal: 250
    readonly property int animationSlow: 350
}
