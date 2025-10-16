// qTox Premium UI - Main Application Window
// Complete chat application with navigation, friend list, and all screens

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "themes"
import "components/premium"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1400
    height: 900
    minimumWidth: 1200
    minimumHeight: 700
    title: "qTox - Secure Messaging"
    color: PremiumTheme.background

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
            color: PremiumTheme.surface
            
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
                    color: PremiumTheme.surfaceDark
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        // Profile Picture
                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 56
                            radius: 28
                            color: PremiumTheme.primary
                            
                            Text {
                                anchors.centerIn: parent
                                text: qmlBridge.username ? qmlBridge.username.charAt(0).toUpperCase() : "?"
                                font.pixelSize: 24
                                font.weight: Font.Medium
                                color: PremiumTheme.textPrimary
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
                                color: PremiumTheme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: qmlBridge.statusMessage || "No status message"
                                font.pixelSize: 13
                                color: PremiumTheme.textSecondary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        // Status Indicator
                        Rectangle {
                            Layout.preferredWidth: 12
                            Layout.preferredHeight: 12
                            radius: 6
                            color: qmlBridge.isConnected ? PremiumTheme.success : PremiumTheme.error
                            border.width: 2
                            border.color: PremiumTheme.surfaceDark
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
                        color: PremiumTheme.surfaceLight
                        border.width: 1
                        border.color: searchField.activeFocus ? PremiumTheme.primary : "transparent"
                        
                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            Text {
                                text: "🔍"
                                font.pixelSize: 18
                                color: PremiumTheme.textSecondary
                            }

                            TextField {
                                id: searchField
                                Layout.fillWidth: true
                                placeholderText: "Search contacts..."
                                color: PremiumTheme.textPrimary
                                placeholderTextColor: PremiumTheme.textSecondary
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
                                {text: "Chats", value: "chat", icon: "💬"},
                                {text: "Requests", value: "requests", icon: "📩"},
                                {text: "Groups", value: "groups", icon: "👥"}
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
                                    spacing: 6

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 16
                                    }

                                    Text {
                                        text: modelData.text
                                        font.pixelSize: 13
                                        font.weight: currentView === modelData.value ? Font.Medium : Font.Normal
                                        color: currentView === modelData.value ? PremiumTheme.primary : PremiumTheme.textSecondary
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
                        model: qmlBridge.friendListModel

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                            width: 6
                            
                            contentItem: Rectangle {
                                radius: 3
                                color: PremiumTheme.textSecondary
                                opacity: parent.pressed ? 0.8 : 0.5
                            }
                        }

                        delegate: PremiumContactCard {
                            width: friendListView.width
                            friendName: model.friendName
                            statusMsg: model.statusMessage
                            lastMsg: model.lastMessage || "No messages yet"
                            timestamp: model.lastMessageTime || ""
                            unreadCount: model.unreadCount || 0
                            isOnline: model.isOnline
                            isSelected: selectedFriendPk === model.publicKey
                            showCompact: sidebarCollapsed

                            onClicked: {
                                selectedFriendPk = model.publicKey
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
                            color: PremiumTheme.textSecondary
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Button {
                            text: sidebarCollapsed ? "+" : "+ Add Friend"
                            Layout.alignment: Qt.AlignHCenter
                            visible: !sidebarCollapsed
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.down ? Qt.darker(PremiumTheme.primary, 1.1) : 
                                       parent.hovered ? Qt.lighter(PremiumTheme.primary, 1.1) : 
                                       PremiumTheme.primary
                                
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: PremiumTheme.textPrimary
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
                    color: PremiumTheme.surfaceDark

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Repeater {
                            model: [
                                {icon: "➕", tooltip: "Add Friend", action: "addFriend"},
                                {icon: "👤", tooltip: "Profile", action: "profile"},
                                {icon: "⚙️", tooltip: "Settings", action: "settings"}
                            ]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 46
                                radius: 12
                                color: currentView === modelData.action ? Qt.rgba(82/255, 136/255, 193/255, 0.2) : 
                                       navButton.containsMouse ? PremiumTheme.surfaceLight : "transparent"
                                
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.icon
                                    font.pixelSize: sidebarCollapsed ? 24 : 20
                                    color: PremiumTheme.textPrimary
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
                            color: collapseButton.containsMouse ? PremiumTheme.surfaceLight : "transparent"
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: sidebarCollapsed ? "→" : "←"
                                font.pixelSize: 18
                                color: PremiumTheme.textSecondary
                                
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
            color: PremiumTheme.border
        }

        // Main Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: PremiumTheme.background

            Loader {
                id: contentLoader
                anchors.fill: parent
                source: {
                    switch(currentView) {
                        case "chat": return "premium_chat.qml"
                        case "addFriend": return "screens/PremiumAddFriend.qml"
                        case "profile": return "screens/PremiumProfile.qml"
                        case "settings": return "screens/PremiumSettings.qml"
                        case "requests": return "screens/PremiumRequests.qml"
                        case "groups": return "screens/PremiumGroups.qml"
                        default: return "premium_chat.qml"
                    }
                }

                onLoaded: {
                    // Pass necessary properties to loaded component
                    if (item && currentView === "chat") {
                        item.selectedFriendPk = selectedFriendPk
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
