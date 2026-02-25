#include "loginhistorymodel.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

LoginHistoryModel::LoginHistoryModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadHistory();
}
////////////////////////////////////////////////////////////////
int LoginHistoryModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_histories.size();
}
/////////////////////////////////////////////////////////////////
QVariant LoginHistoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_histories.size())
        return QVariant();

    const QVariantMap &item = m_histories.at(index.row());

    switch (role) {
        case UserIdRole:     return item.value("userid");
        case UniqueIdRole:   return item.value("uniqueId");
        case LoginTimeRole:  return item.value("loginTime");
        case LogoutTimeRole: return item.value("logoutTime");
        default:             return QVariant();
    }
}
/////////////////////////////////////////////////////////////////
QHash<int, QByteArray> LoginHistoryModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[UserIdRole]     = "userid";
    roles[UniqueIdRole]   = "uniqueId";
    roles[LoginTimeRole]  = "loginTime";
    roles[LogoutTimeRole] = "logoutTime";
    return roles;
}
///////////////////////////////////////////////////////
void LoginHistoryModel::loadHistory()
{
    m_histories.clear();

    QString path = filePath();
    QFile file(path);
    if (!file.exists()) {
        qWarning() << "LoginHistoryModel: file does not exist:" << path;
        return;
    }

    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "LoginHistoryModel: failed to open file:" << path;
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    file.close();

    if (!doc.isObject()) {
        qWarning() << "LoginHistoryModel: invalid JSON format";
        return;
    }

    QJsonObject rootObj = doc.object();

    for (const QString &key : rootObj.keys()) {
        QJsonArray userArray = rootObj[key].toArray();

        QStringList parts = key.split("_");
        if (parts.size() != 2)
            continue;
        QString userid = parts[0];
        QString uniqueId = parts[1];

        for (const QJsonValue &val : userArray) {
            QJsonObject obj = val.toObject();
            QVariantMap map;
            map["userid"] = userid;
            map["uniqueId"] = uniqueId;
            map["loginTime"] = obj.value("loginTime").toString();
            map["logoutTime"] = obj.value("logoutTime").toString();

            m_histories.append(map);
        }
    }

    beginResetModel();
    endResetModel();
}
///////////////////////////////////////////////////////////////////////
QString LoginHistoryModel::filePath() const
{
    QString dirPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QDir dir(dirPath);
    if (!dir.exists())
        dir.mkpath(".");
    return dir.filePath("login_history.json");
}
