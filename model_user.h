#ifndef MODEL_USER_H
#define MODEL_USER_H

#include <QAbstractListModel>
#include <QMap>
#include <QVector>
#include <QSharedPointer>
#include <QPointer>
#include <QRandomGenerator>

#include "genericitem.h"
#include "userstorage.h"
#include "employeestorage.h"

class Model_User : public QAbstractListModel
{
    Q_OBJECT


public:
    explicit Model_User(QObject *parent = nullptr);
    ~Model_User();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    // API
    Q_INVOKABLE bool createItem(const QMap<QString, QVariant> &data);
    QString generateUniqueId(int length);
    Q_INVOKABLE bool isValidEmployeeId(const QString& userId);
    Q_INVOKABLE bool isUsernameAvailable(const QString &username);
//    Q_INVOKABLE bool registerUser(const QString &userId,const QString &username,const QString &password);
    Q_INVOKABLE int  loginUser(const QString& username, const QString& userId);
    Q_INVOKABLE bool logoutUser(const QString& username, const QString& userId);
    Q_INVOKABLE bool removeUser(int row);
    bool removeRows(int row, int count,const QModelIndex &parent = QModelIndex()) override;
    Q_INVOKABLE bool clear();
    Q_INVOKABLE QMap<QString, QVariant> getUser(int row) const;

    void setUsers(const QVector<QSharedPointer<GenericItem>>& users);

    enum Roles {
        UsernameRole = Qt::UserRole + 1, // 257
        UserIdRole,                      // 258
        IsActiveRole,                    // 259
        LoginTimeRole,                   // 260
        LogoutTimeRole,                  // 261
        DurationRole,                    // 262
        PasswordRole,                    // 263
        UniqueIdRole

    };

    Q_INVOKABLE bool updateUser(int row,
                                const QString& username,
                                const QString& password);

signals:
    void loginFailed(const QString& message);
    void userDataChanged();

private:
    bool addItem(const QSharedPointer<GenericItem>& item);

private:
    QVector<QSharedPointer<GenericItem>> m_items;
    EmployeeStorage m_employeeStorage;
};

#endif // MODEL_USER_H
