// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Chat Interface (WhatsApp/Telegram Style)

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import "./components/premium"
import "./themes"

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 800
    title: "qTox - Premium Messenger"
    color: PremiumTheme.backgroundPrimary
    
    // ═══════════════════════════════════════════════════════════════
    // MAIN LAYOUT - WhatsApp/Telegram style two-panel
    // ═══════════════════════════════════════════════════════════════
    
    Row {
        anchors.fill: parent
        spacing: 0
        
        // ═════════════════════════════════════════════════════════
        // LEFT PANEL - Contacts List
        // ═══════════════════════════════════════════════════════════
        
        Rectangle {
            id: contactsPanel
            width: 380
            height: parent.height
            color: PremiumTheme.backgroundPrimary
            
            // Subtle right border
            Rectangle {
                width: 1
                height: parent.height
                color: PremiumTheme.divider
                anchors.right: parent.right
            }
            
            Column {
                anchors.fill: parent
                spacing: 0
                
                // ═══════════════════════════════════════════════════
                // HEADER - App title and actions
                // ═══════════════════════════════════════════════════
                
                Rectangle {
                    width: parent.width
                    height: 64
                    color: PremiumTheme.backgroundPrimary
                    
                    // Glossy overlay
                    Rectangle {
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "rgba(255, 255, 255, 0.02)" }
                            GradientStop { position: 1.0; color: "rgba(0, 0, 0, 0.02)" }
                        }
                    }
                    
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: PremiumTheme.spacingLg
                        anchors.rightMargin: PremiumTheme.spacingLg
                        spacing: PremiumTheme.spacingMd
                        
                        // App title
                        Text {
                            text: "qTox"
                            font.family: PremiumTheme.fontFamily
                            font.pixelSize: PremiumTheme.fontSizeXl
                            font.weight: PremiumTheme.fontWeightBold
                            color: PremiumTheme.textPrimary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Item { Layout.fillWidth: true; width: parent.width - 200 }
                        
                        // Theme toggle button
                        Rectangle {
                            width: 40
                            height: 40
                            radius: PremiumTheme.radiusFull
                            color: PremiumTheme.surfaceElevated
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: PremiumTheme.isDark ? "☀️" : "🌙"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: PremiumTheme.toggleTheme()
                            }
                            
                            // Hover effect
                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: PremiumTheme.isDark ? "rgba(255, 255, 255, 0.05)" : "rgba(0, 0, 0, 0.05)"
                                opacity: themeHover.containsMouse ? 1 : 0
                                
                                Behavior on opacity {
                                    NumberAnimation { duration: PremiumTheme.durationFast }
                                }
                            }
                            
                            MouseArea {
                                id: themeHover
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: PremiumTheme.toggleTheme()
                            }
                        }
                    }
                    
                    // Bottom border
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: PremiumTheme.divider
                        anchors.bottom: parent.bottom
                    }
                }
                
                // ═══════════════════════════════════════════════════
                // SEARCH BAR - Premium design
                // ═══════════════════════════════════════════════════
                
                Rectangle {
                    width: parent.width
                    height: 60
                    color: PremiumTheme.backgroundSecondary
                    
                    Rectangle {
                        width: parent.width - PremiumTheme.spacingLg * 2
                        height: 40
                        radius: PremiumTheme.radiusLarge
                        color: PremiumTheme.backgroundPrimary
                        border.width: 2
                        border.color: searchFocus.activeFocus ? PremiumTheme.primary : PremiumTheme.border
                        anchors.centerIn: parent
                        
                        Behavior on border.color {
                            ColorAnimation { duration: PremiumTheme.durationNormal }
                        }
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: PremiumTheme.spacingSm
                            spacing: PremiumTheme.spacingSm
                            
                            Text {
                                text: "🔍"
                                font.pixelSize: 18
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            TextInput {
                                id: searchFocus
                                width: parent.width - 40
                                height: parent.height
                                font.family: PremiumTheme.fontFamily
                                font.pixelSize: PremiumTheme.fontSizeMd
                                color: PremiumTheme.textPrimary
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    visible: !searchFocus.text
                                    text: "Search contacts..."
                                    font: searchFocus.font
                                    color: PremiumTheme.textTertiary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }
                }
                
                // ═══════════════════════════════════════════════════
                // CONTACTS LIST - Smooth scrolling
                // ═══════════════════════════════════════════════════
                
                ListView {
                    id: contactsList
                    width: parent.width
                    height: parent.height - 124
                    clip: true
                    boundsBehavior: Flickable.DragOverBounds
                    
                    // Smooth scrolling
                    maximumFlickVelocity: 2500
                    flickDeceleration: 1500
                    
                    model: ListModel {
                        ListElement {
                            contactName: "Alice Johnson"
                            contactMessage: "Hey! Are you free tomorrow?"
                            contactTime: "12:45"
                            contactAvatar: "AJ"
                            contactColor: "#00a884"
                            contactOnline: true
                            contactUnread: 3
                            contactTyping: false
                        }
                        ListElement {
                            contactName: "Bob Smith"
                            contactMessage: "Thanks for the help!"
                            contactTime: "11:30"
                            contactAvatar: "BS"
                            contactColor: "#3390ec"
                            contactOnline: false
                            contactUnread: 0
                            contactTyping: false
                        }
                        ListElement {
                            contactName: "Charlie Davis"
                            contactMessage: "Let's meet up this weekend"
                            contactTime: "Yesterday"
                            contactAvatar: "CD"
                            contactColor: "#ff9800"
                            contactOnline: true
                            contactUnread: 0
                            contactTyping: true
                        }
                        ListElement {
                            contactName: "Diana Martinez"
                            contactMessage: "😊 Sounds good!"
                            contactTime: "Yesterday"
                            contactAvatar: "DM"
                            contactColor: "#e91e63"
                            contactOnline: false
                            contactUnread: 0
                            contactTyping: false
                        }
                    }
                    
                    delegate: PremiumContactCard {
                        name: contactName
                        lastMessage: contactMessage
                        timestamp: contactTime
                        avatarText: contactAvatar
                        avatarColor: contactColor
                        online: contactOnline
                        unreadCount: contactUnread
                        typing: contactTyping
                        selected: contactsList.currentIndex === index
                        
                        onClicked: {
                            contactsList.currentIndex = index
                        }
                    }
                    
                    // Smooth scroll animation
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        
                        contentItem: Rectangle {
                            implicitWidth: 6
                            radius: width / 2
                            color: PremiumTheme.textTertiary
                            opacity: 0.3
                        }
                    }
                }
            }
        }
        
        // ═══════════════════════════════════════════════════════════
        // RIGHT PANEL - Chat Area
        // ═══════════════════════════════════════════════════════════
        
        Rectangle {
            id: chatPanel
            width: parent.width - contactsPanel.width
            height: parent.height
            
            // Chat background with subtle pattern
            Rectangle {
                anchors.fill: parent
                color: PremiumTheme.backgroundChat
                
                // Subtle gradient
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.lighter(PremiumTheme.backgroundChat, 1.02) }
                    GradientStop { position: 1.0; color: Qt.darker(PremiumTheme.backgroundChat, 1.02) }
                }
            }
            
            Column {
                anchors.fill: parent
                spacing: 0
                
                // ═══════════════════════════════════════════════════
                // CHAT HEADER - Contact info
                // ═══════════════════════════════════════════════════
                
                Rectangle {
                    width: parent.width
                    height: 64
                    color: PremiumTheme.surfaceElevated
                    
                    // Glossy effect
                    Rectangle {
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "rgba(255, 255, 255, 0.03)" }
                            GradientStop { position: 1.0; color: "rgba(0, 0, 0, 0.03)" }
                        }
                    }
                    
                    Row {
                        anchors.fill: parent
                        anchors.margins: PremiumTheme.spacingMd
                        spacing: PremiumTheme.spacingMd
                        
                        // Avatar
                        Rectangle {
                            width: PremiumTheme.avatarSizeMedium
                            height: PremiumTheme.avatarSizeMedium
                            radius: width / 2
                            color: "#00a884"
                            anchors.verticalCenter: parent.verticalCenter
                            
                            Text {
                                text: "AJ"
                                anchors.centerIn: parent
                                font.family: PremiumTheme.fontFamily
                                font.pixelSize: PremiumTheme.fontSizeMd
                                font.weight: PremiumTheme.fontWeightMedium
                                color: "white"
                            }
                            
                            // Online indicator
                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: PremiumTheme.online
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right
                                border.width: 2
                                border.color: PremiumTheme.surfaceElevated
                            }
                        }
                        
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            
                            Text {
                                text: "Alice Johnson"
                                font.family: PremiumTheme.fontFamily
                                font.pixelSize: PremiumTheme.fontSizeMd
                                font.weight: PremiumTheme.fontWeightSemibold
                                color: PremiumTheme.textPrimary
                            }
                            
                            Text {
                                text: "online"
                                font.family: PremiumTheme.fontFamily
                                font.pixelSize: PremiumTheme.fontSizeSm
                                color: PremiumTheme.online
                            }
                        }
                    }
                    
                    // Bottom border
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: PremiumTheme.divider
                        anchors.bottom: parent.bottom
                    }
                }
                
                // ═══════════════════════════════════════════════════
                // MESSAGES AREA - Smooth scrolling chat
                // ═══════════════════════════════════════════════════
                
                ListView {
                    id: messagesView
                    width: parent.width
                    height: parent.height - 128
                    clip: true
                    verticalLayoutDirection: ListView.BottomToTop
                    spacing: PremiumTheme.spacing2xs
                    
                    // Smooth scrolling
                    maximumFlickVelocity: 3000
                    flickDeceleration: 2000
                    boundsBehavior: Flickable.DragOverBounds
                    
                    model: ListModel {
                        ListElement { msg: "Hey! How are you?"; time: "12:30"; isSent: false; isDelivered: false; isRead: false }
                        ListElement { msg: "I'm doing great, thanks! 😊"; time: "12:31"; isSent: true; isDelivered: true; isRead: true }
                        ListElement { msg: "What are you up to this weekend?"; time: "12:32"; isSent: false; isDelivered: false; isRead: false }
                        ListElement { msg: "Not much, probably just relaxing. How about you?"; time: "12:33"; isSent: true; isDelivered: true; isRead: true }
                        ListElement { msg: "Want to grab coffee on Saturday?"; time: "12:45"; isSent: false; isDelivered: false; isRead: false }
                        ListElement { msg: "That sounds perfect! What time?"; time: "12:46"; isSent: true; isDelivered: true; isRead: false }
                    }
                    
                    delegate: Item {
                        width: messagesView.width
                        height: bubble.height + PremiumTheme.spacingSm
                        
                        PremiumMessageBubble {
                            id: bubble
                            message: msg
                            timestamp: time
                            sent: isSent
                            delivered: isDelivered
                            read: isRead
                            anchors.left: isSent ? undefined : parent.left
                            anchors.right: isSent ? parent.right : undefined
                            anchors.leftMargin: PremiumTheme.spacingLg
                            anchors.rightMargin: PremiumTheme.spacingLg
                        }
                    }
                    
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        contentItem: Rectangle {
                            implicitWidth: 6
                            radius: 3
                            color: PremiumTheme.textTertiary
                            opacity: 0.3
                        }
                    }
                }
                
                // ═══════════════════════════════════════════════════
                // MESSAGE INPUT - Premium design
                // ═══════════════════════════════════════════════════
                
                Rectangle {
                    width: parent.width
                    height: 64
                    color: PremiumTheme.surfaceElevated
                    
                    Rectangle {
                        width: parent.width - PremiumTheme.spacingLg * 2
                        height: 44
                        radius: PremiumTheme.radiusXLarge
                        color: PremiumTheme.backgroundPrimary
                        border.width: 2
                        border.color: messageInput.activeFocus ? PremiumTheme.primary : PremiumTheme.border
                        anchors.centerIn: parent
                        
                        Behavior on border.color {
                            ColorAnimation { duration: PremiumTheme.durationNormal }
                        }
                        
                        Row {
                            anchors.fill: parent
                            anchors.margins: PremiumTheme.spacingSm
                            spacing: PremiumTheme.spacingSm
                            
                            TextInput {
                                id: messageInput
                                width: parent.width - 80
                                height: parent.height
                                font.family: PremiumTheme.fontFamily
                                font.pixelSize: PremiumTheme.fontSizeMd
                                color: PremiumTheme.textPrimary
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    visible: !messageInput.text
                                    text: "Type a message..."
                                    font: messageInput.font
                                    color: PremiumTheme.textTertiary
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            
                            // Send button
                            Rectangle {
                                width: 36
                                height: 36
                                radius: PremiumTheme.radiusFull
                                color: messageInput.text.length > 0 ? PremiumTheme.primary : PremiumTheme.surfaceElevated
                                anchors.verticalCenter: parent.verticalCenter
                                
                                Behavior on color {
                                    ColorAnimation { duration: PremiumTheme.durationNormal }
                                }
                                
                                Text {
                                    text: "➤"
                                    font.pixelSize: 18
                                    color: "white"
                                    anchors.centerIn: parent
                                    rotation: -45
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    enabled: messageInput.text.length > 0
                                    onClicked: {
                                        if (messageInput.text.length > 0) {
                                            messageInput.text = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Global keyboard shortcut for theme toggle
    Shortcut {
        sequence: "Ctrl+T"
        onActivated: PremiumTheme.toggleTheme()
    }
    
    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }
}
