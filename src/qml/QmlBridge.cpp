/* SPDX-License-Identifier: GPL-3.0-or-later
 * qTox Premium UI - QML Bridge Implementation
 */

#include "QmlBridge.h"
#include "models/FriendListModel.h"
#include "src/core/core.h"
#include "src/friendlist.h"
#include "src/model/friend.h"
#include "src/persistence/settings.h"
#include "src/persistence/profile.h"
#include "src/widget/widget.h"
#include "src/core/toxid.h"

QmlBridge::QmlBridge(Core* core_, FriendList& friendList_, Settings& settings_, Profile& profile_,
                     Widget* widget_, QObject* parent)
    : QObject(parent)
    , core(core_)
    , friendList(friendList_)
    , settings(settings_)
    , profile(profile_)
    , widget(widget_)
    , friendListModel(nullptr)
{
    if (core) {
        friendListModel = new FriendListModel(friendList, core, settings, this);
        
        // Connect core signals to bridge slots
        connect(core, &Core::friendMessageReceived, this, &QmlBridge::onFriendMessageReceived);
        connect(core, &Core::friendRequestReceived, this, &QmlBridge::onFriendRequestReceived);
    }
}

QmlBridge::~QmlBridge()
{
}

QString QmlBridge::getUsername() const
{
    return core ? core->getUsername() : QString();
}

QString QmlBridge::getStatusMessage() const
{
    return core ? core->getStatusMessage() : QString();
}

int QmlBridge::getUserStatus() const
{
    return core ? static_cast<int>(core->getStatus()) : 0;
}

QString QmlBridge::getSelfToxId() const
{
    return core ? core->getSelfId().toString() : QString();
}

FriendListModel* QmlBridge::getFriendListModel() const
{
    return friendListModel;
}

bool QmlBridge::isConnected() const
{
    // TODO: Implement connection status check
    return core != nullptr;
}

void QmlBridge::setUsername(const QString& username)
{
    if (core && core->getUsername() != username) {
        core->setUsername(username);
        emit usernameChanged(username);
    }
}

void QmlBridge::setStatusMessage(const QString& message)
{
    if (core && core->getStatusMessage() != message) {
        core->setStatusMessage(message);
        emit statusMessageChanged(message);
    }
}

void QmlBridge::setUserStatus(int status)
{
    if (core) {
        Status::Status statusEnum = static_cast<Status::Status>(status);
        if (core->getStatus() != statusEnum) {
            core->setStatus(statusEnum);
            emit userStatusChanged(status);
        }
    }
}

void QmlBridge::sendMessage(const QString& friendPk, const QString& message)
{
    if (!core || message.isEmpty())
        return;
        
    Friend* f = friendList.findFriend(stringToToxPk(friendPk));
    if (f) {
        // TODO: Use proper message sending API
        // This needs to integrate with the chatlog system
        qDebug() << "Sending message to" << friendPk << ":" << message;
    }
}

void QmlBridge::acceptFriendRequest(const QString& friendPk)
{
    if (!core)
        return;
        
    ToxPk pk = stringToToxPk(friendPk);
    core->acceptFriendRequest(pk);
    emit friendAdded(friendPk);
}

void QmlBridge::removeFriend(const QString& friendPk)
{
    if (!core)
        return;
        
    Friend* f = friendList.findFriend(stringToToxPk(friendPk));
    if (f) {
        core->removeFriend(f->getId());
        emit friendRemoved(friendPk);
    }
}

void QmlBridge::addFriend(const QString& toxId, const QString& message)
{
    if (!core || toxId.isEmpty())
        return;
        
    ToxId id(toxId);
    if (id.isValid()) {
        core->requestFriendship(id, message);
    }
}

void QmlBridge::createConference()
{
    if (core) {
        core->createConference();
    }
}

void QmlBridge::joinConference(const QString& inviteData)
{
    Q_UNUSED(inviteData);
    // TODO: Implement conference joining
}

QString QmlBridge::getFriendName(const QString& friendPk)
{
    Friend* f = friendList.findFriend(stringToToxPk(friendPk));
    return f ? f->getDisplayedName() : QString();
}

void QmlBridge::openChat(const QString& friendPk)
{
    if (widget) {
        Friend* f = friendList.findFriend(stringToToxPk(friendPk));
        if (f) {
            // TODO: Integrate with widget to open chat
            qDebug() << "Opening chat with" << friendPk;
        }
    }
}

void QmlBridge::loadChatHistory(const QString& friendPk)
{
    Q_UNUSED(friendPk);
    // TODO: Implement chat history loading
}

void QmlBridge::onFriendMessageReceived(uint32_t friendId, const QString& message)
{
    if (!core)
        return;
        
    ToxPk pk = core->getFriendPublicKey(friendId);
    emit friendMessageReceived(pk.toString(), message);
}

void QmlBridge::onFriendRequestReceived(const ToxPk& friendPk, const QString& message)
{
    emit friendRequestReceived(friendPk.toString(), message);
}

void QmlBridge::onFriendStatusChanged(uint32_t friendId, Status::Status status)
{
    if (!core)
        return;
        
    ToxPk pk = core->getFriendPublicKey(friendId);
    emit friendStatusChanged(pk.toString(), static_cast<int>(status));
}

void QmlBridge::onConnectionStatusChanged(bool connected)
{
    emit connectionStatusChanged(connected);
}

ToxPk QmlBridge::stringToToxPk(const QString& str) const
{
    return ToxPk(str);
}
