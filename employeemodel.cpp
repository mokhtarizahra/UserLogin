#include "employeemodel.h"
#include "employeestorage.h"

EmployeeModel::EmployeeModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadFromStorage();
}

void EmployeeModel::loadFromStorage()
{
    beginResetModel();
    m_employees.clear();

    EmployeeStorage storage;
    QJsonArray arr = storage.getAllEmployees();

    for (const auto &val : arr) {
        QJsonObject obj = val.toObject();

        Employee e;
        e.id       = obj["id"].toString();
        e.name     = obj["name"].toString();
        e.city     = obj["city"].toString();
        e.position = obj["position"].toString();


        m_employees.append(e);
    }

    endResetModel();
}

int EmployeeModel::rowCount(const QModelIndex &) const
{
    return m_employees.size();
}

QVariant EmployeeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_employees.size())
        return {};

    const Employee &e = m_employees.at(index.row());

    switch (role) {
    case IdRole:       return e.id;
    case NameRole:     return e.name;
    case CityRole:     return e.city;
    case PositionRole: return e.position;

    default:       return {};
    }
}

QHash<int, QByteArray> EmployeeModel::roleNames() const
{
    return {
        { IdRole,       "id" },
        { NameRole,     "name" },
        { CityRole,     "city" },
        { PositionRole, "position" }

    };
}

QVariantMap EmployeeModel::getEmployeeById(const QString &id) const
{
    for (const auto &e : m_employees) {
        if (e.id == id) {
            return {
                { "id",       e.id },
                { "name",     e.name },
                { "city",     e.city },
                { "position", e.position }

            };
        }
    }
    return {};
}
