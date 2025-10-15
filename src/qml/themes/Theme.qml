// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

pragma Singleton
import QtQuick 2.15

QtObject {
    id: theme
    
    // ============================================
    // Theme State
    // ============================================
    property bool isDark: false  // Will be synced with Ubuntu system theme
    
    // ============================================
    // Colors - Dynamic based on theme
    // ============================================
    
    // Background colors
    property color backgroundColor: isDark ? "#1e1e1e" : "#ffffff"
    property color surfaceColor: isDark ? "#2d2d2d" : "#f5f5f5"
    property color cardColor: isDark ? "#363636" : "#ffffff"
    
    // Primary brand colors
    property color primaryColor: "#5DADE2"  // qTox signature blue
    property color primaryDark: "#3498DB"
    property color primaryLight: "#85C1E9"
    
    // Status colors
    property color onlineColor: "#27AE60"    // Green
    property color awayColor: "#F39C12"      // Orange
    property color busyColor: "#E74C3C"      // Red
    property color offlineColor: isDark ? "#7F8C8D" : "#95A5A6"
    
    // Text colors
    property color textColor: isDark ? "#e0e0e0" : "#2c3e50"
    property color secondaryTextColor: isDark ? "#b0b0b0" : "#7f8c8d"
    property color tertiaryTextColor: isDark ? "#808080" : "#95a5a6"
    property color invertedTextColor: isDark ? "#2c3e50" : "#ffffff"
    
    // UI element colors
    property color borderColor: isDark ? "#404040" : "#e0e0e0"
    property color hoverColor: isDark ? "#3d3d3d" : "#ecf0f1"
    property color pressedColor: isDark ? "#4d4d4d" : "#dce1e3"
    property color selectedColor: isDark ? "#2980B9" : "#AED6F1"
    
    // Message bubble colors
    property color sentMessageColor: "#5DADE2"
    property color receivedMessageColor: isDark ? "#3d3d3d" : "#ecf0f1"
    
    // Alert colors
    property color errorColor: "#E74C3C"
    property color warningColor: "#F39C12"
    property color successColor: "#27AE60"
    property color infoColor: "#3498DB"
    
    // ============================================
    // Dimensions
    // ============================================
    
    // Border radius
    property int borderRadius: 12
    property int smallRadius: 6
    property int largeRadius: 16
    property int circleRadius: 999  // For circular elements
    
    // Spacing
    property int tinySpacing: 4
    property int smallSpacing: 8
    property int spacing: 16
    property int largeSpacing: 24
    property int hugeSpacing: 32
    
    // Padding
    property int tinyPadding: 4
    property int smallPadding: 8
    property int padding: 16
    property int largePadding: 24
    
    // Sizes
    property int iconSizeTiny: 16
    property int iconSizeSmall: 20
    property int iconSize: 24
    property int iconSizeLarge: 32
    property int iconSizeHuge: 48
    
    property int avatarSizeSmall: 32
    property int avatarSize: 40
    property int avatarSizeLarge: 56
    property int avatarSizeHuge: 80
    
    // ============================================
    // Typography
    // ============================================
    
    property string fontFamily: "Ubuntu"  // Native Ubuntu font
    
    // Font sizes
    property int fontSizeTiny: 10
    property int fontSizeSmall: 12
    property int fontSizeBody: 14
    property int fontSizeTitle: 16
    property int fontSizeHeader: 18
    property int fontSizeLarge: 20
    property int fontSizeHuge: 24
    property int fontSizeDisplay: 32
    
    // Font weights
    property int fontWeightLight: Font.Light
    property int fontWeightNormal: Font.Normal
    property int fontWeightMedium: Font.Medium
    property int fontWeightBold: Font.Bold
    
    // ============================================
    // Animations
    // ============================================
    
    property int animationFast: 100
    property int animationNormal: 200
    property int animationSlow: 300
    property int animationVerySlow: 500
    
    property int easingType: Easing.OutCubic
    property int easingTypeElastic: Easing.OutBack
    
    // ============================================
    // Shadows & Effects
    // ============================================
    
    property int shadowRadius: 8
    property int shadowOffset: 2
    property color shadowColor: isDark ? "#000000" : "#40000000"
    
    property real hoverOpacity: 0.08
    property real pressedOpacity: 0.12
    property real disabledOpacity: 0.38
    
    // ============================================
    // Layout
    // ============================================
    
    property int sidebarWidth: 300
    property int sidebarMinWidth: 250
    property int sidebarMaxWidth: 400
    
    property int toolbarHeight: 60
    property int inputAreaHeight: 56
    
    // ============================================
    // Z-Index Layers
    // ============================================
    
    property int zIndexBase: 0
    property int zIndexElevated: 1
    property int zIndexOverlay: 10
    property int zIndexModal: 100
    property int zIndexTooltip: 1000
    
    // ============================================
    // Theme Switching Function
    // ============================================
    
    function toggleTheme() {
        isDark = !isDark
    }
    
    function setDarkTheme(dark) {
        isDark = dark
    }
}
