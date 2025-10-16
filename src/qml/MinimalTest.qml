// Minimal test window - no complex UI elements
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: testWindow
    visible: false
    width: 800
    height: 600
    title: "qTox - Minimal Test"
    
    Rectangle {
        anchors.fill: parent
        color: "#0E1621"
        
        Text {
            anchors.centerIn: parent
            text: "Minimal Test Window\nIf you see this, QML works!"
            font.pixelSize: 24
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
