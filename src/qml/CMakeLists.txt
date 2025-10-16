# qTox Premium QML UI - CMake Build Configuration

cmake_minimum_required(VERSION 3.16)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Qml)

# QML Module for Premium UI
qt_add_qml_module(qtox_qml
    URI qTox.Premium
    VERSION 1.0
    QML_FILES
        # Main Application
        PremiumMainWindow.qml
        premium_chat.qml
        
        # Screens
        screens/PremiumAddFriend.qml
        screens/PremiumProfile.qml
        screens/PremiumSettings.qml
        screens/PremiumRequests.qml
        screens/PremiumGroups.qml
        
        # Components
        components/premium/PremiumMessageBubble.qml
        components/premium/PremiumContactCard.qml
        components/premium/PremiumShadow.qml
        
        # Themes
        themes/PremiumTheme.qml
        
    SOURCES
        # C++ Bridge Classes
        QmlBridge.h
        QmlBridge.cpp
        models/FriendListModel.h
        models/FriendListModel.cpp
        
    RESOURCES
        qml.qrc
)

# Link required Qt libraries
target_link_libraries(qtox_qml PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)

# Export for use in main application
target_include_directories(qtox_qml PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
