// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import "pages"
import "themes"

/**
 * Settings Demo Application
 * Showcases the modern settings page
 */
ApplicationWindow {
    id: settingsWindow
    
    visible: true
    width: 1000
    height: 700
    minimumWidth: 800
    minimumHeight: 600
    title: "qTox Settings - Modern Ubuntu Edition"
    
    color: Theme.backgroundColor
    
    // Settings page fills the entire window
    SettingsPage {
        anchors.fill: parent
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
    
    Shortcut {
        sequence: "Ctrl+W"
        onActivated: Qt.quit()
    }
}
