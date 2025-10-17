// qTox Premium UI - Profile Screen
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../themes"

Rectangle {
    id: root
    color: PremiumTheme.background

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 0

            // Cover/Banner
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                gradient: Gradient {
                    GradientStop { position: 0.0; color: PremiumTheme.primary }
                    GradientStop { position: 1.0; color: Qt.darker(PremiumTheme.primary, 1.3) }
                }
            }

            // Profile Content
            ColumnLayout {
                Layout.fillWidth: true
                Layout.topMargin: -80
                Layout.margins: 40
                spacing: 32

                // Profile Picture & Basic Info
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 16

                    // Avatar
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 160
                        height: 160
                        radius: 80
                        color: "#1A2332"
                        border.width: 4
                        border.color: "#0E1621"

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 8
                            radius: 76
                            color: PremiumTheme.primary

                            Text {
                                anchors.centerIn: parent
                                text: qmlBridge.username ? qmlBridge.username.charAt(0).toUpperCase() : "?"
                                font.pixelSize: 64
                                font.weight: Font.Bold
                                color: PremiumTheme.textPrimary
                            }
                        }

                        // Edit overlay
                        Rectangle {
                            anchors.fill: parent
                            radius: 80
                            color: Qt.rgba(0, 0, 0, 0.5)
                            visible: avatarMouse.containsMouse

                            Text {
                                anchors.centerIn: parent
                                text: "📷"
                                font.pixelSize: 32
                            }
                        }

                        MouseArea {
                            id: avatarMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                // TODO: Open file dialog to change avatar
                            }
                        }
                    }

                    Text {
                        text: qmlBridge.username || "Loading..."
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: PremiumTheme.textPrimary
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: qmlBridge.statusMessage || "No status message"
                        font.pixelSize: 15
                        color: PremiumTheme.textSecondary
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Profile Details Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: profileDetails.height + 48
                    radius: 20
                    color: PremiumTheme.surface

                    ColumnLayout {
                        id: profileDetails
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 24

                        Text {
                            text: "Profile Information"
                            font.pixelSize: 18
                            font.weight: Font.DemiBold
                            color: PremiumTheme.textPrimary
                        }

                        // Username
                        ProfileField {
                            Layout.fillWidth: true
                            label: "Username"
                            value: qmlBridge.username || ""
                            icon: "👤"
                            editable: true
                            onValueChanged: function(newValue) {
                                qmlBridge.setUsername(newValue)
                            }
                        }

                        // Status Message
                        ProfileField {
                            Layout.fillWidth: true
                            label: "Status Message"
                            value: qmlBridge.statusMessage || ""
                            icon: "💬"
                            editable: true
                            multiline: true
                            onValueChanged: function(newValue) {
                                qmlBridge.setStatusMessage(newValue)
                            }
                        }

                        // Tox ID
                        ProfileField {
                            Layout.fillWidth: true
                            label: "Tox ID"
                            value: qmlBridge.selfToxId || ""
                            icon: "🔑"
                            editable: false
                            monospace: true
                            copyable: true
                        }

                        // Status Selector
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "🟢 Status"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                color: PremiumTheme.textPrimary
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Repeater {
                                    model: [
                                        {text: "Online", value: 0, color: PremiumTheme.success, icon: "🟢"},
                                        {text: "Away", value: 1, color: PremiumTheme.warning, icon: "🟡"},
                                        {text: "Busy", value: 2, color: PremiumTheme.error, icon: "🔴"}
                                    ]

                                    Rectangle {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 50
                                        radius: 12
                                        color: qmlBridge.userStatus === modelData.value ? 
                                               Qt.rgba(82/255, 136/255, 193/255, 0.15) : 
                                               statusButton.containsMouse ? PremiumTheme.surfaceLight : "transparent"
                                        border.width: qmlBridge.userStatus === modelData.value ? 2 : 0
                                        border.color: PremiumTheme.primary

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
                                                font.pixelSize: 14
                                                font.weight: qmlBridge.userStatus === modelData.value ? Font.Medium : Font.Normal
                                                color: qmlBridge.userStatus === modelData.value ? PremiumTheme.primary : PremiumTheme.textSecondary
                                            }
                                        }

                                        MouseArea {
                                            id: statusButton
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: qmlBridge.setUserStatus(modelData.value)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Actions Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: actionsLayout.height + 48
                    radius: 20
                    color: PremiumTheme.surface

                    ColumnLayout {
                        id: actionsLayout
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 16

                        Text {
                            text: "Account Actions"
                            font.pixelSize: 18
                            font.weight: Font.DemiBold
                            color: PremiumTheme.textPrimary
                        }

                        ActionButton {
                            Layout.fillWidth: true
                            text: "Export Profile"
                            icon: "💾"
                            description: "Save your profile to a file"
                            onClicked: {
                                // TODO: Implement profile export
                            }
                        }

                        ActionButton {
                            Layout.fillWidth: true
                            text: "Change Password"
                            icon: "🔒"
                            description: "Update your profile password"
                            onClicked: {
                                // TODO: Implement password change
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: PremiumTheme.border
                        }

                        ActionButton {
                            Layout.fillWidth: true
                            text: "Logout"
                            icon: "🚪"
                            description: "Sign out of your account"
                            danger: true
                            onClicked: {
                                // TODO: Implement logout
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: 40 }
            }
        }
    }

    // Custom Profile Field Component
    component ProfileField: ColumnLayout {
        id: field
        property string label: ""
        property string value: ""
        property string icon: ""
        property bool editable: false
        property bool multiline: false
        property bool monospace: false
        property bool copyable: false
        signal valueChanged(string newValue)

        spacing: 8

        Text {
            text: icon + " " + label
            font.pixelSize: 14
            font.weight: Font.Medium
            color: PremiumTheme.textPrimary
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: multiline ? 100 : 50
            radius: 12
            color: editable ? PremiumTheme.surfaceLight : Qt.rgba(255, 255, 255, 0.02)
            border.width: fieldInput.activeFocus ? 2 : 1
            border.color: fieldInput.activeFocus ? PremiumTheme.primary : PremiumTheme.border

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                TextInput {
                    id: fieldInput
                    Layout.fillWidth: true
                    Layout.fillHeight: multiline
                    text: value
                    font.pixelSize: 14
                    font.family: monospace ? "Monospace" : "Inter"
                    color: PremiumTheme.textPrimary
                    readOnly: !editable
                    selectByMouse: true
                    wrapMode: multiline ? TextInput.Wrap : TextInput.NoWrap
                    clip: true
                    onEditingFinished: {
                        if (editable && text !== value) {
                            valueChanged(text)
                        }
                    }
                }

                Button {
                    visible: copyable
                    text: "📋"
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36

                    background: Rectangle {
                        radius: 8
                        color: parent.down ? PremiumTheme.surfaceLight : 
                               parent.hovered ? Qt.rgba(255, 255, 255, 0.05) : 
                               "transparent"
                    }

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        // TODO: Copy to clipboard
                    }
                }
            }
        }
    }

    // Custom Action Button Component
    component ActionButton: Rectangle {
        id: actionBtn
        property string text: ""
        property string icon: ""
        property string description: ""
        property bool danger: false
        signal clicked()

        height: 70
        radius: 12
        color: actionMouse.containsMouse ? (danger ? Qt.rgba(239/255, 68/255, 68/255, 0.1) : PremiumTheme.surfaceLight) : "transparent"

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Text {
                text: icon
                font.pixelSize: 24
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: actionBtn.text
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: danger ? PremiumTheme.error : PremiumTheme.textPrimary
                }

                Text {
                    text: description
                    font.pixelSize: 13
                    color: PremiumTheme.textSecondary
                }
            }

            Text {
                text: "→"
                font.pixelSize: 18
                color: PremiumTheme.textTertiary
            }
        }

        MouseArea {
            id: actionMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: actionBtn.clicked()
        }
    }
}
