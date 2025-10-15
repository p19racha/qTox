// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"
import "themes"

ApplicationWindow {
    id: mainWindow
    
    visible: true
    width: 1200
    height: 800
    minimumWidth: 900
    minimumHeight: 600
    title: "qTox - Modern Ubuntu Edition"
    
    color: Theme.backgroundColor
    
    // Main layout
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // ============================================
        // Left Sidebar - Contacts List
        // ============================================
        Rectangle {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: Theme.sidebarWidth
            Layout.minimumWidth: Theme.sidebarMinWidth
            Layout.maximumWidth: Theme.sidebarMaxWidth
            color: Theme.surfaceColor
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Profile header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.toolbarHeight
                    color: Theme.backgroundColor
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.padding
                        spacing: Theme.spacing
                        
                        // User avatar
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 20
                            color: Theme.primaryColor
                            
                            Text {
                                anchors.centerIn: parent
                                text: "U"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeTitle
                                font.weight: Theme.fontWeightBold
                                color: Theme.invertedTextColor
                            }
                        }
                        
                        // User name and status
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            Text {
                                text: "User Name"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeBody
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textColor
                            }
                            
                            Text {
                                text: "Online"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.onlineColor
                            }
                        }
                        
                        // Settings button
                        ModernButton {
                            text: "⚙"
                            buttonRadius: Theme.circleRadius
                            implicitWidth: 36
                            implicitHeight: 36
                            onClicked: {
                                // Open settings
                            }
                        }
                    }
                }
                
                // Search bar
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    Layout.margins: Theme.smallPadding
                    color: Theme.backgroundColor
                    radius: Theme.borderRadius
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.smallPadding
                        spacing: Theme.smallSpacing
                        
                        Text {
                            text: "🔍"
                            font.pixelSize: Theme.iconSizeSmall
                        }
                        
                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "Search contacts..."
                            background: Item {}
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBody
                            color: Theme.textColor
                        }
                    }
                }
                
                // Contacts list
                ListView {
                    id: contactsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 0
                    
                    model: ListModel {
                        ListElement {
                            contactName: "Alice Johnson"
                            lastMessage: "Hey, how are you doing?"
                            onlineStatus: 1
                            unreadCount: 3
                            lastActiveTime: "2m"
                        }
                        ListElement {
                            contactName: "Bob Smith"
                            lastMessage: "See you tomorrow!"
                            onlineStatus: 2
                            unreadCount: 0
                            lastActiveTime: "1h"
                        }
                        ListElement {
                            contactName: "Charlie Brown"
                            lastMessage: "Thanks for your help!"
                            onlineStatus: 3
                            unreadCount: 1
                            lastActiveTime: "3h"
                        }
                        ListElement {
                            contactName: "Diana Prince"
                            lastMessage: "Let's meet up this weekend"
                            onlineStatus: 0
                            unreadCount: 0
                            lastActiveTime: "2d"
                        }
                    }
                    
                    delegate: ContactListItem {
                        width: contactsList.width
                        contactName: model.contactName
                        lastMessage: model.lastMessage
                        onlineStatus: model.onlineStatus
                        unreadCount: model.unreadCount
                        lastActiveTime: model.lastActiveTime
                        isSelected: contactsList.currentIndex === index
                        
                        onClicked: {
                            contactsList.currentIndex = index
                        }
                    }
                    
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }
        
        // ============================================
        // Main Chat Area
        // ============================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Theme.backgroundColor
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Chat header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.toolbarHeight
                    color: Theme.surfaceColor
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.padding
                        spacing: Theme.spacing
                        
                        // Contact avatar
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 20
                            color: Theme.primaryColor
                            
                            Text {
                                anchors.centerIn: parent
                                text: "A"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeTitle
                                font.weight: Theme.fontWeightBold
                                color: Theme.invertedTextColor
                            }
                        }
                        
                        // Contact name and status
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            Text {
                                text: "Alice Johnson"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeTitle
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textColor
                            }
                            
                            Text {
                                text: "typing..."
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.primaryColor
                                
                                SequentialAnimation on opacity {
                                    running: true
                                    loops: Animation.Infinite
                                    NumberAnimation { from: 1; to: 0.3; duration: 600 }
                                    NumberAnimation { from: 0.3; to: 1; duration: 600 }
                                }
                            }
                        }
                        
                        // Call buttons
                        Row {
                            spacing: Theme.smallSpacing
                            
                            ModernButton {
                                text: "📞"
                                outlined: true
                                implicitWidth: 40
                                implicitHeight: 40
                                buttonRadius: Theme.circleRadius
                            }
                            
                            ModernButton {
                                text: "📹"
                                outlined: true
                                implicitWidth: 40
                                implicitHeight: 40
                                buttonRadius: Theme.circleRadius
                            }
                        }
                    }
                }
                
                // Messages area
                ListView {
                    id: messagesView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: Theme.padding
                    spacing: Theme.smallSpacing
                    clip: true
                    verticalLayoutDirection: ListView.BottomToTop
                    
                    model: ListModel {
                        ListElement {
                            messageText: "Hey! How's it going?"
                            timestamp: "14:23"
                            isSent: false
                            isRead: false
                            senderName: ""
                        }
                        ListElement {
                            messageText: "Pretty good! Just working on the new qTox design."
                            timestamp: "14:24"
                            isSent: true
                            isRead: true
                            senderName: ""
                        }
                        ListElement {
                            messageText: "Oh nice! Can't wait to see it."
                            timestamp: "14:25"
                            isSent: false
                            isRead: false
                            senderName: ""
                        }
                        ListElement {
                            messageText: "It's looking really modern with Qt Quick and smooth animations!"
                            timestamp: "14:26"
                            isSent: true
                            isRead: false
                            senderName: ""
                        }
                    }
                    
                    delegate: Item {
                        width: messagesView.width
                        height: bubble.height + Theme.smallSpacing
                        
                        MessageBubble {
                            id: bubble
                            anchors.right: model.isSent ? parent.right : undefined
                            anchors.left: model.isSent ? undefined : parent.left
                            messageText: model.messageText
                            timestamp: model.timestamp
                            isSent: model.isSent
                            isRead: model.isRead
                            senderName: model.senderName
                            maxWidth: messagesView.width * 0.7
                        }
                    }
                    
                    ScrollBar.vertical: ScrollBar {}
                }
                
                // Message input area
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.inputAreaHeight
                    color: Theme.surfaceColor
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.smallPadding
                        spacing: Theme.smallSpacing
                        
                        ModernButton {
                            text: "📎"
                            outlined: true
                            implicitWidth: 40
                            implicitHeight: 40
                            buttonRadius: Theme.circleRadius
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: Theme.borderRadius
                            color: Theme.backgroundColor
                            
                            TextArea {
                                anchors.fill: parent
                                anchors.margins: Theme.smallPadding
                                placeholderText: "Type a message..."
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeBody
                                color: Theme.textColor
                                wrapMode: TextArea.Wrap
                                background: Item {}
                            }
                        }
                        
                        ModernButton {
                            text: "😊"
                            outlined: true
                            implicitWidth: 40
                            implicitHeight: 40
                            buttonRadius: Theme.circleRadius
                        }
                        
                        ModernButton {
                            text: "➤"
                            implicitWidth: 40
                            implicitHeight: 40
                            buttonRadius: Theme.circleRadius
                        }
                    }
                }
            }
        }
    }
    
    // Theme toggle for testing (CTRL+T)
    Shortcut {
        sequence: "Ctrl+T"
        onActivated: Theme.toggleTheme()
    }
}
