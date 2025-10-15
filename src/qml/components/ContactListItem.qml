// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../themes"

ItemDelegate {
    id: contactItem
    
    // Properties
    property string contactName: "Contact Name"
    property string lastMessage: "Last message preview..."
    property string avatarSource: ""
    property int onlineStatus: 0  // 0: offline, 1: online, 2: away, 3: busy
    property int unreadCount: 0
    property string lastActiveTime: ""
    property bool isSelected: false
    
    // Dimensions
    width: parent.width
    height: 72
    padding: Theme.smallPadding
    
    // Background
    background: Rectangle {
        color: {
            if (contactItem.isSelected) return Theme.selectedColor
            if (contactItem.hovered) return Theme.hoverColor
            return "transparent"
        }
        
        Behavior on color {
            ColorAnimation { duration: Theme.animationFast }
        }
        
        // Selection indicator
        Rectangle {
            visible: contactItem.isSelected
            width: 4
            height: parent.height
            color: Theme.primaryColor
            anchors.left: parent.left
        }
    }
    
    // Content layout
    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacing
        
        // Avatar with status indicator
        Item {
            Layout.preferredWidth: Theme.avatarSize
            Layout.preferredHeight: Theme.avatarSize
            Layout.alignment: Qt.AlignVCenter
            
            // Avatar
            Rectangle {
                id: avatar
                anchors.fill: parent
                radius: Theme.avatarSize / 2
                color: Theme.primaryColor
                
                // Avatar image or initials
                Text {
                    anchors.centerIn: parent
                    text: contactName.charAt(0).toUpperCase()
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeHeader
                    font.weight: Theme.fontWeightBold
                    color: Theme.invertedTextColor
                }
                
                // TODO: Replace with actual avatar image when available
                // Image {
                //     anchors.fill: parent
                //     source: avatarSource
                //     fillMode: Image.PreserveAspectCrop
                //     visible: avatarSource !== ""
                // }
            }
            
            // Online status indicator
            Rectangle {
                width: 14
                height: 14
                radius: 7
                anchors {
                    right: avatar.right
                    bottom: avatar.bottom
                    rightMargin: -2
                    bottomMargin: -2
                }
                color: {
                    switch (onlineStatus) {
                        case 1: return Theme.onlineColor
                        case 2: return Theme.awayColor
                        case 3: return Theme.busyColor
                        default: return Theme.offlineColor
                    }
                }
                border.width: 2
                border.color: Theme.backgroundColor
                
                Behavior on color {
                    ColorAnimation { duration: Theme.animationNormal }
                }
            }
        }
        
        // Contact info
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: Theme.tinySpacing
            
            // Contact name and timestamp
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.smallSpacing
                
                Text {
                    text: contactName
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeBody
                    font.weight: unreadCount > 0 ? Theme.fontWeightBold : Theme.fontWeightNormal
                    color: Theme.textColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                
                Text {
                    text: lastActiveTime
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeTiny
                    color: Theme.tertiaryTextColor
                    visible: lastActiveTime !== ""
                }
            }
            
            // Last message preview
            Text {
                text: lastMessage
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryTextColor
                elide: Text.ElideRight
                Layout.fillWidth: true
                maximumLineCount: 1
            }
        }
        
        // Unread count badge
        Rectangle {
            visible: unreadCount > 0
            width: Math.max(24, unreadText.implicitWidth + 12)
            height: 24
            radius: 12
            color: Theme.primaryColor
            Layout.alignment: Qt.AlignVCenter
            
            Text {
                id: unreadText
                anchors.centerIn: parent
                text: unreadCount > 99 ? "99+" : unreadCount.toString()
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                font.weight: Theme.fontWeightBold
                color: Theme.invertedTextColor
            }
            
            // Pulse animation for new messages
            SequentialAnimation on scale {
                running: unreadCount > 0
                loops: Animation.Infinite
                NumberAnimation {
                    from: 1.0
                    to: 1.15
                    duration: 600
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    from: 1.15
                    to: 1.0
                    duration: 600
                    easing.type: Easing.InOutQuad
                }
                PauseAnimation { duration: 2000 }
            }
        }
    }
    
    // Ripple effect on click
    Rectangle {
        id: rippleEffect
        anchors.fill: parent
        color: Theme.primaryColor
        opacity: 0
        radius: 0
        
        ParallelAnimation {
            id: rippleAnimation
            NumberAnimation {
                target: rippleEffect
                property: "opacity"
                from: 0.3
                to: 0
                duration: Theme.animationSlow
            }
        }
    }
    
    onClicked: {
        rippleAnimation.restart()
    }
    
    // Mouse cursor
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: false
    }
}
