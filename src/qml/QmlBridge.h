/* SPDX-License-Identifier: GPL-3.0-or-later
 * qTox Premium UI - QML Bridge
 * Main bridge class exposing qTox backend to QML frontend
 */

#pragma once

#include <QObject>
#include <QString>
#include <QQmlEngine>
#include "src/core/toxpk.h"
#include "src/model/status.h"
#include "models/FriendListModel.h"

class Core;
class Friend;
class FriendList;
class Settings;
class Profile;
class Widget;

class QmlBridge : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    
    Q_PROPERTY(QString username READ getUsername WRITE setUsername NOTIFY usernameChanged)
    Q_PROPERTY(QString statusMessage READ getStatusMessage WRITE setStatusMessage NOTIFY statusMessageChanged)
    Q_PROPERTY(int userStatus READ getUserStatus WRITE setUserStatus NOTIFY userStatusChanged)
    Q_PROPERTY(QString selfToxId READ getSelfToxId NOTIFY selfToxIdChanged)
    Q_PROPERTY(FriendListModel* friendListModel READ getFriendListModel CONSTANT)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionStatusChanged)

public:
    explicit QmlBridge(Core* core, FriendList& friendList, Settings& settings, Profile& profile, 
                       Widget* widget = nullptr, QObject* parent = nullptr);
    ~QmlBridge() override;

    // Property getters
    QString getUsername() const;
    QString getStatusMessage() const;
    int getUserStatus() const;
    QString getSelfToxId() const;
    FriendListModel* getFriendListModel() const;
    bool isConnected() const;

    // Property setters
    void setUsername(const QString& username);
    void setStatusMessage(const QString& message);
    void setUserStatus(int status);

    // Invokable methods for QML
    Q_INVOKABLE void sendMessage(const QString& friendPk, const QString& message);
    Q_INVOKABLE void acceptFriendRequest(const QString& friendPk);
    Q_INVOKABLE void removeFriend(const QString& friendPk);
    Q_INVOKABLE void addFriend(const QString& toxId, const QString& message);
    Q_INVOKABLE void createConference();
    Q_INVOKABLE void joinConference(const QString& inviteData);
    Q_INVOKABLE QString getFriendName(const QString& friendPk);
    Q_INVOKABLE void openChat(const QString& friendPk);
    Q_INVOKABLE void loadChatHistory(const QString& friendPk);

signals:
    void usernameChanged(const QString& username);
    void statusMessageChanged(const QString& message);
    void userStatusChanged(int status);
    void selfToxIdChanged(const QString& toxId);
    void connectionStatusChanged(bool connected);
    
    void friendMessageReceived(const QString& friendPk, const QString& message);
    void friendRequestReceived(const QString& friendPk, const QString& message);
    void friendAdded(const QString& friendPk);
    void friendRemoved(const QString& friendPk);
    void friendStatusChanged(const QString& friendPk, int status);
    void friendTypingChanged(const QString& friendPk, bool isTyping);
    
    void conferenceMessageReceived(const QString& conferencePk, const QString& author, const QString& message);
    void conferenceInviteReceived(const QString& inviteData);

public slots:
    void onFriendMessageReceived(uint32_t friendId, const QString& message);
    void onFriendRequestReceived(const ToxPk& friendPk, const QString& message);
    void onFriendStatusChanged(uint32_t friendId, Status::Status status);
    void onConnectionStatusChanged(bool connected);

private:
    Core* core;
    FriendList& friendList;
    Settings& settings;
    Profile& profile;
    Widget* widget;
    FriendListModel* friendListModel;
    
    ToxPk stringToToxPk(const QString& str) const;
};
