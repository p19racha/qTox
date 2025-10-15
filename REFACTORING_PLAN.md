# qTox Ubuntu-Only Modernization Project

**Status:** Planning Phase  
**Started:** October 16, 2025  
**Target:** Modern Ubuntu-exclusive messaging client with Qt Quick UI

---

## 🎯 Project Goals

1. **Platform Simplification**: Remove all Windows/macOS/BSD/WASM code
2. **UI Modernization**: Replace Qt Widgets with Qt Quick/QML
3. **Ubuntu Integration**: Native Ubuntu theming and HiDPI support
4. **Architecture Cleanup**: Clean C++/QML separation, reduce singletons

---

## 📊 Phase 1: Platform Cleanup (Ubuntu-Only)

### Files/Directories to Remove:
```
platform/windows/          # Windows-specific build configs
platform/macos/           # macOS-specific build configs  
platform/wasm/            # WebAssembly port
platform/android/         # Android port
platform/flatpak/         # Keep for Ubuntu packaging
platform/linux/           # Review and integrate needed parts

src/platform/autorun_win.cpp
src/platform/autorun_osx.cpp
src/platform/capslock_win.cpp
src/platform/capslock_osx.cpp
src/platform/timer_win.cpp
src/platform/timer_osx.cpp
src/platform/camera/directshow.cpp  # Windows DirectShow
src/platform/camera/directshow.h
src/platform/camera/avfoundation.mm  # macOS AVFoundation
src/platform/camera/avfoundation.h
```

### Files to Keep (Linux-specific):
```
src/platform/autorun_xdg.cpp      # XDG autorun (Linux standard)
src/platform/capslock_x11.cpp     # X11 caps lock detection
src/platform/timer_x11.cpp        # X11 timer
src/platform/screenshot_dbus.cpp  # DBus screenshots (Linux)
src/platform/desktop_notifications/desktopnotifybackend_dbus.cpp
src/platform/camera/v4l2.cpp      # Video4Linux2 (Linux camera API)
src/platform/x11_display.cpp      # X11 display handling
src/platform/posixsignalnotifier.cpp
src/platform/stacktrace.cpp
```

### CMakeLists.txt Changes:
- Remove `WIN32` and `MACOSX_BUNDLE` flags from `qt_add_executable`
- Remove MINGW, APPLE, FreeBSD conditionals
- Simplify to Linux-only dependencies
- Remove Windows resource compilation
- Keep only Linux-specific compiler flags

### Platform Extensions:
- Remove `PLATFORM_EXTENSIONS` option (always on for Linux features)
- Simplify `QTOX_PLATFORM_EXT` to always be defined

---

## 📊 Phase 2: UI/UX Modernization (Qt Quick/QML)

### Design Principles:
1. **Modern & Minimal**: Clean UI inspired by Signal/Telegram
2. **Smooth Animations**: 200-300ms transitions with easing curves
3. **Responsive**: Adaptive layouts for different window sizes
4. **Themed**: Auto-detect Ubuntu light/dark theme
5. **HiDPI**: Perfect scaling on high-resolution displays

### New UI Architecture:

```
qml/
├── main.qml                    # Application entry point
├── theme/
│   ├── Theme.qml              # Central theme configuration
│   ├── Colors.qml             # Color palette (light/dark)
│   ├── Typography.qml         # Font styles
│   └── Animations.qml         # Animation presets
├── components/
│   ├── ModernButton.qml       # Custom button with hover/press states
│   ├── ModernTextField.qml    # Input fields
│   ├── ModernListView.qml     # Smooth scrolling lists
│   ├── ModernDialog.qml       # Modal dialogs
│   ├── Avatar.qml             # User avatars
│   ├── MessageBubble.qml      # Chat message bubbles
│   └── Sidebar.qml            # Navigation sidebar
├── views/
│   ├── MainWindow.qml         # Main application window
│   ├── ChatView.qml           # Chat interface
│   ├── ConversationList.qml   # Contact/group list
│   ├── SettingsView.qml       # Settings panels
│   └── ProfileView.qml        # User profile
└── animations/
    ├── FadeTransition.qml
    ├── SlideTransition.qml
    └── ScaleTransition.qml
```

### C++ Bridge Layer:

```cpp
// New model classes for QML binding
src/ui/models/
├── ChatListModel.h/cpp        # QAbstractListModel for chats
├── MessageListModel.h/cpp     # Messages in a conversation
├── ContactListModel.h/cpp     # Friend/contact list
└── SettingsModel.h/cpp        # Settings with Q_PROPERTY

// QML registration
src/ui/qmlengine.h/cpp         # QML engine setup and type registration

// View models (C++ controllers for QML)
src/ui/viewmodels/
├── MainViewModel.h/cpp
├── ChatViewModel.h/cpp
└── SettingsViewModel.h/cpp
```

### Migration Strategy:

**Incremental Approach:**
1. Keep existing Qt Widgets code functional
2. Build new QML UI alongside
3. Create C++/QML bridge layer
4. Switch main entry point to QML
5. Remove old Qt Widgets code

