#include "modelmanager.h"
#include <QDebug>

ModelManager::ModelManager(QObject *parent)
    : QObject(parent)
{
//    qDebug() << "ModelManager: initializing...";

    m_userProxy.setSourceModel(&m_userModel);
    m_loginHistoryProxy.setSourceModel(&m_loginHistoryModel);
    connect(&m_userProxy, &UserProxyModel::userRowChanged,
                this, &ModelManager::syncLoginHistoryFilter);


    connect(&m_userModel, &Model_User::userDataChanged,
               this, [this]() {
                   m_loginHistoryModel.loadHistory();
                   m_loginHistoryProxy.refresh();
               });

    loadUsers();
    loadLoginHistory();

//    qDebug() << "ModelManager: initialization done.";
}

//////////////////////////////////////////////////////////
void ModelManager::loadUsers()
{
//    qDebug() << "ModelManager: loading users from storage...";
    UserStorage storage;

    QList<QSharedPointer<GenericItem>> list = storage.load();
    QVector<QSharedPointer<GenericItem>> users = QVector<QSharedPointer<GenericItem>>::fromList(list);

    m_userModel.setUsers(users);

//    qDebug() << "ModelManager: users set in userModel.";
}

//////////////////////////////////////////////////////////
void ModelManager::loadLoginHistory()
{
//    qDebug() << "ModelManager: loading login history...";
    m_loginHistoryModel.loadHistory();
//    qDebug() << "ModelManager: login history loaded. Total entries:" << m_loginHistoryModel.rowCount();
}

QAbstractItemModel* ModelManager::userModel() { return &m_userModel; }
QAbstractItemModel* ModelManager::userProxyModel() { return &m_userProxy; }
QAbstractItemModel* ModelManager::employeeModel() { return &m_employeeModel; }
QAbstractItemModel* ModelManager::loginHistoryModel() { return &m_loginHistoryModel; }
QAbstractItemModel* ModelManager::loginHistoryProxyModel() { return &m_loginHistoryProxy; }

QAbstractItemModel* ModelManager::model(const QString &name)
{
    if (name == "model_user")        return userModel();
    if (name == "userProxy")         return userProxyModel();
    if (name == "employees")         return employeeModel();
    if (name == "loginHistory")      return loginHistoryModel();
    if (name == "loginHistoryProxy") return loginHistoryProxyModel();

//    qWarning() << "ModelManager: requested model not found:" << name;
    return nullptr;
}

////////////////////////////////////////////////////////////
void ModelManager::syncLoginHistoryFilter()
{
    int row = m_userProxy.userRow();

    if (row >= 0 && row < m_userModel.rowCount()) {
        QModelIndex idx = m_userModel.index(row, 0);
        QString userId = m_userModel.data(idx, Model_User::UserIdRole).toString();
        QString uniqueId = m_userModel.data(idx, Model_User::UniqueIdRole).toString();

        m_loginHistoryProxy.setUserId(userId);
        m_loginHistoryProxy.setUniqueId(uniqueId);
    } else {
        m_loginHistoryProxy.setUserId("");
        m_loginHistoryProxy.setUniqueId("");
    }
}
