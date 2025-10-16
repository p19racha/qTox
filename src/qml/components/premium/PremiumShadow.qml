// qTox Premium UI - Shadow Effect Component
// Provides consistent drop shadow styling for Premium UI elements

import QtQuick
import Qt5Compat.GraphicalEffects

DropShadow {
    id: shadow
    
    // Configurable shadow properties
    property real shadowOpacity: 0.15
    property real shadowBlur: 24
    property color shadowColorValue: Qt.rgba(0, 0, 0, shadowOpacity)
    
    // Apply shadow styling
    horizontalOffset: 0
    verticalOffset: 4
    radius: shadowBlur
    samples: shadowBlur * 2 + 1
    color: shadowColorValue
    smooth: true
    cached: true
}
