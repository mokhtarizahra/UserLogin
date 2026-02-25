#include "userstorage.h"

#include <QJsonDocument>
#include <QDebug>

bool UserStorage::save(const QVector<QSharedPointer<GenericItem>>& items)
{
    QString path = filePath("users.json");
    QFile file(path);

    QJsonArray currentArray;

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();
        if (doc.isArray())
            currentArray = doc.array();
    }

    QMap<QString, QSharedPointer<GenericItem>> currentItems;
    for (const auto& item : items) {
        QString key = item->get("userid").toString() + "_" + item->get("uniqueId").toString();
        currentItems[key] = item;
    }

    QJsonArray newArray;
    for (const auto& item : items) {
        newArray.append(item->toJson());
    }

    QJsonArray finalArray;
    for (const auto& val : currentArray) {
        QJsonObject obj = val.toObject();
        QString key = obj["userid"].toString() + "_" + obj["uniqueId"].toString();
        if (currentItems.contains(key)) {
            finalArray.append(currentItems[key]->toJson());
            currentItems.remove(key);
        }
    }

    for (auto item : currentItems) {
        finalArray.append(item->toJson());
    }

    QJsonDocument doc(finalArray);
    if (!file.open(QIODevice::WriteOnly)) {
        return false;
    }
    file.write(doc.toJson(QJsonDocument::Indented));
    file.close();

    return true;
}

///////////////////////////////////////////////////
QList<QSharedPointer<GenericItem>> UserStorage::load()
{
    QList<QSharedPointer<GenericItem>> list;
    QFile file(filePath("users.json"));
    if (!file.open(QIODevice::ReadOnly))
        return list;

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    file.close();

    if (!doc.isArray())
        return list;

    for (const QJsonValue& val : doc.array()) {
        QMap<QString, QVariant> data = GenericItem::fromJson(val.toObject())->getAttributes();
        list.append(QSharedPointer<GenericItem>::create(data));
    }

    return list;
}


///////////////////////////////////////////////////
QString UserStorage::filePath(const QString& filename)
{
    QString dirPath = QStandardPaths::writableLocation(
        QStandardPaths::DocumentsLocation);

    QDir dir(dirPath);
    if (!dir.exists())
        dir.mkpath(".");

    return dir.filePath(filename);
}

//////////////////////////////////////////////////
bool UserStorage::saveHistory(const QVector<QSharedPointer<GenericItem>>& items)
{
    QString path = filePath("login_history.json");
    QFile file(path);

    QJsonObject historyJson;

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        file.close();
        if (doc.isObject())
            historyJson = doc.object();
    }

    QSet<QString> currentKeys;
    for (const auto& item : items) {
        QString key = item->get("userid").toString() + "_" + item->get("uniqueId").toString();
        currentKeys.insert(key);
    }

    QJsonObject newHistoryJson;

    for (const auto& item : items) {
        QString userid = item->get("userid").toString();
        QString uniqueId = item->get("uniqueId").toString();
        QString key = userid + "_" + uniqueId;

        QJsonArray newEntries = item->loginLogoutHistoryToJson();
        QJsonArray mergedArray;
        QSet<QString> existingRecords;

        if (historyJson.contains(key)) {
            QJsonArray oldArray = historyJson[key].toArray();
            for (const auto& val : oldArray) {
                QJsonObject obj = val.toObject();
                QString combined = obj["loginTime"].toString() + "|" + obj["logoutTime"].toString();
                mergedArray.append(val);
                existingRecords.insert(combined);
            }
        }

        for (const auto& val : newEntries) {
            QJsonObject obj = val.toObject();
            QString combined = obj["loginTime"].toString() + "|" + obj["logoutTime"].toString();
            if (!existingRecords.contains(combined)) {
                mergedArray.append(val);
                existingRecords.insert(combined);
            }
        }

        newHistoryJson[key] = mergedArray;
    }

    QJsonObject finalHistory;
    for (const QString& key : currentKeys) {
        if (newHistoryJson.contains(key))
            finalHistory[key] = newHistoryJson[key];
    }

    QJsonDocument doc(finalHistory);
    if (!file.open(QIODevice::WriteOnly)) {
        return false;
    }
    file.write(doc.toJson(QJsonDocument::Indented));
    file.close();

    return true;
}
