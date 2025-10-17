// qTox Premium UI - Settings Screen (Functional)
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    // Inline theme matching PremiumMainWindow
    property var theme: QtObject {
        readonly property color background: "#0E1621"
        readonly property color surface: "#1A2332"
        readonly property color surfaceLight: "#232E3E"
        readonly property color primary: "#2AABEE"
        readonly property color textPrimary: "#FFFFFF"
        readonly property color textSecondary: "#7F8C9C"
    }
    
    color: theme.background

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Settings Sidebar
        Rectangle {
            Layout.preferredWidth: 280
            Layout.fillHeight: true
            color: theme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 4

                Text {
                    text: "⚙️ Settings"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: theme.textPrimary
                    Layout.bottomMargin: 20
                }

                Repeater {
                    model: [
                        {title: "General", icon: "🎨"},
                        {title: "Privacy", icon: "🔒"},
                        {title: "Audio & Video", icon: "🎤"},
                        {title: "Advanced", icon: "⚡"},
                        {title: "About", icon: "ℹ️"}
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        radius: 12
                        color: settingsMouse.containsMouse ? theme.surfaceLight : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            Text {
                                text: modelData.icon
                                font.pixelSize: 20
                                color: theme.textPrimary
                            }

                            Text {
                                text: modelData.title
                                font.pixelSize: 15
                                color: theme.textPrimary
                            }
                        }

                        MouseArea {
                            id: settingsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
        }

        // Settings Content
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.background

            ScrollView {
                anchors.fill: parent
                anchors.margins: 30
                clip: true

                ColumnLayout {
                    width: parent.width - 60
                    spacing: 25

                    // Header
                    Text {
                        text: "General Settings"
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: theme.textPrimary
                    }

                    // Username Section
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Username"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            color: theme.textPrimary
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            radius: 12
                            color: theme.surface
                            border.width: usernameFocus.activeFocus ? 2 : 0
                            border.color: theme.primary

                            TextField {
                                id: usernameFocus
                                anchors.fill: parent
                                anchors.margins: 15
                                placeholderText: qmlBridge ? qmlBridge.username : "Enter username"
                                text: qmlBridge ? qmlBridge.username : ""
                                color: theme.textPrimary
                                font.pixelSize: 14
                                background: Item {}
                                
                                onEditingFinished: {
                                    if (qmlBridge) {
                                        qmlBridge.setUsername(text)
                                    }
                                }
                            }
                        }
                    }

                    // Status Message Section
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Status Message"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            color: theme.textPrimary
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            radius: 12
                            color: theme.surface

                            TextField {
                                anchors.fill: parent
                                anchors.margins: 15
                                placeholderText: qmlBridge ? qmlBridge.statusMessage : "What's on your mind?"
                                text: qmlBridge ? qmlBridge.statusMessage : ""
                                color: theme.textPrimary
                                font.pixelSize: 14
                                background: Item {}
                                
                                onEditingFinished: {
                                    if (qmlBridge) {
                                        qmlBridge.setStatusMessage(text)
                                    }
                                }
                            }
                        }
                    }

                    // About Section
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        radius: 16
                        color: theme.surface

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 10

                            Text {
                                text: "qTox Premium"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                                color: theme.primary
                            }

                            Text {
                                text: "Modern, Secure, Private Messaging"
                                font.pixelSize: 14
                                color: theme.textSecondary
                            }

                            Text {
                                text: "Version: 1.0.0 (Premium UI)"
                                font.pixelSize: 13
                                color: theme.textSecondary
                            }
                        }
                    }
                }
            }
        }
    }
}

                                color: PremiumTheme.textPrimary
                            }
                        }

                        MouseArea {
                            id: settingsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // Divider
        Rectangle {
            Layout.preferredWidth: 1
            Layout.fillHeight: true
            color: PremiumTheme.border
        }

        // Settings Content
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: PremiumTheme.background

            ScrollView {
                anchors.fill: parent
                contentWidth: availableWidth
                clip: true

                ColumnLayout {
                    width: parent.width
                    spacing: 24
                    anchors.margins: 40

                    Text {
                        text: "⚙️ General Settings"
                        font.pixelSize: 28
                        font.weight: Font.Bold
                        color: PremiumTheme.textPrimary
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 300
                        radius: 20
                        color: PremiumTheme.surface

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 24
                            spacing: 20

                            Text {
                                text: "🌙 Theme"
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: PremiumTheme.textPrimary
                            }

                            Text {
                                text: "Dark Theme - Always enabled for eye comfort and modern aesthetics"
                                font.pixelSize: 14
                                color: PremiumTheme.textSecondary
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillHeight: true }

                            Text {
                                text: "qTox Premium UI v1.0"
                                font.pixelSize: 13
                                color: PremiumTheme.textTertiary
                            }
                        }
                    }
                }
            }
        }
    }
}
