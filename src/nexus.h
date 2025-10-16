/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2015-2019 by The qTox Project Contributors
 * Copyright © 2024-2025 The TokTok team.
 */


#pragma once

#include "audio/iaudiocontrol.h"

#include <QObject>

#include <memory>

class Widget;
class Profile;
class Settings;
class LoginScreen;
class Core;
class QCommandLineParser;
class CameraSource;
class Style;
class IMessageBoxManager;
class IPC;
class PremiumUILauncher;

class Nexus : public QObject
{
    Q_OBJECT
public:
    Nexus(Settings& settings, IMessageBoxManager& messageBoxManager, CameraSource& cameraSource,
          IPC& ipc, QObject* parent = nullptr);
    ~Nexus() override;
    void start();
    void showMainGUI();
    void setParser(QCommandLineParser* parser_);
    Profile* getProfile();
    void registerIpcHandlers();
    bool handleToxSave(const QString& path);

    void screenshot();

signals:
    void currentProfileChanged(Profile* Profile);
    void profileLoaded();
    void profileLoadFailed();
    void saveGlobal();

public slots:
    void onCreateNewProfile(const QString& name, const QString& pass);
    void onLoadProfile(const QString& name, const QString& pass);
    int showLogin(const QString& profileName = QString());
    void bootstrapWithProfile(Profile* p);

private:
    void connectLoginScreen(const LoginScreen& loginScreen);
    void setProfile(std::unique_ptr<Profile> p);

private:
    std::unique_ptr<Profile> profile;
    Settings& settings;
    std::unique_ptr<Widget> widget;
    std::unique_ptr<PremiumUILauncher> premiumUI;
    std::unique_ptr<IAudioControl> audioControl;
    QCommandLineParser* parser = nullptr;
    CameraSource& cameraSource;
    std::unique_ptr<Style> style;
    IMessageBoxManager& messageBoxManager;
    IPC& ipc;
};
