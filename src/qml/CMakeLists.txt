# qTox Premium QML UI - CMake Build Configuration

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Qml Widgets Network)

# Create the QML library with C++ sources
add_library(qtox_qml STATIC
    QmlBridge.h
    QmlBridge.cpp
    models/FriendListModel.h
    models/FriendListModel.cpp
    PremiumUILauncher.h
    PremiumUILauncher.cpp
)

# Add QML resources
target_sources(qtox_qml PRIVATE
    qml.qrc
)

# Enable Qt features
set_target_properties(qtox_qml PROPERTIES
    AUTOMOC ON
    AUTORCC ON
)

# Link required Qt libraries
target_link_libraries(qtox_qml PUBLIC
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
    Qt6::Widgets
    Qt6::Network
)

# Export for use in main application - include parent directories
target_include_directories(qtox_qml PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/util/include
    ${CMAKE_SOURCE_DIR}/audio/include
)
