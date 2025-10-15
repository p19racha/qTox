/* SPDX-License-Identifier: GPL-3.0-or-later
 * Copyright © 2014-2019 by The qTox Project Contributors
 * Copyright © 2024-2025 The TokTok team.
 */


#include "nexus.h"

#include "audio/audio.h"
#include "persistence/settings.h"
#include "src/core/core.h"
#include "src/core/coreav.h"
#include "src/ipc.h"
#include "src/model/conferenceinvite.h"
#include "src/model/status.h"
#include "src/persistence/profile.h"
#include "src/widget/style.h"
#include "src/widget/tool/imessageboxmanager.h"
#include "src/widget/widget.h"
#include "video/camerasource.h"
#include "widget/loginscreen.h"

#include <QApplication>
#include <QCommandLineParser>
#include <QDebug>
#include <QDir>
#include <QScreen>
#include <QStandardPaths>
#include <QThread>

#include <cassert>
#include <vpx/vpx_image.h>

/**
 * @class Nexus
 *
 * This class is in charge of connecting various systems together
 * and forwarding signals appropriately to the right objects,
 * it is in charge of starting the GUI and the Core.
 */

Q_DECLARE_OPAQUE_POINTER(ToxAV*)

Nexus::Nexus(Settings& settings_, IMessageBoxManager& messageBoxManager_,
             CameraSource& cameraSource_, IPC& ipc_, QObject* parent)
    : QObject(parent)
    , profile{nullptr}
    , settings{settings_}
    , widget{nullptr}
    , cameraSource{cameraSource_}
    , style{new Style()}
    , messageBoxManager{messageBoxManager_}
    , ipc{ipc_}
{
    connect(this, &Nexus::saveGlobal, &settings, &Settings::saveGlobal);
}

Nexus::~Nexus()
{
    widget = nullptr;
    if (profile != nullptr) {
        profile->save();
        profile = nullptr;
    }
    emit saveGlobal();
}

/**
 * @brief Sets up invariants and calls showLogin
 *
 * Hides the login screen and shows the GUI for the given profile.
 * Will delete the current GUI, if it exists.
 */
void Nexus::start()
{
    qDebug() << "Starting up";

    // Setup the environment
    qRegisterMetaType<Status::Status>("Status::Status");
    qRegisterMetaType<vpx_image>("vpx_image");
    qRegisterMetaType<uint8_t>("uint8_t");
    qRegisterMetaType<uint16_t>("uint16_t");
    qRegisterMetaType<uint32_t>("uint32_t");
    qRegisterMetaType<const int16_t*>("const int16_t*");
    qRegisterMetaType<int32_t>("int32_t");
    qRegisterMetaType<int64_t>("int64_t");
    qRegisterMetaType<size_t>("size_t");
    qRegisterMetaType<QPixmap>("QPixmap");
    qRegisterMetaType<Profile*>("Profile*");
    qRegisterMetaType<ToxAV*>("ToxAV*");
    qRegisterMetaType<ToxFile>("ToxFile");
    qRegisterMetaType<ToxFile::FileDirection>("ToxFile::FileDirection");
    qRegisterMetaType<std::shared_ptr<VideoFrame>>("std::shared_ptr<VideoFrame>");
    qRegisterMetaType<ToxPk>("ToxPk");
    qRegisterMetaType<ToxId>("ToxId");
    qRegisterMetaType<ToxPk>("ConferenceId");
    qRegisterMetaType<ToxPk>("ChatId");
    qRegisterMetaType<ConferenceInvite>("ConferenceInvite");
    qRegisterMetaType<ReceiptNum>("ReceiptNum");
    qRegisterMetaType<RowId>("RowId");
    qRegisterMetaType<uint64_t>("uint64_t");

    qApp->setQuitOnLastWindowClosed(false);

    showMainGUI();
}

/**
 * @brief Hides the main GUI, delete the profile, and shows the login screen
 */
int Nexus::showLogin(const QString& profileName)
{
    // Delete the current GUI.
    widget = nullptr;

    // Delete at the end of the function, but get ready to set a new one.
    // We need to keep it alive for a while longer because it may be used on shutdown.
    auto oldProfile = std::move(profile);
    // Finish saving the current profile if needed.
    if (oldProfile != nullptr) {
        oldProfile->save();
    }

    LoginScreen loginScreen{settings.getPaths(), *style, settings.getThemeColor(), profileName};
    connectLoginScreen(loginScreen);

    QCoreApplication::sendPostedEvents(nullptr, QEvent::DeferredDelete);

    // TODO(kriby): Move core out of profile
    // This is awkward because the core is in the profile
    // The connection order ensures profile will be ready for bootstrap for now
    connect(this, &Nexus::currentProfileChanged, this, &Nexus::bootstrapWithProfile);
    const int returnval = loginScreen.exec();
    if (returnval == QDialog::Rejected) {
        // Kriby: This will terminate the main application loop, necessary until we refactor
        // away the split startup/return to login behavior.
        qApp->quit();
    }
    disconnect(this, &Nexus::currentProfileChanged, this, &Nexus::bootstrapWithProfile);

    return returnval;
}

