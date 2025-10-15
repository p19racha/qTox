# qTox Ubuntu-Only Modernization Roadmap

## Project Overview
Refactoring qTox to be Ubuntu Linux exclusive with a modern, Signal/Telegram-inspired UI using Qt Quick/QML.

## Phase 1: Platform Cleanup ✅ In Progress

### Completed:
- ✅ Removed macOS-specific code from `nexus.cpp` and `nexus.h`
- ✅ Removed macOS-specific code from `widget.cpp` and `widget.h`
- ✅ Cleaned up `paths.cpp` to use Linux/XDG paths only
- ✅ Simplified `ipc.cpp` for Linux-only
- ✅ Removed macOS event handling from `loginscreen.cpp`
- ✅ Started cleanup of `cameradevice.cpp`

### Remaining Platform Cleanup Tasks:
1. **Complete cameradevice.cpp cleanup** - Remove Windows/macOS camera handling code (lines 234-555)
   - Keep only V4L2 (Video4Linux2) camera support
   - Remove DirectShow (Windows) and AVFoundation (macOS) code paths

2. **Clean up corefile.cpp** - Remove Windows file path handling
   - Line 360: Remove `#ifdef Q_OS_WIN` block

3. **Clean up posixsignalnotifier.cpp** - Remove macOS signal handling
   - Line 77: Remove `#ifdef Q_OS_MACOS` block

4. **Update CMakeLists.txt**
   - Remove any remaining Windows/macOS conditionals
   - Optimize for Ubuntu/Debian dependencies
   - Add Qt Quick/QML modules

5. **Clean up build scripts**
   - Keep only Linux-related CI scripts in `.ci-scripts/`
   - Remove or mark deprecated: AppImage, Flatpak builders (if modernizing packaging)

---

## Phase 2: Modern UI Architecture Design

### Qt Quick/QML Migration Strategy

#### 2.1 Architecture Overview
```
qTox/
├── src/
│   ├── core/           # Keep existing (Tox protocol, no changes)
│   ├── model/          # Keep existing (data models)
│   ├── persistence/    # Keep existing (database, settings)
│   ├── net/            # Keep existing (network layer)
│   ├── audio/          # Keep existing (audio handling)
│   ├── video/          # Keep existing (video handling)
│   ├── qml/            # NEW: QML UI components
│   │   ├── main.qml
│   │   ├── components/
│   │   │   ├── ModernButton.qml
│   │   │   ├── MessageBubble.qml
│   │   │   ├── ContactListItem.qml
│   │   │   ├── ChatInput.qml
│   │   │   └── ...
│   │   ├── pages/
│   │   │   ├── ChatPage.qml
│   │   │   ├── ContactsPage.qml
│   │   │   ├── SettingsPage.qml
│   │   │   └── ProfilePage.qml
│   │   ├── dialogs/
│   │   │   ├── AddFriendDialog.qml
│   │   │   ├── FileTransferDialog.qml
│   │   │   └── ...
│   │   └── themes/
│   │       ├── Theme.qml
│   │       ├── LightTheme.qml
│   │       └── DarkTheme.qml
│   └── ui/             # NEW: C++ UI controllers/bridges
│       ├── ChatController.h/cpp
│       ├── ContactsController.h/cpp
│       ├── SettingsController.h/cpp
│       └── ThemeManager.h/cpp
```

#### 2.2 Key Design Principles
- **Separation of Concerns**: Core logic stays in C++, UI in QML
- **Modern Aesthetics**: Rounded corners, subtle shadows, smooth animations
- **Responsive**: Adapts to window size and HiDPI displays
- **Accessible**: Proper contrast ratios, keyboard navigation
- **Ubuntu Native**: Respects system theme (light/dark mode)

---

## Phase 3: Component Library Creation

### 3.1 Base Theme System
Create `src/qml/themes/Theme.qml`:
```qml
pragma Singleton
import QtQuick

QtObject {
    // Colors
    property color backgroundColor: isDark ? "#1e1e1e" : "#ffffff"
    property color surfaceColor: isDark ? "#2d2d2d" : "#f5f5f5"
    property color primaryColor: "#5DADE2"  // qTox blue
    property color accentColor: "#27AE60"   // Online green
    property color textColor: isDark ? "#e0e0e0" : "#2c3e50"
    property color secondaryTextColor: isDark ? "#b0b0b0" : "#7f8c8d"
    
    // Dimensions
    property int borderRadius: 12
    property int smallRadius: 6
    property int spacing: 16
    property int smallSpacing: 8
    
    // Typography
    property int titleSize: 24
    property int headerSize: 18
    property int bodySize: 14
    property int captionSize: 12
    
    // Animations
    property int animationDuration: 200
    property int fastDuration: 100
    property int slowDuration: 300
    
    // State
    property bool isDark: false  // Sync with system theme
}
```

### 3.2 Core Components

#### ModernButton.qml
- Rounded corners
- Smooth hover/press states
- Ripple effect on click
- Configurable colors and sizes

#### MessageBubble.qml
- Different styles for sent/received messages
- Smooth fade-in animation
- Timestamp display
- Read receipts
- File attachment preview

#### ContactListItem.qml
- Avatar with online status indicator
- Last message preview
- Unread count badge
- Smooth selection animation
- Context menu support

#### ChatInput.qml
- Multi-line text input with auto-grow
- Emoji picker integration
- File attachment button
- Send button with animation
- Typing indicator

---

## Phase 4: Main UI Implementation