**OR**

**Big Bang Approach:**
1. Remove all Qt Widgets UI code at once
2. Build complete QML replacement
3. Test thoroughly before commit

**Recommendation:** Incremental to reduce risk

---

## 📊 Phase 3: Architecture Cleanup

### Singleton Reduction:
```cpp
// Current (singletons everywhere):
Settings::getInstance()
Style::getInstance()
Widget::getInstance()

// Target (dependency injection):
class MainWindow {
    Settings& settings;
    StyleManager& styleManager;
public:
    MainWindow(Settings& s, StyleManager& sm) 
        : settings(s), styleManager(sm) {}
};
```

### Separation of Concerns:
```
Core/Model Layer (C++)         UI Layer (QML)
├── Core (Tox protocol)   ←→   QML Views
├── Persistence           ←→   View Models (C++)
├── Model                 ←→   List Models (C++)
└── Network              ←→   Q_PROPERTY bindings
```

### Testing Strategy:
- Unit tests for models (no UI dependency)
- QML test cases for UI components
- Integration tests for C++/QML bridge

---

## 🎨 Visual Design Specifications

### Color Palette (Ubuntu Light):
```qml
backgroundColor: "#FFFFFF"
surfaceColor: "#F5F5F5"
primaryColor: "#E95420"      // Ubuntu orange
textPrimary: "#2D2D2D"
textSecondary: "#5E5E5E"
borderColor: "#DDDDDD"
accentColor: "#19B6EE"       // Ubuntu blue
```

### Color Palette (Ubuntu Dark):
```qml
backgroundColor: "#2D2D2D"
surfaceColor: "#3D3D3D"
primaryColor: "#E95420"
textPrimary: "#F5F5F5"
textSecondary: "#AAAAAA"
borderColor: "#555555"
accentColor: "#19B6EE"
```

### Typography:
```qml
fontFamily: "Ubuntu"          // System default
h1: 24px, Medium
h2: 20px, Medium
h3: 16px, Medium
body: 14px, Regular
caption: 12px, Regular
```

### Spacing:
```qml
spacing_xs: 4px
spacing_sm: 8px
spacing_md: 16px
spacing_lg: 24px
spacing_xl: 32px
```

### Border Radius:
```qml
radius_sm: 4px    // Buttons, inputs
radius_md: 8px    // Cards, dialogs
radius_lg: 12px   // Message bubbles
radius_full: 999px // Avatars, badges
```

### Animations:
```qml
duration_fast: 150ms
duration_normal: 250ms
duration_slow: 350ms
easing: Easing.OutCubic
```

---

## 📋 Implementation Checklist

### Phase 1: Platform Cleanup
- [ ] Remove Windows/macOS platform directories
- [ ] Remove Windows/macOS source files
- [ ] Simplify CMakeLists.txt for Linux-only
- [ ] Remove platform abstraction conditionals
- [ ] Update build documentation
- [ ] Test clean build on Ubuntu

### Phase 2: UI Modernization
- [ ] Set up QML project structure
- [ ] Create theme system (Colors, Typography, Animations)
- [ ] Build component library (20+ components)
- [ ] Implement C++ models for QML
- [ ] Create main window layout
- [ ] Implement chat interface
- [ ] Rebuild settings UI
- [ ] Add Ubuntu theme detection
- [ ] Implement smooth transitions
- [ ] Test on HiDPI displays

### Phase 3: Architecture
- [ ] Create C++/QML bridge layer
- [ ] Reduce singleton usage
- [ ] Separate UI from business logic
- [ ] Add unit tests for models
- [ ] Add QML component tests
- [ ] Performance profiling

### Documentation
- [ ] Update README.md (Ubuntu-only focus)
- [ ] Update INSTALL.md (Linux build only)
- [ ] Update CONTRIBUTING.md (QML guidelines)
- [ ] Create UI_GUIDELINES.md
- [ ] Update screenshots

---

## ⚠️ Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaking existing users | High | Clear communication, version bump to 2.0 |
| Qt Quick performance | Medium | Profile early, optimize rendering |
| QML/C++ bugs | Medium | Incremental migration, thorough testing |
| Development time | High | Phased approach, automated testing |
| Loss of features | Medium | Feature parity checklist before deletion |

---

## 📅 Estimated Timeline

- **Phase 1 (Platform Cleanup)**: 1-2 weeks
- **Phase 2 (UI Modernization)**: 8-12 weeks
- **Phase 3 (Architecture)**: 4-6 weeks
- **Testing & Polish**: 4-6 weeks

**Total**: 4-6 months for complete transformation

---

## 🚀 Quick Start (Development)

### Prerequisites:
```bash
sudo apt update
sudo apt install qt6-base-dev qt6-declarative-dev qt6-multimedia-dev \
    libqt6svg6-dev cmake build-essential pkg-config
```

### Build (After refactoring):
```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

---

## 📝 Notes

- This is a **breaking change** - version should be 2.0.0
- Ubuntu 22.04 LTS or newer required
- Qt 6.5+ required for best QML performance
- Wayland support should be primary (X11 fallback)
