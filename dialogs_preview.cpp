/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2025 qTox Ubuntu Modernization Project
 */

/**
 * @file dialogs_preview.cpp
 * @brief Standalone application to preview modern dialog components
 */

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "src/ui/thememanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    // Set application metadata
    app.setOrganizationName("qTox");
    app.setApplicationName("qTox Dialogs Preview");
    app.setApplicationVersion("2.0.0-dev");
    
    // Create theme manager
    ThemeManager themeManager;
    
    // Create QML engine
    QQmlApplicationEngine engine;
    
    // Add QML import path
    engine.addImportPath("qrc:/qml");
    
    // Expose theme manager to QML
    engine.rootContext()->setContextProperty("themeManager", &themeManager);
    
    // Load the dialogs demo QML
    const QUrl url(QStringLiteral("qrc:/qml/dialogs_demo.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qCritical() << "Failed to load QML!";
            QCoreApplication::exit(-1);
        } else {
            qInfo() << "qTox Dialogs Preview started successfully";
            qInfo() << "Keyboard shortcuts:";
            qInfo() << "  Ctrl+1: Add Friend Dialog";
            qInfo() << "  Ctrl+2: File Transfer Dialog";
            qInfo() << "  Ctrl+3: Destructive Confirm";
            qInfo() << "  Ctrl+4: Simple Confirm";
            qInfo() << "  Ctrl+Q: Quit";
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects created!";
        return -1;
    }
    
    return app.exec();
}
