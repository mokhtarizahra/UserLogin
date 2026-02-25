#ifndef LOGINHISTORYMODEL_H
#define LOGINHISTORYMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <QVariantMap>
#include <QSharedPointer>
#include <QDateTime>


class LoginHistoryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        UserIdRole = Qt::UserRole + 1,
        UniqueIdRole,
        LoginTimeRole,
        LogoutTimeRole,

    };

    explicit LoginHistoryModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadHistory();

    const QVector<QVariantMap>& histories() const { return m_histories; }


private:
    QVector<QVariantMap> m_histories;

    QString filePath() const;
};

#endif // LOGINHISTORYMODEL_H
