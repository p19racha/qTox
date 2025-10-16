// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright © 2025 qTox Project - Premium Chat Preview Application

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QDebug>

int main(int argc, char *argv[])
{
    // Enable high DPI scaling for crisp rendering
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    
    QGuiApplication app(argc, argv);
    
    // Set application metadata
    app.setOrganizationName("qTox");
    app.setApplicationName("qTox Premium Preview");
    app.setApplicationVersion("1.0.0");
    
    qDebug() << "=== qTox Premium UI Preview ===";
    qDebug() << "Starting premium chat interface...";
    
    QQmlApplicationEngine engine;
    
    // Load the premium chat QML
    const QUrl url(QStringLiteral("qrc:/qml/premium_chat.qml"));
    
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            qCritical() << "Failed to load QML file";
            QCoreApplication::exit(-1);
        } else {
            qDebug() << "✓ Premium UI loaded successfully!";
            qDebug() << "";
            qDebug() << "Controls:";
            qDebug() << "  Ctrl+,  - Open Settings";
            qDebug() << "  Ctrl+Q  - Quit";
            qDebug() << "";
            qDebug() << "Theme: Dark Mode (Always enabled)";
            qDebug() << "";
        }
    }, Qt::QueuedConnection);
    
    engine.load(url);
    
    if (engine.rootObjects().isEmpty()) {
        qCritical() << "No root objects loaded!";
        return -1;
    }
    
    qDebug() << "qTox Premium UI Preview started successfully";
    return app.exec();
}
