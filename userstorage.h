#ifndef USERSTORAGE_H
#define USERSTORAGE_H


#pragma once
#include <QList>
#include <QJsonArray>
#include <QJsonObject>
#include <QString>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QSharedPointer>
#include "genericitem.h"

class UserStorage
{
public:
    static bool save(const QVector<QSharedPointer<GenericItem>>& items);
    static bool saveHistory(const QVector<QSharedPointer<GenericItem>>& items);
    static QList<QSharedPointer<GenericItem>> load();

private:
    static QString filePath(const QString& filename);


};

#endif // USERSTORAGE_H