### 4.1 Main Window Structure
```qml
// main.qml
ApplicationWindow {
    id: mainWindow
    width: 1200
    height: 800
    visible: true
    title: "qTox"
    
    // Main layout: Sidebar | Chat Area
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Left sidebar
        Sidebar {
            Layout.fillHeight: true
            Layout.preferredWidth: 300
        }
        
        // Main content area
        StackView {
            id: contentStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Smooth page transitions
            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0; to: 1
                    duration: Theme.animationDuration
                }
            }
        }
    }
}
```

### 4.2 Chat Interface
- Message list with smooth scrolling
- Virtual scrolling for performance
- Message grouping by sender/time
- Typing indicators
- File transfer progress
- Emoji reactions (future)

### 4.3 Contact List
- Search/filter functionality
- Grouped by online status
- Circle/group support
- Drag-and-drop to organize
- Context menu actions

---

## Phase 5: Settings & Dialogs

### 5.1 Settings UI
- Modern card-based layout
- Searchable settings
- Live preview of changes
- Organized categories:
  - General
  - Privacy & Security
  - Audio & Video
  - Appearance
  - Advanced

### 5.2 Modern Dialogs
- Add Friend Dialog
- File Transfer Dialog
- Profile Editor
- About Dialog
- All with smooth fade/scale animations

---

## Phase 6: Animations & Polish

### 6.1 Animation Checklist
- [ ] Page transitions (slide/fade)
- [ ] Message send animation
- [ ] Message receive animation
- [ ] Notification pop-ups
- [ ] Button hover/press states
- [ ] List item selection
- [ ] Modal dialog show/hide
- [ ] Theme switching transition
- [ ] Typing indicator pulse
- [ ] Online status changes

### 6.2 Performance Optimizations
- Use `ListView` caching
- Implement virtual scrolling for large chat histories
- Lazy load images/avatars
- Throttle animations on low-end hardware
- Profile with QML Profiler

---

## Phase 7: Ubuntu Integration

### 7.1 System Theme Detection
```cpp
// ThemeManager.cpp
bool ThemeManager::isSystemDark() {
    // Read Ubuntu's GTK theme preference
    QSettings settings("org.gnome.desktop.interface", "color-scheme");
    QString scheme = settings.value("color-scheme", "default").toString();
    return scheme.contains("dark");
}
```

### 7.2 Native Features
- [ ] System tray integration (already exists, verify modern look)
- [ ] Desktop notifications (native Ubuntu/GNOME style)
- [ ] Media key integration
- [ ] HiDPI scaling support
- [ ] Wayland compatibility

---

## Phase 8: Testing & Validation

### 8.1 Functional Testing
- [ ] All features work with new UI
- [ ] Chat sending/receiving
- [ ] File transfers
- [ ] Audio/video calls
- [ ] Group chats
- [ ] Profile management

### 8.2 Visual Testing
- [ ] Consistency across all screens
- [ ] Animations are smooth (60 FPS)
- [ ] Proper scaling on different resolutions
- [ ] Light/dark theme switching
- [ ] No visual glitches

### 8.3 Performance Testing
- [ ] Startup time < 2 seconds
- [ ] Smooth scrolling with 10,000+ messages
- [ ] Low memory footprint
- [ ] Responsive UI during file transfers

---

## Implementation Timeline

### Week 1-2: Platform Cleanup
- Complete removal of all non-Linux code
- CMake refactoring
- Build system optimization

### Week 3-4: QML Infrastructure
- Set up Qt Quick modules
- Create theme system
- Build core component library
- Design system documentation

### Week 5-6: Main UI Implementation
- Implement chat interface
- Create contact list
- Build main window layout
- Wire up C++ controllers

### Week 7-8: Settings & Dialogs
- Redesign all settings pages
- Create modern dialogs
- Implement search functionality

### Week 9-10: Animations & Polish
- Add all animations
- Fine-tune transitions
- Performance optimization
- Bug fixes

### Week 11-12: Integration & Testing
- Ubuntu theme integration
- Comprehensive testing
- Documentation updates
- Final polish

---

## Technical Notes

### Dependencies to Add
```cmake
# In CMakeLists.txt
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Widgets  # Keep for now during migration
    Quick
    QuickControls2
    Svg
    Multimedia
)
```

### Migration Strategy
1. **Hybrid Approach**: Keep Qt Widgets initially, gradually replace with QML
2. **QQuickWidget**: Embed QML views within existing Qt Widgets windows
3. **Incremental**: Start with one screen (e.g., chat), then expand

### Code Style
- QML: Follow Qt QML coding conventions
- C++: Keep existing qTox style
- Comments: Document all QML components
- TypeScript-style property declarations in QML

---

## Success Criteria

✅ Application runs exclusively on Ubuntu Linux
✅ Modern, Signal/Telegram-inspired UI
✅ Smooth 60 FPS animations throughout
✅ Respects Ubuntu system theme (light/dark)
✅ All original features still functional
✅ Clean, maintainable codebase
✅ HiDPI display support
✅ Performance equal to or better than current version

---

## Notes & Considerations

- **Backwards Compatibility**: Not a goal - this is Ubuntu-only
- **Windows/macOS Users**: Direct them to TokTok fork
- **Packaging**: Consider Snap/AppImage for easy Ubuntu distribution
- **Future**: Could inspire similar modernization in TokTok fork

---

**Last Updated**: October 15, 2025
**Status**: Phase 1 - Platform Cleanup In Progress
