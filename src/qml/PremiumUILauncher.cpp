/* SPDX-License-Identifier: GPL-3.0-or-later
 * qTox Premium UI - Main Application Launcher Implementation
 */

#include "PremiumUILauncher.h"
#include "QmlBridge.h"
#include "src/persistence/profile.h"
#include "src/persistence/settings.h"
#include "src/core/core.h"
#include "src/friendlist.h"
#include "src/widget/style.h"
#include "audio/iaudiocontrol.h"
#include "video/camerasource.h"

#include <QQmlContext>
#include <QQuickWindow>
#include <QDebug>

PremiumUILauncher::PremiumUILauncher(Profile& profile_,
                                     Settings& settings_,
                                     IAudioControl& audio_,
                                     CameraSource& cameraSource_,
                                     Style& style_,
                                     IMessageBoxManager& messageBoxManager_,
                                     QObject* parent)
    : QObject(parent)
    , profile(profile_)
    , settings(settings_)
    , audio(audio_)
    , cameraSource(cameraSource_)
    , style(style_)
    , messageBoxManager(messageBoxManager_)
    , engine(nullptr)
    , qmlBridge(nullptr)
    , core(nullptr)
    , friendList(nullptr)
{
}

PremiumUILauncher::~PremiumUILauncher()
{
    if (qmlBridge) {
        delete qmlBridge;
    }
}

bool PremiumUILauncher::initialize()
{
    qDebug() << "Initializing Premium UI...";

    // Get core and friend list from profile
    core = profile.getCore();
    if (!core) {
        qWarning() << "Failed to get Core from profile";
        return false;
    }

    // Initialize friend list (assuming it's a global singleton or accessible via some means)
    // This is a placeholder - adjust based on actual qTox architecture
    friendList = new FriendList(); // TODO: Get actual friend list instance

    // Create QML engine
    engine = std::make_unique<QQmlApplicationEngine>();
    if (!engine) {
        qWarning() << "Failed to create QML engine";
        return false;
    }

    // Register QML types and set up context
    registerQmlTypes();
    setupQmlEngine();

    // Create QML bridge
    qmlBridge = new QmlBridge(core, *friendList, settings, profile, nullptr, this);

    // Set context properties
    setQmlContextProperties();

    // Load main QML file
    const QString qmlFile = QStringLiteral("qrc:/qml/PremiumMainWindow.qml");
    engine->load(qmlFile);

    if (engine->rootObjects().isEmpty()) {
        qWarning() << "Failed to load QML file:" << qmlFile;
        return false;
    }

    qDebug() << "Premium UI initialized successfully";
    return true;
}

void PremiumUILauncher::setupQmlEngine()
{
    // Set import paths
    engine->addImportPath("qrc:/qml");
    engine->addImportPath("qrc:/qml/components");
    engine->addImportPath("qrc:/qml/themes");

    // Connect error signals
    connect(engine.get(), &QQmlApplicationEngine::objectCreated, this, 
            [](QObject* obj, const QUrl& objUrl) {
        if (!obj) {
            qWarning() << "Failed to create object from" << objUrl;
        }
    });
}

void PremiumUILauncher::registerQmlTypes()
{
    // Register QML types if needed
    // qmlRegisterType<QmlBridge>("qTox.Premium", 1, 0, "QmlBridge");
}

void PremiumUILauncher::setQmlContextProperties()
{
    if (!engine || !qmlBridge) {
        return;
    }

    // Set the QML bridge as a context property so it's accessible from QML
    QQmlContext* rootContext = engine->rootContext();
    rootContext->setContextProperty("qmlBridge", qmlBridge);

    // Add other context properties as needed
    rootContext->setContextProperty("appVersion", "1.0.0");
    rootContext->setContextProperty("qtoxVersion", "Premium UI");
}

void PremiumUILauncher::show()
{
    if (!engine) {
        return;
    }

    const auto objects = engine->rootObjects();
    for (QObject* obj : objects) {
        if (QQuickWindow* window = qobject_cast<QQuickWindow*>(obj)) {
            window->show();
            window->raise();
            window->requestActivate();
        }
    }
}

void PremiumUILauncher::hide()
{
    if (!engine) {
        return;
    }

    const auto objects = engine->rootObjects();
    for (QObject* obj : objects) {
        if (QQuickWindow* window = qobject_cast<QQuickWindow*>(obj)) {
            window->hide();
        }
    }
}

bool PremiumUILauncher::isVisible() const
{
    if (!engine) {
        return false;
    }

    const auto objects = engine->rootObjects();
    for (QObject* obj : objects) {
        if (QQuickWindow* window = qobject_cast<QQuickWindow*>(obj)) {
            return window->isVisible();
        }
    }

    return false;
}
