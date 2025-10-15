# qTox Modern UI - Quick Start Guide

## Overview

This directory contains the new modern Qt Quick/QML-based UI for qTox, designed specifically for Ubuntu Linux with a Signal/Telegram-inspired aesthetic.

## Architecture

```
src/qml/
├── main.qml                 # Main application window
├── components/              # Reusable UI components
│   ├── ModernButton.qml     # Styled button with ripple effect
│   ├── MessageBubble.qml    # Chat message bubble
│   └── ContactListItem.qml  # Contact list entry
├── pages/                   # Full-screen pages
│   ├── ChatPage.qml
│   ├── SettingsPage.qml
│   └── ...
├── dialogs/                 # Modal dialogs
│   ├── AddFriendDialog.qml
│   └── ...
└── themes/                  # Theme system
    ├── Theme.qml            # Singleton theme provider
    └── qmldir              # QML module definition
```

## Key Features

### 🎨 Modern Design
- **Signal/Telegram-inspired** layout and aesthetics
- **Rounded corners** and smooth edges throughout
- **Dynamic theming** with light/dark mode support
- **Ubuntu system theme** integration

### ✨ Smooth Animations
- Message send/receive animations
- Page transitions
- Button ripple effects
- Typing indicators
- Smooth scrolling

### 📱 Responsive
- Adapts to different window sizes
- HiDPI display support
- Flexible layouts
- Minimum and maximum size constraints

### 🎯 Components

#### ModernButton
A styled button component with:
- Ripple effect on click
- Hover and press states
- Outlined and filled variants
- Customizable colors
- Smooth transitions

```qml
ModernButton {
    text: "Send"
    onClicked: {
        // Handle click
    }
}

ModernButton {
    text: "Cancel"
    outlined: true
    buttonColor: Theme.errorColor
}
```

#### MessageBubble
Chat message display with:
- Different styles for sent/received messages
- Timestamp display
- Read receipts (✓✓)
- Fade-in and slide-in animations
- Sender name (for group chats)
- Context menu support

```qml
MessageBubble {
    messageText: "Hello!"
    timestamp: "14:23"
    isSent: true
    isRead: true
}
```

#### ContactListItem
Contact list entry with:
- Avatar with online status indicator
- Last message preview
- Unread count badge with pulse animation
- Hover and selection states
- Time since last active

```qml
ContactListItem {
    contactName: "Alice"
    lastMessage: "See you soon!"
    onlineStatus: 1  // 1=online, 2=away, 3=busy, 0=offline
    unreadCount: 3
}
```

### 🎨 Theme System

The theme is a QML singleton providing:
- **Colors**: Primary, secondary, text, background, etc.
- **Dimensions**: Spacing, padding, border radius
- **Typography**: Font sizes, weights, families
- **Animations**: Duration and easing curves
- **Layout**: Sidebar width, toolbar height, etc.

Access theme properties:
```qml
import "../themes"

Rectangle {
    color: Theme.backgroundColor
    radius: Theme.borderRadius
}

Text {
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSizeBody
    color: Theme.textColor
}

NumberAnimation {
    duration: Theme.animationNormal
    easing.type: Theme.easingType
}
```

Toggle theme:
```qml
// Press Ctrl+T in the demo
Theme.toggleTheme()
```

## Development

### Running the Demo

The `main.qml` file contains a demonstration of the new UI with:
- Contact list with sample contacts
- Chat interface with sample messages
- Typing indicator
- Modern input area

### Adding New Components

1. Create your component in `components/`
2. Import the theme: `import "../themes"`
3. Use theme properties for consistency
4. Add animations for smooth UX
5. Document the component's properties

Example:
```qml
// components/MyComponent.qml
import QtQuick 2.15
import "../themes"

Rectangle {
    property string myText: ""
    
    color: Theme.backgroundColor
    radius: Theme.borderRadius
    
    Text {
        text: myText
        color: Theme.textColor
        font.family: Theme.fontFamily
    }
    
    Behavior on color {
        ColorAnimation { duration: Theme.animationFast }
    }
}
```

### Integrating with C++ Backend

Create controller classes to bridge C++ and QML:

```cpp
// ui/ChatController.h
class ChatController : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentFriend READ currentFriend NOTIFY currentFriendChanged)
    Q_PROPERTY(QAbstractListModel* messages READ messages CONSTANT)
    
public:
    Q_INVOKABLE void sendMessage(const QString& message);
    Q_INVOKABLE void loadHistory();
    
signals:
    void messageReceived(const QString& message, const QString& sender);
    void currentFriendChanged();
};
```

Register with QML:
```cpp
qmlRegisterType<ChatController>("QTox.Controllers", 1, 0, "ChatController");
```

Use in QML:
```qml
import QTox.Controllers 1.0

ChatController {
    id: chatController
    
    onMessageReceived: {
        // Add to message list
    }
}
```

## Design Guidelines

### Colors
- Use theme colors for consistency
- Primary color: `#5DADE2` (qTox blue)
- Online: `#27AE60` (green)
- Away: `#F39C12` (orange)
- Busy: `#E74C3C` (red)

### Spacing
- Use multiples of 4px
- `tinySpacing`: 4px
- `smallSpacing`: 8px
- `spacing`: 16px
- `largeSpacing`: 24px

### Border Radius
- Cards/Dialogs: 12px
- Buttons: 12px
- Small elements: 6px
- Circular: 999px

### Typography
- Use Ubuntu font family
- Body text: 14px
- Headers: 18px
- Titles: 24px

### Animations
- Fast: 100ms (micro-interactions)
- Normal: 200ms (most transitions)
- Slow: 300ms (page transitions)
- Use `Easing.OutCubic` for natural feel

## Next Steps

1. **Complete platform cleanup** - Finish removing Windows/macOS code
2. **Update CMakeLists.txt** - Add Qt Quick dependencies
3. **Create C++ controllers** - Bridge existing logic with QML UI
4. **Implement all pages** - Settings, Profile, File Transfers, etc.
5. **Add remaining components** - Emojipicker, File preview, etc.
6. **Ubuntu integration** - System theme detection, notifications
7. **Performance optimization** - Virtual scrolling, image caching
8. **Testing** - Functional and visual testing

## Testing the UI

To preview the QML UI (once CMake is updated):

```bash
# Install Qt Quick components if not already installed
sudo apt install qml-module-qtquick2 qml-module-qtquick-controls2

# Run with qmlscene
qmlscene src/qml/main.qml

# Or use Qt Creator to open main.qml
```

## Resources

- [Qt Quick Documentation](https://doc.qt.io/qt-6/qtquick-index.html)
- [Qt Quick Controls](https://doc.qt.io/qt-6/qtquickcontrols-index.html)
- [Material Design Guidelines](https://material.io/design)
- [Ubuntu Design](https://design.ubuntu.com/)

## Contributing

When adding new UI components:
1. Follow the established patterns
2. Use the theme system consistently
3. Add smooth animations
4. Test on different screen sizes
5. Ensure HiDPI scaling works
6. Document your components

---

**Status**: Initial implementation complete
**Last Updated**: October 15, 2025
