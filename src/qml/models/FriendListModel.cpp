/* SPDX-License-Identifier: GPL-3.0-or-later
 * qTox Premium UI - Friend List Model Implementation
 */

#include "FriendListModel.h"
#include "src/core/core.h"
#include "src/persistence/settings.h"
#include "src/model/status.h"

FriendListModel::FriendListModel(FriendList& friendList_, Core* core_, Settings& settings_, QObject* parent)
    : QAbstractListModel(parent)
    , friendList(friendList_)
    , core(core_)
    , settings(settings_)
{
    refreshFriendList();
}

int FriendListModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;
    return friends.count();
}

QVariant FriendListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= friends.count())
        return QVariant();

    Friend* f = friends.at(index.row());
    if (!f)
        return QVariant();

    switch (role) {
    case NameRole:
        return f->getDisplayedName();
    case StatusRole:
        return static_cast<int>(f->getStatus());
    case StatusMessageRole:
        return f->getStatusMessage();
    case AvatarRole:
        return f->getAvatar();
    case PublicKeyRole:
        return f->getPublicKey().toString();
    case UnreadCountRole:
        return 0; // TODO: Implement unread count
    case LastMessageRole:
        return QString(); // TODO: Implement last message
    case LastMessageTimeRole:
        return QString(); // TODO: Implement last message time
    case IsOnlineRole:
        return f->getStatus() != Status::Status::Offline;
    case IsTypingRole:
        return false; // TODO: Implement typing indicator
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> FriendListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "friendName";
    roles[StatusRole] = "status";
    roles[StatusMessageRole] = "statusMessage";
    roles[AvatarRole] = "avatar";
    roles[PublicKeyRole] = "publicKey";
    roles[UnreadCountRole] = "unreadCount";
    roles[LastMessageRole] = "lastMessage";
    roles[LastMessageTimeRole] = "lastMessageTime";
    roles[IsOnlineRole] = "isOnline";
    roles[IsTypingRole] = "isTyping";
    return roles;
}

void FriendListModel::refreshFriendList()
{
    beginResetModel();
    friends = friendList.getAllFriends();
    endResetModel();
}

void FriendListModel::onFriendAdded(Friend* f)
{
    if (!f)
        return;
    
    int row = friends.count();
    beginInsertRows(QModelIndex(), row, row);
    friends.append(f);
    endInsertRows();
}

void FriendListModel::onFriendRemoved(const ToxPk& friendPk)
{
    for (int i = 0; i < friends.count(); ++i) {
        if (friends[i]->getPublicKey() == friendPk) {
            beginRemoveRows(QModelIndex(), i, i);
            friends.removeAt(i);
            endRemoveRows();
            break;
        }
    }
}

void FriendListModel::onFriendStatusChanged(const ToxPk& friendPk, Status::Status status)
{
    Q_UNUSED(status);
    for (int i = 0; i < friends.count(); ++i) {
        if (friends[i]->getPublicKey() == friendPk) {
            QModelIndex idx = index(i);
            emit dataChanged(idx, idx);
            break;
        }
    }
}

void FriendListModel::onFriendMessageReceived(const ToxPk& friendPk)
{
    for (int i = 0; i < friends.count(); ++i) {
        if (friends[i]->getPublicKey() == friendPk) {
            QModelIndex idx = index(i);
            emit dataChanged(idx, idx);
            break;
        }
    }
}

void FriendListModel::onFriendTypingChanged(const ToxPk& friendPk, bool isTyping)
{
    Q_UNUSED(isTyping);
    for (int i = 0; i < friends.count(); ++i) {
        if (friends[i]->getPublicKey() == friendPk) {
            QModelIndex idx = index(i);
            emit dataChanged(idx, idx);
            break;
        }
    }
}

void FriendListModel::updateFriendData(Friend* f)
{
    for (int i = 0; i < friends.count(); ++i) {
        if (friends[i] == f) {
            QModelIndex idx = index(i);
            emit dataChanged(idx, idx);
            break;
        }
    }
}
