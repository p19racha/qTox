# qTox Premium UI - Integration Guide

## Overview
This document describes the complete integration of the new QML-based Premium UI with the existing qTox C++ backend.

## Architecture

### Components Created

#### 1. QML Frontend (`src/qml/`)
- **PremiumMainWindow.qml** - Main application window with sidebar and navigation
- **premium_chat.qml** - Chat interface (already working standalone)
- **screens/**
  - PremiumAddFriend.qml - Add friend screen
  - PremiumProfile.qml - User profile management
  - PremiumSettings.qml - Application settings
  - PremiumRequests.qml - Friend requests (placeholder)
  - PremiumGroups.qml - Group chats (placeholder)

#### 2. C++ Bridge Layer (`src/qml/`)
- **QmlBridge.h/cpp** - Main bridge class exposing backend to QML
  - Properties: username, statusMessage, userStatus, selfToxId, friendListModel, isConnected
  - Methods: sendMessage, addFriend, removeFriend, acceptFriendRequest, etc.
  - Signals: friendMessageReceived, friendStatusChanged, etc.

- **FriendListModel.h/cpp** - QAbstractListModel for friend list
  - Exposes friend data to QML ListView
  - Roles: friendName, status, statusMessage, avatar, publicKey, unreadCount, isOnline, isTyping

- **PremiumUILauncher.h/cpp** - Main launcher class
  - Initializes QQmlApplicationEngine
  - Creates QmlBridge and connects to Core
  - Manages QML window lifecycle

#### 3. Components (Already Created)
- **PremiumTheme.qml** - Dark theme color system
- **PremiumMessageBubble.qml** - Message display
- **PremiumContactCard.qml** - Friend list items
- **PremiumShadow.qml** - Shadow effects

## Integration Steps

### Step 1: Add QML Module to Main CMakeLists.txt

```cmake
# In src/CMakeLists.txt, add:
add_subdirectory(qml)

# Link the QML module to qtox executable:
target_link_libraries(${PROJECT_NAME}
    PRIVATE
    qtox_qml  # Add this line
    # ... other libraries
)
```

### Step 2: Modify Nexus to Support QML UI

In `src/nexus.h`, add:
```cpp
#include "qml/PremiumUILauncher.h"

class Nexus : public QObject {
    // ... existing code ...
private:
    std::unique_ptr<PremiumUILauncher> premiumUI;  // Add this
};
```

In `src/nexus.cpp`, in `showMainGUI()`:
```cpp
void Nexus::showMainGUI()
{
    assert(profile);

    // Option 1: Always use Premium UI
    if (!premiumUI) {
        premiumUI = std::make_unique<PremiumUILauncher>(
            *profile, settings, *audioControl, 
            cameraSource, *style, messageBoxManager
        );
        if (!premiumUI->initialize()) {
            qCritical() << "Failed to initialize Premium UI";
            return;
        }
    }
    premiumUI->show();

    // Option 2: Toggle between old and new UI via settings
    bool usePremiumUI = settings.getEnablePremiumUI();  // Add this setting
    if (usePremiumUI) {
        // Use Premium QML UI
        if (!premiumUI) {
            premiumUI = std::make_unique<PremiumUILauncher>(...);
            premiumUI->initialize();
        }
        premiumUI->show();
    } else {
        // Use old Widget UI
        if (!widget) {
            widget = std::make_unique<Widget>(*profile, *audioControl, 
                                             cameraSource, settings, *style, 
                                             ipc, *this);
        }
        widget->init();
        widget->show();
    }
}
```

### Step 3: Update Settings

Add to `src/persistence/settings.h`:
```cpp
DECLARE_SETTING(bool, EnablePremiumUI, false)
```

This allows users to toggle between old and new UI.

### Step 4: Connect Backend Signals

The QmlBridge already connects to Core signals in its constructor:
```cpp
connect(core, &Core::friendMessageReceived, this, &QmlBridge::onFriendMessageReceived);
connect(core, &Core::friendRequestReceived, this, &QmlBridge::onFriendRequestReceived);
// etc.
```

Additional connections needed (add to QmlBridge constructor):
```cpp
// Friend status changes
connect(core, &Core::friendStatusChanged, this, 
        [this](uint32_t friendId, Status::Status status) {
    onFriendStatusChanged(friendId, status);
    if (friendListModel) {
        friendListModel->onFriendStatusChanged(
            core->getFriendPublicKey(friendId), status);
    }
});

// Connection status
connect(core, &Core::connected, this, [this]() {
    onConnectionStatusChanged(true);
});
connect(core, &Core::disconnected, this, [this]() {
    onConnectionStatusChanged(false);
});

// Friend list updates
connect(core, &Core::friendAdded, this, [this](uint32_t friendId) {
    Friend* f = friendList.findFriend(core->getFriendPublicKey(friendId));
    if (f && friendListModel) {
        friendListModel->onFriendAdded(f);
    }
});
```

### Step 5: Implement Message Sending

The QmlBridge::sendMessage() currently has a TODO. Integrate with chatlog:

```cpp
void QmlBridge::sendMessage(const QString& friendPk, const QString& message)
{
    if (!core || message.isEmpty())
        return;
        
    Friend* f = friendList.findFriend(stringToToxPk(friendPk));
    if (!f)
        return;
    
    // Get friend's message dispatcher
    auto* chatForm = f->getChatForm();  // May need to create accessor
    if (chatForm) {
        chatForm->sendMessage(message);
    }
}
```

### Step 6: Resource File

Create `src/qml/qml.qrc`:
```xml
<RCC>
    <qresource prefix="/qml">
        <file>PremiumMainWindow.qml</file>
        <file>premium_chat.qml</file>
        <file>screens/PremiumAddFriend.qml</file>
        <file>screens/PremiumProfile.qml</file>
        <file>screens/PremiumSettings.qml</file>
        <file>screens/PremiumRequests.qml</file>
        <file>screens/PremiumGroups.qml</file>
        <file>themes/PremiumTheme.qml</file>
        <file>components/premium/PremiumMessageBubble.qml</file>
        <file>components/premium/PremiumContactCard.qml</file>
        <file>components/premium/PremiumShadow.qml</file>
    </qresource>
</RCC>
```

## Building

```bash
cd /home/racha/qTox
mkdir -p build-full
cd build-full

cmake .. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBUILD_QML_UI=ON

make -j$(nproc)
./qtox
```

## Testing

### Phase 1: Standalone Testing
The premium UI can be tested standalone:
```bash
cd build-preview
./premium_preview
```

### Phase 2: Integrated Testing
Once integrated:
1. Launch qtox normally
2. If settings enabled, Premium UI appears
3. Test features:
   - Friend list loads from backend
   - Can add friends via Tox ID
   - Chat interface works
   - Profile updates sync
   - Settings persist

## Current Status

✅ **Completed:**
- Full QML UI created (1000+ lines)
- Dark theme system
- C++ bridge architecture
- Friend list model
- All main screens designed
- Standalone preview working

🔄 **In Progress:**
- CMakeLists.txt integration
- Nexus modification
- Backend signal connections
- Message sending implementation

⏳ **TODO:**
- Chat history loading
- Group chat support
- Friend request handling
- Audio/Video call UI
- File transfer UI
- Notifications
- System tray integration

## Architecture Diagram

```
┌─────────────────────────────────────────┐
│         QML Frontend (Qt Quick)         │
│  ┌───────────────────────────────────┐  │
│  │  PremiumMainWindow.qml            │  │
│  │  ├─ Sidebar (Friend List)         │  │
│  │  ├─ premium_chat.qml              │  │
│  │  ├─ PremiumProfile.qml            │  │
│  │  └─ PremiumSettings.qml           │  │
│  └───────────────────────────────────┘  │
│                 ▲                        │
│                 │ QML Properties &       │
│                 │ Signal/Slots           │
│                 ▼                        │
│  ┌───────────────────────────────────┐  │
│  │        QmlBridge (C++)            │  │
│  │  ├─ Properties (username, etc.)   │  │
│  │  ├─ Methods (sendMessage, etc.)   │  │
│  │  └─ Signals (friendAdded, etc.)   │  │
│  └───────────────────────────────────┘  │
│                 ▲                        │
└─────────────────┼────────────────────────┘
                  │
┌─────────────────┼────────────────────────┐
│      C++ Backend (Existing qTox)        │
│  ┌───────────────────────────────────┐  │
│  │  Core                             │  │
│  │  ├─ Tox Protocol                  │  │
│  │  ├─ Network                       │  │
│  │  └─ Encryption                    │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  FriendList / GroupList           │  │
│  └───────────────────────────────────┘  │
│  ┌───────────────────────────────────┐  │
│  │  Settings / Profile / Persistence │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Benefits of This Architecture

1. **Separation of Concerns**: UI and backend are cleanly separated
2. **Modern UI**: Beautiful, responsive QML interface
3. **Maintainability**: Easy to update UI without touching core logic
4. **Flexibility**: Can switch between old and new UI
5. **Performance**: QML's scene graph provides smooth animations
6. **Future-Proof**: Qt Quick is the future of Qt UI development

## Next Steps

1. **Immediate**: Complete CMakeLists.txt integration
2. **Short-term**: Connect all backend signals to QML
3. **Medium-term**: Implement missing features (groups, calls, etc.)
4. **Long-term**: Deprecate old Widget-based UI

## Troubleshooting

### QML Module Not Found
- Ensure `qt_add_qml_module` is configured correctly
- Check QML import paths in PremiumUILauncher
- Verify qml.qrc is included in build

### Bridge Not Accessible from QML
- Check context property name matches QML usage
- Ensure QmlBridge is set before loading QML
- Verify Q_PROPERTY macros are correct

### Friend List Not Updating
- Check Core signal connections in QmlBridge
- Verify FriendListModel emits dataChanged
- Ensure model is refreshed on friend add/remove

## Contact

For questions about this integration, refer to:
- `src/qml/QmlBridge.h` - Main bridge interface
- `src/qml/PremiumUILauncher.h` - UI launcher
- `DARK_MODE_ONLY.md` - Theme documentation
