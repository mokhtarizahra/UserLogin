#ifndef EMPLOYEEMODEL_H
#define EMPLOYEEMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include <QJsonObject>
#include <QJsonArray>


class EmployeeModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        NameRole,
        CityRole,
        PositionRole

    };

    explicit EmployeeModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariantMap getEmployeeById(const QString &id) const;

private:
    struct Employee {
        QString id;
        QString name;
        QString city;
        QString position;

    };

    QVector<Employee> m_employees;

    void loadFromStorage();
};

#endif
