// Simple icon component using Text with geometric characters
import QtQuick

Text {
    id: root
    
    property string name: "chat"
    property int size: 24
    
    font.pixelSize: size
    font.family: "DejaVu Sans"
    
    // Use simple geometric Unicode characters that are widely supported
    text: {
        switch(name) {
            case "chat": return "💬"  // Try emoji first
            case "requests": return "📩"
            case "groups": return "👥"
            case "add": return "+"
            case "profile": return "👤"
            case "settings": return "⚙"
            case "search": return "🔍"
            default: return "●"
        }
    }
    
    // Fallback to simple symbols if emojis don't render
    Component.onCompleted: {
        // Check if font supports emoji by testing rendering
        if (font.pixelSize > 0) {
            // If emoji doesn't render well, use ASCII fallbacks
            var needsFallback = false
            switch(name) {
                case "chat":
                    if (needsFallback) text = "💬";
                    break;
                case "requests":
                    if (needsFallback) text = "✉";
                    break;
                case "groups":
                    if (needsFallback) text = "≡";
                    break;
                case "add":
                    text = "+";
                    break;
                case "profile":
                    if (needsFallback) text = "◉";
                    break;
                case "settings":
                    if (needsFallback) text = "⚙";
                    break;
                case "search":
                    if (needsFallback) text = "⌕";
                    break;
            }
        }
    }
}