void Nexus::bootstrapWithProfile(Profile* p)
{
    // kriby: This is a hack until a proper controller is written

    // We take ownership of the profile here.
    profile = std::unique_ptr<Profile>(p);

    if (profile != nullptr) {
        audioControl = std::unique_ptr<IAudioControl>(Audio::makeAudio(settings));
        assert(audioControl != nullptr);
        profile->getCore().getAv()->setAudio(*audioControl);
        start();
    }
}

void Nexus::connectLoginScreen(const LoginScreen& loginScreen)
{
    // TODO(kriby): Move connect sequences to a controller class object instead

    // Nexus -> LoginScreen
    connect(this, &Nexus::profileLoaded, &loginScreen, &LoginScreen::onProfileLoaded);
    connect(this, &Nexus::profileLoadFailed, &loginScreen, &LoginScreen::onProfileLoadFailed);
    // LoginScreen -> Nexus
    connect(&loginScreen, &LoginScreen::createNewProfile, this, &Nexus::onCreateNewProfile);
    connect(&loginScreen, &LoginScreen::loadProfile, this, &Nexus::onLoadProfile);
    // LoginScreen -> Settings
    connect(&loginScreen, &LoginScreen::autoLoginChanged, &settings, &Settings::setAutoLogin);
    connect(&loginScreen, &LoginScreen::autoLoginChanged, &settings, &Settings::saveGlobal);
    // Settings -> LoginScreen
    connect(&settings, &Settings::autoLoginChanged, &loginScreen, &LoginScreen::onAutoLoginChanged);
    // LoginScreen -> QMessageBox
    connect(&loginScreen, &LoginScreen::failure, this,
            [this](const QString& title, const QString& message) {
                messageBoxManager.showError(title, message);
            });
}

void Nexus::showMainGUI()
{
    // TODO(kriby): Rewrite as view-model connect sequence only, add to a controller class object
    assert(profile);

    // Create GUI
    widget =
        std::make_unique<Widget>(*profile, *audioControl, cameraSource, settings, *style, ipc, *this);

    // Start GUI
    widget->init();

    // Zetok protection
    // There are small instants on startup during which no
    // profile is loaded but the GUI could still receive events,
    // e.g. between two modal windows. Disable the GUI to prevent that.
    widget->setEnabled(false);

    // Connections
    connect(profile.get(), &Profile::selfAvatarChanged, widget.get(), &Widget::onSelfAvatarLoaded);

    connect(profile.get(), &Profile::coreChanged, widget.get(), &Widget::onCoreChanged);

    connect(profile.get(), &Profile::failedToStart, widget.get(), &Widget::onFailedToStartCore,
            Qt::BlockingQueuedConnection);

    connect(profile.get(), &Profile::badProxy, widget.get(), &Widget::onBadProxyCore,
            Qt::BlockingQueuedConnection);

    profile->startCore();

    widget->setEnabled(true);
}

/**
 * @brief Get current user profile.
 * @return nullptr if not started, profile otherwise.
 */
Profile* Nexus::getProfile()
{
    return profile.get();
}

/**
 * @brief Creates a new profile and replaces the current one.
 * @param name New username
 * @param pass New password
 */
void Nexus::onCreateNewProfile(const QString& name, const QString& pass)
{
    setProfile(Profile::createProfile(name, pass, settings, parser, cameraSource, messageBoxManager));
    parser = nullptr; // only apply cmdline proxy settings once
}

/**
 * Loads an existing profile and replaces the current one.
 */
void Nexus::onLoadProfile(const QString& name, const QString& pass)
{
    setProfile(Profile::loadProfile(name, pass, settings, parser, cameraSource, messageBoxManager));
    parser = nullptr; // only apply cmdline proxy settings once
}
/**
 * Changes the loaded profile and notifies listeners.
 * @param p
 */
void Nexus::setProfile(std::unique_ptr<Profile> p)
{
    if (p == nullptr) {
        emit profileLoadFailed();
        // Warnings are issued during respective createNew/load calls
        return;
    }
    emit profileLoaded();

    // Pushing Profile ownership to the receiver of this signal.
    emit currentProfileChanged(p.release());
}

void Nexus::setParser(QCommandLineParser* parser_)
{
    parser = parser_;
}

void Nexus::registerIpcHandlers()
{
    widget->registerIpcHandlers();
}

bool Nexus::handleToxSave(const QString& path)
{
    assert(widget);
    return widget->handleToxSave(path);
}

void Nexus::screenshot()
{
    const QString filename = QString::fromUtf8(qgetenv("QTOX_SCREENSHOT"));
    if (filename.isEmpty()) {
        // No-op unless QTOX_SCREENSHOT is set.
        return;
    }

    if (widget == nullptr) {
        qWarning() << "No widget to take screenshot of";
        return;
    }

    // Paint the widget onto a pixmap. This makes sure the screenshot still
    // works even if we don't have screen capture permissions.
    QPixmap pixmap(widget->size());
    widget->render(&pixmap);

    QString path = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    if (path.isEmpty()) {
        path = QDir::currentPath();
    }
    path += "/" + filename;
    if (pixmap.save(path)) {
        qDebug() << "Saved screenshot to" << path;
    } else {
        qWarning() << "Failed to save screenshot to" << path;
    }
}
