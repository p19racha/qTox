// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../themes"

/**
 * Modern Settings Page with card-based layout
 * Inspired by Signal and modern Ubuntu apps
 */
Item {
    id: settingsPage
    
    // Public properties
    property int currentCategory: 0
    
    // Category enum
    readonly property var categories: [
        { name: "General", icon: "⚙️" },
        { name: "Privacy", icon: "🔒" },
        { name: "Notifications", icon: "🔔" },
        { name: "Audio & Video", icon: "🎥" },
        { name: "Appearance", icon: "🎨" },
        { name: "Advanced", icon: "⚡" }
    ]
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // ============================================
        // Header with title and search
        // ============================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.toolbarHeight + Theme.spacing * 2
            color: Theme.surfaceColor
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Theme.spacing * 2
                spacing: Theme.spacing
                
                // Title
                Label {
                    text: "Settings"
                    font.pixelSize: Theme.fontSizeTitle
                    font.weight: Font.Bold
                    color: Theme.textPrimaryColor
                }
                
                // Search bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: Theme.backgroundColor
                    radius: Theme.radiusMedium
                    border.width: 1
                    border.color: searchField.activeFocus ? Theme.accentColor : Theme.borderColor
                    
                    Behavior on border.color {
                        ColorAnimation { duration: Theme.animationFast }
                    }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing
                        spacing: Theme.spacing
                        
                        Label {
                            text: "🔍"
                            font.pixelSize: Theme.fontSizeMedium
                        }
                        
                        TextField {
                            id: searchField
                            Layout.fillWidth: true
                            placeholderText: "Search settings..."
                            background: Item {}
                            color: Theme.textPrimaryColor
                            font.pixelSize: Theme.fontSizeNormal
                            
                            Keys.onEscapePressed: {
                                text = ""
                                focus = false
                            }
                        }
                        
                        Label {
                            text: searchField.text.length > 0 ? "✕" : ""
                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.textSecondaryColor
                            visible: searchField.text.length > 0
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: searchField.text = ""
                            }
                        }
                    }
                }
            }
        }
        
        // ============================================
        // Main content area
        // ============================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.backgroundColor
            
            RowLayout {
                anchors.fill: parent
                spacing: 0
                
                // Category sidebar
                Rectangle {
                    Layout.preferredWidth: 220
                    Layout.fillHeight: true
                    color: Theme.surfaceColor
                    
                    ListView {
                        id: categoryList
                        anchors.fill: parent
                        anchors.margins: Theme.spacing
                        spacing: Theme.spacing / 2
                        clip: true
                        
                        model: categories
                        
                        delegate: Rectangle {
                            width: categoryList.width
                            height: 48
                            radius: Theme.radiusMedium
                            color: {
                                if (index === currentCategory) return Theme.accentColor
                                if (categoryMouseArea.containsMouse) return Theme.hoverColor
                                return "transparent"
                            }
                            
                            Behavior on color {
                                ColorAnimation { duration: Theme.animationFast }
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.spacing
                                anchors.rightMargin: Theme.spacing
                                spacing: Theme.spacing
                                
                                Label {
                                    text: modelData.icon
                                    font.pixelSize: Theme.fontSizeLarge
                                }
                                
                                Label {
                                    Layout.fillWidth: true
                                    text: modelData.name
                                    font.pixelSize: Theme.fontSizeNormal
                                    font.weight: index === currentCategory ? Font.Bold : Font.Normal
                                    color: index === currentCategory ? "#FFFFFF" : Theme.textPrimaryColor
                                }
                            }
                            
                            MouseArea {
                                id: categoryMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentCategory = index
                            }
                        }
                    }
                }
                
                // Settings content area
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.backgroundColor
                    
                    ScrollView {
                        anchors.fill: parent
                        anchors.margins: Theme.spacing * 2
                        clip: true
                        
                        ColumnLayout {
                            width: parent.width
                            spacing: Theme.spacing * 2
                            
                            // Dynamic content based on selected category
                            Loader {
                                Layout.fillWidth: true
                                sourceComponent: {
                                    switch(currentCategory) {
                                        case 0: return generalSettings
                                        case 1: return privacySettings
                                        case 2: return notificationSettings
                                        case 3: return audioVideoSettings
                                        case 4: return appearanceSettings
                                        case 5: return advancedSettings
                                        default: return generalSettings
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // Setting Card Component
    // ============================================
    component SettingCard: Rectangle {
        property string title: ""
        property string description: ""
        default property alias content: contentArea.children
        
        Layout.fillWidth: true
        Layout.preferredHeight: cardLayout.implicitHeight + Theme.spacing * 3
        color: Theme.surfaceColor
        radius: Theme.radiusLarge
        border.width: 1
        border.color: Theme.borderColor
        
        ColumnLayout {
            id: cardLayout
            anchors.fill: parent
            anchors.margins: Theme.spacing * 2
            spacing: Theme.spacing
            
            // Card header
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing / 2
                visible: title.length > 0
                
                Label {
                    text: title
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Theme.textPrimaryColor
                }
                
                Label {
                    Layout.fillWidth: true
                    text: description
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.textSecondaryColor
                    wrapMode: Text.WordWrap
                    visible: description.length > 0
                }
            }
            
            // Card content
            Item {
                id: contentArea
                Layout.fillWidth: true
                Layout.preferredHeight: childrenRect.height
            }
        }
    }
    
    // ============================================
    // Setting Row Component
    // ============================================
    component SettingRow: RowLayout {
        property string label: ""
        property string description: ""
        default property alias control: controlArea.children
        
        Layout.fillWidth: true
        spacing: Theme.spacing * 2
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing / 4
            
            Label {
                text: label
                font.pixelSize: Theme.fontSizeNormal
                color: Theme.textPrimaryColor
            }
            
            Label {
                Layout.fillWidth: true
                text: description
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.textSecondaryColor
                wrapMode: Text.WordWrap
                visible: description.length > 0
            }
        }
        
        Item {
            id: controlArea
            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: childrenRect.height
        }
    }
    
    // ============================================
    // General Settings
    // ============================================
    Component {
        id: generalSettings
        
        ColumnLayout {
            spacing: Theme.spacing * 2
            
            SettingCard {
                title: "Language & Region"
                description: "Customize language and locale settings"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Display Language"
                        description: "Choose the language for the interface"
                        
                        ComboBox {
                            implicitWidth: 200
                            model: ["English", "Spanish", "French", "German", "Chinese", "Japanese"]
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Date Format"
                        
                        ComboBox {
                            implicitWidth: 200
                            model: ["MM/DD/YYYY", "DD/MM/YYYY", "YYYY-MM-DD"]
                        }
                    }
                }
            }
            
            SettingCard {
                title: "Chat Behavior"
                description: "Configure how messages are handled"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Send message with"
                        description: "Choose how to send messages"
                        
                        ComboBox {
                            implicitWidth: 200
                            model: ["Enter", "Ctrl+Enter", "Shift+Enter"]
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Enable spell check"
                        
                        Switch {
                            checked: true
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Show typing indicators"
                        description: "Let contacts know when you're typing"
                        
                        Switch {
                            checked: true
                        }
                    }
                }
            }
            
            SettingCard {
                title: "File Sharing"
                description: "Manage file transfer settings"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Auto-accept files from contacts"
                        
                        Switch {
                            checked: false
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Download folder"
                        
                        RowLayout {
                            spacing: Theme.spacing
                            
                            Label {
                                text: "~/Downloads"
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.textSecondaryColor
                            }
                            
                            ModernButton {
                                text: "Change"
                                outlined: true
                                buttonColor: Theme.accentColor
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // Privacy Settings
    // ============================================
    Component {
        id: privacySettings
        
        ColumnLayout {
            spacing: Theme.spacing * 2
            
            SettingCard {
                title: "Privacy Controls"
                description: "Manage your privacy and security"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Send read receipts"
                        description: "Let contacts know when you've read their messages"
                        
                        Switch {
                            checked: true
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Allow unknown contacts"
                        description: "Accept messages from people not in your contact list"
                        
                        Switch {
                            checked: false
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Screenshot protection"
                        description: "Prevent screenshots of conversations (experimental)"
                        
                        Switch {
                            checked: false
                        }
                    }
                }
            }
            
            SettingCard {
                title: "Chat History"
                description: "Configure message storage and retention"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Keep chat history"
                        
                        Switch {
                            checked: true
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Encrypt chat history"
                        description: "Store messages with encryption"
                        
                        Switch {
                            checked: true
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // Notification Settings
    // ============================================
    Component {
        id: notificationSettings
        
        ColumnLayout {
            spacing: Theme.spacing * 2
            
            SettingCard {
                title: "Desktop Notifications"
                description: "Control when and how you receive notifications"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Enable notifications"
                        
                        Switch {
                            checked: true
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Show message preview"
                        description: "Display message content in notifications"
                        
                        Switch {
                            checked: true
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Play notification sound"
                        
                        Switch {
                            checked: true
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // Audio & Video Settings
    // ============================================
    Component {
        id: audioVideoSettings
        
        ColumnLayout {
            spacing: Theme.spacing * 2
            
            SettingCard {
                title: "Audio Devices"
                description: "Configure microphone and speakers"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Microphone"
                        
                        ComboBox {
                            implicitWidth: 250
                            model: ["Default", "Built-in Microphone", "USB Microphone"]
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Speakers"
                        
                        ComboBox {
                            implicitWidth: 250
                            model: ["Default", "Built-in Speakers", "HDMI Audio"]
                        }
                    }
                }
            }
            
            SettingCard {
                title: "Video Settings"
                description: "Configure camera and video quality"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Camera"
                        
                        ComboBox {
                            implicitWidth: 250
                            model: ["Default", "Integrated Camera", "USB Webcam"]
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Video resolution"
                        
                        ComboBox {
                            implicitWidth: 250
                            model: ["720p", "1080p", "4K"]
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // Appearance Settings
    // ============================================
    Component {
        id: appearanceSettings
        
        ColumnLayout {
            spacing: Theme.spacing * 2
            
            SettingCard {
                title: "Theme"
                description: "Customize the look and feel"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Color scheme"
                        
                        ComboBox {
                            implicitWidth: 200
                            model: ["System", "Light", "Dark"]
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Accent color"
                        
                        RowLayout {
                            spacing: Theme.spacing
                            
                            Repeater {
                                model: ["#007AFF", "#34C759", "#FF9500", "#FF3B30", "#AF52DE"]
                                
                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: width / 2
                                    color: modelData
                                    border.width: 2
                                    border.color: index === 0 ? Theme.textPrimaryColor : "transparent"
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            SettingCard {
                title: "Text & Display"
                description: "Adjust text size and display options"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Text size"
                        
                        Slider {
                            implicitWidth: 200
                            from: 0.8
                            to: 1.5
                            value: 1.0
                            stepSize: 0.1
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Compact mode"
                        description: "Use less spacing for more content"
                        
                        Switch {
                            checked: false
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // Advanced Settings
    // ============================================
    Component {
        id: advancedSettings
        
        ColumnLayout {
            spacing: Theme.spacing * 2
            
            SettingCard {
                title: "Network & Connection"
                description: "Advanced network configuration"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Use proxy"
                        
                        Switch {
                            checked: false
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "UDP enabled"
                        description: "Use UDP for better connection quality"
                        
                        Switch {
                            checked: true
                        }
                    }
                }
            }
            
            SettingCard {
                title: "Developer Options"
                description: "Advanced settings for developers"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing * 1.5
                    
                    SettingRow {
                        label: "Enable debug log"
                        
                        Switch {
                            checked: false
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Theme.borderColor
                    }
                    
                    SettingRow {
                        label: "Show connection info"
                        
                        Switch {
                            checked: false
                        }
                    }
                }
            }
            
            // Danger zone
            SettingCard {
                title: "⚠️ Danger Zone"
                description: "Irreversible actions - use with caution"
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    
                    ModernButton {
                        text: "Clear All Chat History"
                        buttonColor: "#FF3B30"
                        hoverColor: "#FF2020"
                        pressedColor: "#E02020"
                    }
                    
                    ModernButton {
                        text: "Reset All Settings"
                        buttonColor: "#FF9500"
                        hoverColor: "#FF8500"
                        pressedColor: "#E07500"
                    }
                }
            }
        }
    }
}
