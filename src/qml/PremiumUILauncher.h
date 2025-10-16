/* SPDX-License-Identifier: GPL-3.0-or-later
 * qTox Premium UI - Main Application Launcher
 * Integrates QML frontend with qTox backend
 */

#pragma once

#include <QObject>
#include <QQuickView>
#include <QQmlApplicationEngine>
#include <memory>

class Core;
class FriendList;
class Settings;
class Profile;
class Widget;
class QmlBridge;
class IAudioControl;
class CameraSource;
class Style;
class IMessageBoxManager;

class PremiumUILauncher : public QObject
{
    Q_OBJECT

public:
    explicit PremiumUILauncher(Profile& profile, 
                              Settings& settings,
                              IAudioControl& audio,
                              CameraSource& cameraSource,
                              Style& style,
                              IMessageBoxManager& messageBoxManager,
                              QObject* parent = nullptr);
    ~PremiumUILauncher() override;

    bool initialize();
    void show();
    void hide();
    bool isVisible() const;

    // Access to the QML engine for external management
    QQmlApplicationEngine* getEngine() const { return engine.get(); }
    QmlBridge* getBridge() const { return qmlBridge; }

signals:
    void closed();

private:
    void setupQmlEngine();
    void registerQmlTypes();
    void setQmlContextProperties();

private:
    Profile& profile;
    Settings& settings;
    IAudioControl& audio;
    CameraSource& cameraSource;
    Style& style;
    IMessageBoxManager& messageBoxManager;
    
    std::unique_ptr<QQmlApplicationEngine> engine;
    QmlBridge* qmlBridge;
    Core* core;
    FriendList* friendList;
};
