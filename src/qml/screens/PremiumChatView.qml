// qTox Premium UI - Chat View (Empty State)
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#0E1621"
    
    // Empty state when no friend selected
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24
        
        // Large icon
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 120
            height: 120
            radius: 60
            color: "#1A2332"
            
            Text {
                anchors.centerIn: parent
                text: "💬"
                font.pixelSize: 64
            }
        }
        
        // Main text
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Select a Friend to Start Chatting"
            font.pixelSize: 24
            font.weight: Font.Medium
            color: "#FFFFFF"
        }
        
        // Subtitle
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Choose a contact from the sidebar or add a new friend"
            font.pixelSize: 14
            color: "#8B98A5"
        }
        
        // Add Friend Button
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 16
            width: 180
            height: 48
            radius: 24
            color: addButtonMouse.containsMouse ? "#1E8BC3" : "#2AABEE"
            
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
            
            RowLayout {
                anchors.centerIn: parent
                spacing: 8
                
                Text {
                    text: "✚"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#FFFFFF"
                }
                
                Text {
                    text: "Add Friend"
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                }
            }
            
            MouseArea {
                id: addButtonMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    // Emit signal to parent to change view
                    if (mainWindow) {
                        mainWindow.currentView = "addFriend"
                    }
                }
            }
        }
    }
    
    // Helper text at bottom
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        text: "Your messages are encrypted end-to-end with the Tox protocol"
        font.pixelSize: 12
        color: "#6B7885"
    }
}
