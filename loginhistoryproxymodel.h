#ifndef LOGINHISTORYPROXYMODEL_H
#define LOGINHISTORYPROXYMODEL_H

#include <QSortFilterProxyModel>

class LoginHistoryProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QString userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString uniqueId READ uniqueId WRITE setUniqueId NOTIFY uniqueIdChanged)

public:
    explicit LoginHistoryProxyModel(QObject *parent = nullptr);

    QString userId() const;
    void setUserId(const QString &id);

    QString uniqueId() const;
    void setUniqueId(const QString &name);

    Q_INVOKABLE void refresh();

signals:
    void userIdChanged();
    void uniqueIdChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

private:
    QString m_userId;
    QString m_uniqueId;
};

#endif // LOGINHISTORYPROXYMODEL_H
