// qTox Premium UI - Main Application Window
// Complete chat application with navigation, friend list, and all screens

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"
import "themes"
import "components/premium"

ApplicationWindow {
    id: mainWindow
    visible: false  // Start hidden, will be shown by C++ code
    width: 1400
    height: 900
    minimumWidth: 1200
    minimumHeight: 700
    title: "qTox - Secure Messaging"
    
    // Inline theme (fallback if singleton doesn't load)
    readonly property var premiumTheme: QtObject {
        // Telegram Dark Theme Colors
        readonly property color background: "#0E1621"
        readonly property color backgroundPrimary: "#0E1621"
        readonly property color surface: "#1A2332"
        readonly property color surfaceLight: "#232E3E"
        readonly property color surfaceDark: "#151D28"
        
        readonly property color primary: "#2AABEE"
        readonly property color primaryDark: "#2090D0"
        readonly property color secondary: "#7F8C9C"
        
        readonly property color textPrimary: "#FFFFFF"
        readonly property color textSecondary: "#8E9DB5"
        readonly property color textTertiary: "#6B7888"
        readonly property color textPlaceholder: "#4A5766"
        
        readonly property color border: "#2C3645"
        readonly property color borderLight: "#3A4556"
        
        readonly property color hoverOverlay: "#232E3E"
        readonly property color selectedOverlay: "#1E2836"
        readonly property color activeOverlay: "#2A3849"
        
        readonly property color success: "#4CAF50"
        readonly property color error: "#F44336"
        readonly property color warning: "#FF9800"
        readonly property color info: "#2196F3"
        
        // Spacing
        readonly property int spacingXs: 4
        readonly property int spacingSm: 8
        readonly property int spacingMd: 12
        readonly property int spacingLg: 16
        readonly property int spacingXl: 24
        
        // Borders
        readonly property int borderRadiusSm: 8
        readonly property int borderRadiusMd: 12
        readonly property int borderRadiusLg: 16
        readonly property int borderRadiusXl: 20
        readonly property int borderRadiusFull: 9999
        
        // Animation
        readonly property int durationFast: 150
        readonly property int durationNormal: 250
        readonly property int durationSlow: 350
    }
    
    color: premiumTheme.background

    // Properties for navigation
    property string currentView: "chat" // chat, addFriend, profile, settings, about
    property string selectedFriendPk: ""
    property bool sidebarCollapsed: false

    // Main layout: Sidebar + Content
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Sidebar - Friend List & Navigation
        Rectangle {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: sidebarCollapsed ? 80 : 360
            color: premiumTheme.surface
            
            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // User Profile Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    color: premiumTheme.surfaceDark
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        // Profile Picture
                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 56
                            radius: 28
                            color: premiumTheme.primary
                            
                            Text {
                                anchors.centerIn: parent
                                text: qmlBridge.username ? qmlBridge.username.charAt(0).toUpperCase() : "?"
                                font.pixelSize: 24
                                font.weight: Font.Medium
                                color: premiumTheme.textPrimary
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: currentView = "profile"
                            }
                        }

                        // User Info
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            visible: !sidebarCollapsed

                            Text {
                                text: qmlBridge.username || "Loading..."
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                color: premiumTheme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: qmlBridge.statusMessage || "No status message"
                                font.pixelSize: 13
                                color: premiumTheme.textSecondary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        // Status Indicator
                        Rectangle {
                            Layout.preferredWidth: 12
                            Layout.preferredHeight: 12
                            radius: 6
                            color: qmlBridge.isConnected ? premiumTheme.success : premiumTheme.error
                            border.width: 2
                            border.color: premiumTheme.surfaceDark
                        }
                    }
                }

                // Search Bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    Layout.margins: 12
                    color: "transparent"
                    visible: !sidebarCollapsed

                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: premiumTheme.surfaceLight
                        border.width: 1
                        border.color: searchField.activeFocus ? premiumTheme.primary : "transparent"
                        
                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 10

                            Icon {
                                name: "search"
                                size: 18
                                color: premiumTheme.textSecondary
                            }

                            TextField {
                                id: searchField
                                Layout.fillWidth: true
                                placeholderText: "Search contacts..."
                                color: premiumTheme.textPrimary
                                placeholderTextColor: premiumTheme.textSecondary
                                font.pixelSize: 14
                                background: Item {}
                            }
                        }
                    }
                }

                // Navigation Tabs
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: "transparent"
                    visible: !sidebarCollapsed

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        Repeater {
                            model: [
                                {text: "Chats", value: "chat", iconName: "chat"},
                                {text: "Requests", value: "requests", iconName: "requests"},
                                {text: "Groups", value: "groups", iconName: "groups"}
                            ]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                radius: 8
                                color: currentView === modelData.value ? Qt.rgba(82/255, 136/255, 193/255, 0.15) : "transparent"
                                
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 8

                                    Icon {
                                        name: modelData.iconName
                                        size: 18
                                        color: currentView === modelData.value ? premiumTheme.primary : premiumTheme.textSecondary
                                    }

                                    Text {
                                        text: modelData.text
                                        font.pixelSize: 13
                                        font.weight: currentView === modelData.value ? Font.Medium : Font.Normal
                                        color: currentView === modelData.value ? premiumTheme.primary : premiumTheme.textSecondary
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: currentView = modelData.value
                                }
                            }
                        }
                    }
                }

                // Friend List
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    ListView {
                        id: friendListView
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4
                        clip: true
                        model: qmlBridge ? qmlBridge.friendListModel : null

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 6
                            
                            contentItem: Rectangle {
                                radius: 3
                                color: premiumTheme.textSecondary
                                opacity: parent.pressed ? 0.8 : 0.5
                            }
                        }

                        delegate: PremiumContactCard {
                            width: friendListView.width
                            name: model.friendName || ""
                            lastMessage: model.lastMessage || "No messages yet"
                            timestamp: model.lastMessageTime || ""
                            unreadCount: model.unreadCount || 0
                            online: model.isOnline || false
                            selected: selectedFriendPk === (model.publicKey || "")
                            avatarText: model.friendName ? model.friendName.substring(0, 2).toUpperCase() : "??"

                            onClicked: {
                                selectedFriendPk = model.publicKey || ""
                                currentView = "chat"
                            }
                        }
                    }

                    // Empty state
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 12
                        visible: friendListView.count === 0

                        Text {
                            text: "📭"
                            font.pixelSize: 48
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: sidebarCollapsed ? "" : "No friends yet"
                            font.pixelSize: 16
                            color: premiumTheme.textSecondary
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Button {
                            text: sidebarCollapsed ? "+" : "+ Add Friend"
                            Layout.alignment: Qt.AlignHCenter
                            visible: !sidebarCollapsed
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.down ? Qt.darker(premiumTheme.primary, 1.1) : 
                                       parent.hovered ? Qt.lighter(premiumTheme.primary, 1.1) : 
                                       premiumTheme.primary
                                
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: premiumTheme.textPrimary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: currentView = "addFriend"
                        }
                    }
                }

                // Bottom Navigation
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    color: premiumTheme.surfaceDark

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Repeater {
                            model: [
                                {iconName: "add", tooltip: "Add Friend", action: "addFriend"},
                                {iconName: "profile", tooltip: "Profile", action: "profile"},
                                {iconName: "settings", tooltip: "Settings", action: "settings"}
                            ]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 46
                                radius: 12
                                color: currentView === modelData.action ? Qt.rgba(82/255, 136/255, 193/255, 0.2) : 
                                       navButton.containsMouse ? premiumTheme.surfaceLight : "transparent"
                                
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Icon {
                                    anchors.centerIn: parent
                                    name: modelData.iconName
                                    size: sidebarCollapsed ? 24 : 22
                                    color: premiumTheme.textPrimary
                                }

                                MouseArea {
                                    id: navButton
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: currentView = modelData.action
                                    
                                    ToolTip.visible: containsMouse && sidebarCollapsed
                                    ToolTip.text: modelData.tooltip
                                    ToolTip.delay: 500
                                }
                            }
                        }

                        // Collapse Button
                        Rectangle {
                            Layout.preferredWidth: 46
                            Layout.preferredHeight: 46
                            radius: 12
                            color: collapseButton.containsMouse ? premiumTheme.surfaceLight : "transparent"
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: sidebarCollapsed ? "→" : "←"
                                font.pixelSize: 18
                                color: premiumTheme.textSecondary
                                
                                Behavior on text {
                                    SequentialAnimation {
                                        NumberAnimation { target: parent; property: "opacity"; to: 0; duration: 100 }
                                        PropertyAction { target: parent; property: "text" }
                                        NumberAnimation { target: parent; property: "opacity"; to: 1; duration: 100 }
                                    }
                                }
                            }

                            MouseArea {
                                id: collapseButton
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: sidebarCollapsed = !sidebarCollapsed
                            }
                        }
                    }
                }
            }
        }

        // Divider
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            color: premiumTheme.border
        }

        // Main Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: premiumTheme.background

            Loader {
                id: contentLoader
                anchors.fill: parent
                source: {
                    switch(currentView) {
                        case "chat": return "screens/PremiumChatView.qml"
                        case "addFriend": return "screens/PremiumAddFriend.qml"
                        case "profile": return "screens/PremiumProfile.qml"
                        case "settings": return "screens/PremiumSettings.qml"
                        case "requests": return "screens/PremiumRequests.qml"
                        case "groups": return "screens/PremiumGroups.qml"
                        default: return "screens/PremiumChatView.qml"
                    }
                }

                onLoaded: {
                    // Pass necessary properties to loaded component
                    if (item && currentView === "chat") {
                        // TODO: Pass selectedFriendPk to chat component when implemented
                        // item.selectedFriendPk = selectedFriendPk
                    }
                }
            }
        }
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl+,"
        onActivated: currentView = "settings"
    }

    Shortcut {
        sequence: "Ctrl+P"
        onActivated: currentView = "profile"
    }

    Shortcut {
        sequence: "Ctrl+N"
        onActivated: currentView = "addFriend"
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
}
