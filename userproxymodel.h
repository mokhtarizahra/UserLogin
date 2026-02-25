#ifndef USERPROXYMODEL_H
#define USERPROXYMODEL_H


#include <QSortFilterProxyModel>

class UserProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int userRow READ userRow WRITE setUserRow NOTIFY userRowChanged)
    Q_PROPERTY(QString employeeId READ employeeId WRITE setEmployeeId NOTIFY employeeIdChanged)



public:
    explicit UserProxyModel(QObject *parent = nullptr);

    int userRow() const;
    void setUserRow(int row);

    QString employeeId() const;
    void setEmployeeId(const QString &id);

protected:
    bool filterAcceptsRow(int sourceRow,
                          const QModelIndex &sourceParent) const override;

signals:
    void userRowChanged();
    void employeeIdChanged();


private:
    int m_userRow = -1;
    QString m_employeeId;
};

#endif // USERPROXYMODEL_H
