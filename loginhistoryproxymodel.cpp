#include "loginhistoryproxymodel.h"
#include "loginhistorymodel.h"

LoginHistoryProxyModel::LoginHistoryProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
}
/////////////////////////////////////////////////////////
QString LoginHistoryProxyModel::userId() const
{
    return m_userId;
}
/////////////////////////////////////////////////////////
void LoginHistoryProxyModel::setUserId(const QString &id)
{
    if (m_userId == id)
        return;

    m_userId = id;
    invalidateFilter();
    emit userIdChanged();
}
/////////////////////////////////////////////////////////
QString LoginHistoryProxyModel::uniqueId() const
{
    return m_uniqueId;
}
/////////////////////////////////////////////////////////
void LoginHistoryProxyModel::setUniqueId(const QString &name)
{
    if (m_uniqueId == name)
        return;

    m_uniqueId = name;
    invalidateFilter();
    emit uniqueIdChanged();
}
/////////////////////////////////////////////////////////
bool LoginHistoryProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!sourceModel())
        return false;

    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

    if (m_userId.isEmpty() && m_uniqueId.isEmpty())
        return true;

    QVariant idData = sourceModel()->data(index, LoginHistoryModel::UserIdRole);
    QVariant uniqueIdData = sourceModel()->data(index, LoginHistoryModel::UniqueIdRole);

    bool idMatches = m_userId.isEmpty() || (idData.toString() == m_userId);
    bool uniqueIdMatches = m_uniqueId.isEmpty() || (uniqueIdData.toString() == m_uniqueId);

    return idMatches && uniqueIdMatches;
}
/////////////////////////////////////////////////////////
 void LoginHistoryProxyModel::refresh() {
      invalidateFilter();
  }
