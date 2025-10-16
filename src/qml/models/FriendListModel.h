/* SPDX-License-Identifier: GPL-3.0-or-later
 * qTox Premium UI - Friend List Model
 * Exposes friend list data from C++ backend to QML
 */

#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QString>
#include <QPixmap>
#include "src/model/friend.h"
#include "src/friendlist.h"

class Core;
class Settings;

class FriendListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum FriendRoles {
        NameRole = Qt::UserRole + 1,
        StatusRole,
        StatusMessageRole,
        AvatarRole,
        PublicKeyRole,
        UnreadCountRole,
        LastMessageRole,
        LastMessageTimeRole,
        IsOnlineRole,
        IsTypingRole
    };

    explicit FriendListModel(FriendList& friendList, Core* core, Settings& settings, QObject* parent = nullptr);

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void refreshFriendList();
    void onFriendAdded(Friend* f);
    void onFriendRemoved(const ToxPk& friendPk);
    void onFriendStatusChanged(const ToxPk& friendPk, Status::Status status);
    void onFriendMessageReceived(const ToxPk& friendPk);
    void onFriendTypingChanged(const ToxPk& friendPk, bool isTyping);

private:
    FriendList& friendList;
    Core* core;
    Settings& settings;
    QList<Friend*> friends;
    
    void updateFriendData(Friend* f);
};
