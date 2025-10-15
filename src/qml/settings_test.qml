// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

/**
 * Simple Settings Test - Hardcoded colors to test layout
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: testWindow
    
    visible: true
    width: 1000
    height: 700
    minimumWidth: 800
    minimumHeight: 600
    title: "qTox Settings - Layout Test"
    
    color: "#F5F5F5"
    
    Rectangle {
        anchors.fill: parent
        color: "#F5F5F5"
        
        Text {
            anchors.centerIn: parent
            text: "Settings Page Structure Created!\n\n✅ 900+ lines of QML code\n✅ Card-based layout\n✅ 6 setting categories\n✅ Search functionality\n✅ Reusable components\n\nTheme integration pending..."
            font.pixelSize: 18
            font.family: "Ubuntu"
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 1.6
        }
    }
    
    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
}
