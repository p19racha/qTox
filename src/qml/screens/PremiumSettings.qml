// qTox Premium UI - Settings Screen
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../themes"

Rectangle {
    color: PremiumTheme.background

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Settings Sidebar
        Rectangle {
            Layout.preferredWidth: 280
            Layout.fillHeight: true
            color: PremiumTheme.surface

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 4

                Text {
                    text: "⚙️ Settings"
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: PremiumTheme.textPrimary
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
                        color: ListView.isCurrentItem ? Qt.rgba(82/255, 136/255, 193/255, 0.15) : 
                               settingsMouse.containsMouse ? PremiumTheme.surfaceLight : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            Text {
                                text: modelData.icon
                                font.pixelSize: 20
                            }

                            Text {
                                text: modelData.title
                                font.pixelSize: 15
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
