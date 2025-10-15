// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Ubuntu Modernization Project

import QtQuick 2.15
import QtQuick.Controls 2.15
import "../themes"

Button {
    id: control
    
    // Custom properties
    property color buttonColor: Theme.primaryColor
    property color textColor: Theme.invertedTextColor
    property color hoverColor: Qt.lighter(buttonColor, 1.1)
    property color pressedColor: Qt.darker(buttonColor, 1.1)
    property int buttonRadius: Theme.borderRadius
    property bool outlined: false
    
    // Styling
    implicitWidth: Math.max(100, contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: 40
    leftPadding: Theme.padding
    rightPadding: Theme.padding
    topPadding: Theme.smallPadding
    bottomPadding: Theme.smallPadding
    
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeBody
    font.weight: Theme.fontWeightMedium
    
    // Content
    contentItem: Text {
        text: control.text
        font: control.font
        color: control.outlined ? control.buttonColor : control.textColor
        opacity: control.enabled ? 1.0 : Theme.disabledOpacity
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
        
        Behavior on color {
            ColorAnimation { duration: Theme.animationFast }
        }
    }
    
    // Background
    background: Rectangle {
        id: buttonBackground
        radius: control.buttonRadius
        color: {
            if (!control.enabled) return Theme.borderColor
            if (control.outlined) return "transparent"
            if (control.pressed) return control.pressedColor
            if (control.hovered) return control.hoverColor
            return control.buttonColor
        }
        border.width: control.outlined ? 2 : 0
        border.color: control.buttonColor
        
        Behavior on color {
            ColorAnimation { duration: Theme.animationFast }
        }
        
        // Ripple effect
        Rectangle {
            id: ripple
            x: buttonBackground.width / 2 - width / 2
            y: buttonBackground.height / 2 - height / 2
            width: 0
            height: 0
            radius: width / 2
            color: Qt.rgba(1, 1, 1, 0.3)
            opacity: 0
            
            property real targetX: buttonBackground.width / 2
            property real targetY: buttonBackground.height / 2
            
            ParallelAnimation {
                id: rippleAnimation
                NumberAnimation {
                    target: ripple
                    property: "width"
                    from: 0
                    to: buttonBackground.width * 2
                    duration: Theme.animationSlow
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: ripple
                    property: "height"
                    from: 0
                    to: buttonBackground.height * 2
                    duration: Theme.animationSlow
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    target: ripple
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: Theme.animationSlow
                    easing.type: Easing.OutCubic
                }
            }
        }
        
        // Capture mouse press for ripple positioning
        MouseArea {
            id: rippleMouseArea
            anchors.fill: parent
            onPressed: function(mouse) {
                ripple.x = mouse.x - ripple.width / 2
                ripple.y = mouse.y - ripple.height / 2
                rippleAnimation.restart()
                mouse.accepted = false // Let the button handle the actual click
            }
        }
    }
    
    // Smooth cursor change
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: false
    }
}
