/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 qTox Ubuntu Modernization Project
 */

/**
 * @file settings_preview.cpp
 * @brief Standalone application to preview the Settings page
 * 
 * This allows rapid development and testing of the Settings UI
 * without needing to build the full qTox application.
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>

#include "src/ui/thememanager.h"

int main(int argc, char *argv[])
{
    // Enable high DPI scaling
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    
    QGuiApplication app(argc, argv);
    
    // Set application metadata
    app.setOrganizationName("qTox");
    app.setOrganizationDomain("qtox.github.io");
    app.setApplicationName("qTox Settings Preview");
    app.setApplicationVersion("2.0.0-dev");
    
    // Create theme manager
    ThemeManager themeManager;
    
    // Create QML engine
    QQmlApplicationEngine engine;
    
    // Add QML import path
    engine.addImportPath("qrc:/qml");
    
    // Expose theme manager to QML
    engine.rootContext()->setContextProperty("themeManager", &themeManager);
    
    // Debug: Print QML import paths
    qDebug() << "QML Import paths:" << engine.importPathList();
    
    // Load the settings demo QML
    const QUrl url(QStringLiteral("qrc:/qml/settings_demo.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qCritical() << "Failed to load QML!";
            QCoreApplication::exit(-1);
        } else {
            qInfo() << "qTox Settings Preview started successfully";
            qInfo() << "Press Ctrl+Q or Ctrl+W to quit";
            qInfo() << "Current theme:" << (obj ? "Loaded" : "Not loaded");
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects created!";
        return -1;
    }
    
    qInfo() << "QML loaded successfully";
    
    return app.exec();
}
