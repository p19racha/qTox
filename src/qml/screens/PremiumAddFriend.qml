// qTox Premium UI - Add Friend Screen
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import themes

Rectangle {
    id: root
    color: PremiumTheme.background

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 32

        // Header
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "➕ Add New Friend"
                font.pixelSize: 32
                font.weight: Font.Bold
                color: PremiumTheme.textPrimary
            }

            Text {
                text: "Connect with friends using their Tox ID"
                font.pixelSize: 16
                color: PremiumTheme.textSecondary
            }
        }

        // Add Friend Form
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 500
            radius: 20
            color: PremiumTheme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 24

                // Tox ID Input
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Tox ID"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: PremiumTheme.textPrimary
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        radius: 12
                        color: PremiumTheme.surfaceLight
                        border.width: toxIdField.activeFocus ? 2 : 1
                        border.color: toxIdField.activeFocus ? PremiumTheme.primary : PremiumTheme.border

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        TextInput {
                            id: toxIdField
                            anchors.fill: parent
                            anchors.margins: 14
                            font.pixelSize: 13
                            font.family: "Monospace"
                            color: PremiumTheme.textPrimary
                            clip: true
                            selectByMouse: true
                            
                            property string placeholderText: "Paste Tox ID here (76 characters)"
                            
                            Text {
                                anchors.fill: parent
                                text: toxIdField.placeholderText
                                font: toxIdField.font
                                color: PremiumTheme.textTertiary
                                visible: !toxIdField.text && !toxIdField.activeFocus
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Text {
                        text: toxIdField.text.length + " / 76 characters"
                        font.pixelSize: 12
                        color: PremiumTheme.textSecondary
                    }
                }

                // Message Input
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        text: "Friend Request Message (Optional)"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: PremiumTheme.textPrimary
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 150
                        radius: 12
                        color: PremiumTheme.surfaceLight
                        border.width: messageField.activeFocus ? 2 : 1
                        border.color: messageField.activeFocus ? PremiumTheme.primary : PremiumTheme.border

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        Flickable {
                            anchors.fill: parent
                            anchors.margins: 14
                            contentWidth: messageField.contentWidth
                            contentHeight: messageField.contentHeight
                            clip: true

                            TextEdit {
                                id: messageField
                                width: parent.width
                                font.pixelSize: 14
                                color: PremiumTheme.textPrimary
                                wrapMode: TextEdit.Wrap
                                selectByMouse: true
                                text: "Hi! I'd like to add you to my contact list."
                            }
                        }
                    }

                    Text {
                        text: messageField.text.length + " / 1024 characters"
                        font.pixelSize: 12
                        color: PremiumTheme.textSecondary
                    }
                }

                // Action Buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Button {
                        text: "Cancel"
                        Layout.preferredHeight: 48
                        Layout.fillWidth: true

                        background: Rectangle {
                            radius: 12
                            color: parent.down ? PremiumTheme.surfaceLight : 
                                   parent.hovered ? Qt.rgba(255, 255, 255, 0.05) : 
                                   "transparent"
                            border.width: 1
                            border.color: PremiumTheme.border
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            color: PremiumTheme.textSecondary
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            toxIdField.text = ""
                            messageField.text = "Hi! I'd like to add you to my contact list."
                        }
                    }

                    Button {
                        text: "Send Friend Request"
                        Layout.preferredHeight: 48
                        Layout.fillWidth: true
                        enabled: toxIdField.text.length >= 76

                        background: Rectangle {
                            radius: 12
                            color: parent.enabled ? 
                                   (parent.down ? Qt.darker(PremiumTheme.primary, 1.1) : 
                                    parent.hovered ? Qt.lighter(PremiumTheme.primary, 1.1) : 
                                    PremiumTheme.primary) :
                                   Qt.rgba(82/255, 136/255, 193/255, 0.3)
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        contentItem: RowLayout {
                            spacing: 8

                            Text {
                                text: "📤"
                                font.pixelSize: 18
                            }

                            Text {
                                text: parent.parent.text
                                font.pixelSize: 15
                                font.weight: Font.Medium
                                color: PremiumTheme.textPrimary
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        onClicked: {
                            if (toxIdField.text.length >= 76) {
                                qmlBridge.addFriend(toxIdField.text, messageField.text)
                                
                                // Show success feedback
                                successNotification.visible = true
                                successTimer.restart()
                                
                                // Clear form
                                toxIdField.text = ""
                                messageField.text = "Hi! I'd like to add you to my contact list."
                            }
                        }
                    }
                }
            }
        }

        // Quick Actions
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 20
            color: Qt.rgba(82/255, 136/255, 193/255, 0.1)
            border.width: 1
            border.color: Qt.rgba(82/255, 136/255, 193/255, 0.2)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "💡"
                    font.pixelSize: 32
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "How to find a Tox ID"
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        color: PremiumTheme.textPrimary
                    }

                    Text {
                        text: "Ask your friend to share their Tox ID from their Profile page. It's a unique 76-character identifier that looks like an email address."
                        font.pixelSize: 13
                        color: PremiumTheme.textSecondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Success Notification
    Rectangle {
        id: successNotification
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 350
        height: 60
        radius: 12
        color: PremiumTheme.surface
        border.width: 1
        border.color: "#4CAF50"
        visible: false

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: "✓"
                font.pixelSize: 24
                color: PremiumTheme.success
            }

            Text {
                text: "Friend request sent successfully!"
                font.pixelSize: 14
                font.weight: Font.Medium
                color: PremiumTheme.textPrimary
                Layout.fillWidth: true
            }
        }

        Timer {
            id: successTimer
            interval: 3000
            onTriggered: successNotification.visible = false
        }
    }
}
