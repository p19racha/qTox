/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 qTox Ubuntu Modernization Project
 */

/**
 * @file qml_preview.cpp
 * @brief Standalone QML UI preview application
 * 
 * This is a simple application to preview and test the modern QML UI
 * without requiring the full qTox backend. Useful for UI development
 * and testing.
 * 
 * To build and run:
 *   mkdir build && cd build
 *   cmake .. -DBUILD_QML_PREVIEW=ON
 *   make qml_preview
 *   ./qml_preview
 */

#include "src/ui/thememanager.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QDebug>
#include <QIcon>

int main(int argc, char *argv[])
{
    // Set up application
    QGuiApplication app(argc, argv);
    app.setApplicationName("qTox Modern UI Preview");
    app.setOrganizationName("qTox");
    app.setOrganizationDomain("qtox.github.io");
    
    // Use the modern Qt Quick Controls style
    QQuickStyle::setStyle("Basic");
    
    // Create QML engine
    QQmlApplicationEngine engine;
    
    // Create and register theme manager
    ThemeManager themeManager;
    themeManager.loadThemePreference();
    
    // Make theme manager available to QML
    engine.rootContext()->setContextProperty("themeManager", &themeManager);
    
    // Set import paths
    engine.addImportPath(":/qml");
    engine.addImportPath("qrc:/qml");
    
    qDebug() << "QML Import paths:" << engine.importPathList();
    
    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qCritical() << "Failed to load QML file!";
            QCoreApplication::exit(-1);
        } else {
            qDebug() << "QML loaded successfully";
        }
    }, Qt::QueuedConnection);
    
    // Handle QML warnings
    QObject::connect(&engine, &QQmlApplicationEngine::warnings,
                     [](const QList<QQmlError> &warnings) {
        for (const auto &warning : warnings) {
            qWarning() << "QML Warning:" << warning.toString();
        }
    });
    
    engine.load(url);
    
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects created!";
        return -1;
    }
    
    qDebug() << "qTox Modern UI Preview started successfully";
    qDebug() << "Press Ctrl+T to toggle theme";
    qDebug() << "Current theme:" << (themeManager.isDark() ? "Dark" : "Light");
    
    return app.exec();
}
