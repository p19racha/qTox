// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import themes

Rectangle {
    id: messageBubble
    
    // Properties
    property string messageText: ""
    property string timestamp: ""
    property bool isSent: false
    property bool isRead: false
    property string senderName: ""
    property int maxWidth: 400
    
    // Styling
    width: Math.min(maxWidth, messageContent.implicitWidth + Theme.padding * 2)
    height: messageContent.implicitHeight + Theme.padding * 2
    radius: Theme.borderRadius
    color: isSent ? Theme.sentMessageColor : Theme.receivedMessageColor
    
    // Shadow effect
    layer.enabled: true
    layer.effect: DropShadow {
        radius: 4
        samples: 9
        color: Theme.shadowColor
        verticalOffset: 1
    }
    
    // Enter animation
    NumberAnimation on opacity {
        id: fadeIn
        from: 0
        to: 1
        duration: Theme.animationNormal
        easing.type: Theme.easingType
        running: false
    }
    
    NumberAnimation on y {
        id: slideIn
        from: y + 20
        to: y
        duration: Theme.animationNormal
        easing.type: Theme.easingType
        running: false
    }
    
    Component.onCompleted: {
        fadeIn.start()
        slideIn.start()
    }
    
    // Content
    ColumnLayout {
        id: messageContent
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: Theme.padding
        }
        spacing: Theme.tinySpacing
        
        // Sender name (for received messages in group chats)
        Text {
            visible: !isSent && senderName !== ""
            text: senderName
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            font.weight: Theme.fontWeightMedium
            color: Theme.primaryColor
            Layout.fillWidth: true
        }
        
        // Message text
        Text {
            id: messageTextItem
            text: messageText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeBody
            color: isSent ? Theme.invertedTextColor : Theme.textColor
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.maximumWidth: maxWidth - Theme.padding * 2
            textFormat: Text.PlainText
            
            // Link highlighting
            onLinkActivated: Qt.openUrlExternally(link)
        }
        
        // Timestamp and read indicator
        RowLayout {
            spacing: Theme.tinySpacing
            Layout.alignment: Qt.AlignRight
            
            Text {
                text: timestamp
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeTiny
                color: isSent ? 
                    Qt.rgba(255, 255, 255, 0.7) : 
                    Theme.tertiaryTextColor
            }
            
            // Read indicator (checkmarks for sent messages)
            Text {
                visible: isSent
                text: isRead ? "✓✓" : "✓"
                font.pixelSize: Theme.fontSizeSmall
                color: isRead ? Theme.successColor : Qt.rgba(255, 255, 255, 0.7)
                
                Behavior on color {
                    ColorAnimation { duration: Theme.animationFast }
                }
            }
        }
    }
    
    // Hover effect for context menu (future)
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            parent.color = Qt.lighter(isSent ? Theme.sentMessageColor : Theme.receivedMessageColor, 1.05)
        }
        
        onExited: {
            parent.color = isSent ? Theme.sentMessageColor : Theme.receivedMessageColor
        }
        
        onClicked: {
            // Show context menu (copy, delete, etc.)
        }
    }
}
