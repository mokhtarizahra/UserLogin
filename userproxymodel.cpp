#include "userproxymodel.h"
#include "model_user.h"

UserProxyModel::UserProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
}
///////////////////////////////////////////////////
int UserProxyModel::userRow() const
{
    return m_userRow;
}
///////////////////////////////////////////////////
void UserProxyModel::setUserRow(int row)
{
    if (m_userRow == row)
        return;

    m_userRow = row;
    invalidateFilter();
    emit userRowChanged();
}
///////////////////////////////////////////////////
QString UserProxyModel::employeeId() const
{
    return m_employeeId;
}
///////////////////////////////////////////////////
void UserProxyModel::setEmployeeId(const QString &id)
{
    if (m_employeeId == id)
        return;

    m_employeeId = id;
    invalidateFilter();
    emit employeeIdChanged();
}
///////////////////////////////////////////////////
bool UserProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!sourceModel())
           return false;

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

    if (m_userRow >= 0)
        return sourceRow == m_userRow;

    if (!m_employeeId.isEmpty()) {
        QVariant idData = sourceModel()->data(index, Model_User::UserIdRole);
        return idData.toString() == m_employeeId;
    }

    return true;
}
