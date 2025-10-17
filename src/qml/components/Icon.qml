// Simple visible icon component
import QtQuick

Rectangle {
    id: root
    
    property string name: "chat"
    property int size: 24
    property color iconColor: "#FFFFFF"
    
    width: size
    height: size
    color: "transparent"
    
    // Debug: show colored square if icon doesn't render (placed behind the glyph)
    Rectangle {
        anchors.centerIn: parent
        width: root.size * 0.6
        height: root.size * 0.6
        radius: width / 2
        // Match the Text color/fallback
        color: (root.color && root.color !== "transparent") ? root.color : root.iconColor
        opacity: 0.3
        visible: parent.visible
    }


    Text {
        anchors.centerIn: parent
        font.pixelSize: root.size
        font.bold: true
        // Use Rectangle's color if explicitly set on the component, otherwise fall back to iconColor
        color: (root.color && root.color !== "transparent") ? root.color : root.iconColor

        // Use simple visible characters that always render
        text: {
            switch(root.name) {
                case "chat": return "💬"
                case "requests": return "📩"
                case "groups": return "👥"
                case "add": return "✚"
                case "profile": return "👤"
                case "settings": return "⚙"
                case "search": return "🔍"
                default: return "●"
            }
        }
    }
}

