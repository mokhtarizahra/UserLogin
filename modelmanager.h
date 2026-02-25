#ifndef MODELMANAGER_H
#define MODELMANAGER_H

#include <QObject>
#include <QAbstractItemModel>
#include "model_user.h"
#include "userproxymodel.h"
#include "employeemodel.h"
#include "userstorage.h"
#include "loginhistorymodel.h"
#include "loginhistoryproxymodel.h"



class ModelManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QAbstractItemModel* userModel
               READ userModel CONSTANT)
    Q_PROPERTY(QAbstractItemModel* userProxyModel
               READ userProxyModel CONSTANT)
    Q_PROPERTY(QAbstractItemModel* employeeModel
               READ employeeModel CONSTANT)
    Q_PROPERTY(QAbstractItemModel* loginHistoryModel
               READ loginHistoryModel CONSTANT)
    Q_PROPERTY(QAbstractItemModel* loginHistoryProxyModel
                  READ loginHistoryProxyModel CONSTANT)
public:
    explicit ModelManager(QObject *parent = nullptr);

    Q_INVOKABLE QAbstractItemModel* model(const QString &name);

    QAbstractItemModel* userModel();
    QAbstractItemModel* userProxyModel();
    QAbstractItemModel* employeeModel();
    QAbstractItemModel* loginHistoryModel();
    QAbstractItemModel* loginHistoryProxyModel();


    void loadUsers();
    void loadLoginHistory();


private:
    Model_User             m_userModel;
    UserProxyModel         m_userProxy;
    EmployeeModel          m_employeeModel;
    LoginHistoryModel      m_loginHistoryModel;
    LoginHistoryProxyModel m_loginHistoryProxy;


private slots:
    void syncLoginHistoryFilter();

};

#endif // MODELMANAGER_H
