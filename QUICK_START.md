# qTox Premium UI - Quick Integration Guide

## 🚀 5-Minute Integration

### Step 1: Update Main CMakeLists.txt

Edit `/home/racha/qTox/src/CMakeLists.txt` and add:

```cmake
# Add this line after other subdirectories
add_subdirectory(qml)

# In target_link_libraries for ${PROJECT_NAME}, add:
target_link_libraries(${PROJECT_NAME}
    PRIVATE
    # ... existing libraries ...
    qtox_qml  # ADD THIS LINE
)
```

### Step 2: Modify Nexus

Edit `/home/racha/qTox/src/nexus.h`:

```cpp
#pragma once

#include "qml/PremiumUILauncher.h"  // ADD THIS

class Nexus : public QObject {
    // ... existing code ...
private:
    std::unique_ptr<PremiumUILauncher> premiumUI;  // ADD THIS
    std::unique_ptr<Widget> widget;
};
```

Edit `/home/racha/qTox/src/nexus.cpp` in `showMainGUI()`:

```cpp
void Nexus::showMainGUI()
{
    assert(profile);

    // NEW: Use Premium UI instead of old Widget
    if (!premiumUI) {
        premiumUI = std::make_unique<PremiumUILauncher>(
            *profile, 
            settings, 
            *audioControl,
            cameraSource, 
            *style, 
            messageBoxManager
        );
        
        if (!premiumUI->initialize()) {
            qCritical() << "Failed to initialize Premium UI";
            // Fall back to old widget
            if (!widget) {
                widget = std::make_unique<Widget>(
                    *profile, *audioControl, cameraSource,
                    settings, *style, ipc, *this
                );
            }
            widget->init();
            widget->show();
            return;
        }
    }
    
    premiumUI->show();
}
```

### Step 3: Build

```bash
cd /home/racha/qTox
mkdir -p build-full
cd build-full

cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)
```

### Step 4: Run

```bash
./qtox
```

## ✅ What You Get

- ✅ Modern Telegram-style interface
- ✅ Friend list from backend
- ✅ User profile loaded
- ✅ Settings interface
- ✅ Add friend functionality
- ✅ Dark theme throughout

## 🐛 Troubleshooting

### Build Error: "Cannot find qtox_qml"
- Make sure `add_subdirectory(qml)` is in src/CMakeLists.txt
- Verify /home/racha/qTox/src/qml/CMakeLists.txt exists
- Run `cmake ..` again

### Runtime Error: "Cannot load PremiumMainWindow.qml"
- Check qml.qrc includes all QML files
- Verify Qt Quick is installed: `qt6-quick`
- Check engine->rootObjects() is not empty

### Friend List Empty
- QmlBridge needs to be connected to Core signals
- Check FriendList* is properly obtained from profile
- Verify Core* is not null

### UI Not Showing
- Check PremiumUILauncher::show() is called
- Verify QML window visibility
- Look for QML errors in console output

## 📚 Full Documentation

- **Complete Guide**: `PREMIUM_UI_INTEGRATION.md`
- **Theme Details**: `DARK_MODE_ONLY.md`
- **Project Summary**: `PREMIUM_UI_SUMMARY.md`

## 🎨 Preview Without Integration

Want to see it first?

```bash
cd /home/racha/qTox/build-preview
./premium_preview
```

Press Ctrl+Q to quit.

## 🔄 Rollback to Old UI

If you need to revert, just comment out the Premium UI code and use the old Widget:

```cpp
void Nexus::showMainGUI()
{
    // if (!premiumUI) { ... }  // Comment this out
    
    if (!widget) {
        widget = std::make_unique<Widget>(...);
    }
    widget->init();
    widget->show();
}
```

## 🎯 What's Next

After integration, you'll want to:

1. **Connect message sending** - Implement QmlBridge::sendMessage() with IChatLog
2. **Load chat history** - Integrate with persistence layer
3. **Handle friend requests** - Connect accept/reject actions
4. **Add groups** - Implement group chat UI and backend
5. **File transfers** - Create UI and connect to CoreFile

All the UI is ready - just needs backend wiring!

---

**Estimated Integration Time**: 15-30 minutes

**Difficulty**: Easy (mostly adding a few lines to existing files)

**Risk**: Low (can easily rollback)
