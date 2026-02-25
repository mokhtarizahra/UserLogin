#ifndef EMPLOYEESTORAGE_H
#define EMPLOYEESTORAGE_H

#include <QString>
#include <QJsonArray>

class EmployeeStorage
{
public:
    EmployeeStorage();

    bool isValidEmployeeId(const QString& id) const;
    QJsonArray getAllEmployees() const;

private:
    QJsonArray m_employeeData;
    QString m_filePath;

    void load();
};

#endif // EMPLOYEESTORAGE_H
