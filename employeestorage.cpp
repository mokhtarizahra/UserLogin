#include "employeestorage.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

EmployeeStorage::EmployeeStorage()
{
    QString resourceFile = ":/resources/employees.json";
    QString standardPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString targetFile = QDir(standardPath).filePath("employees.json");

    m_filePath = targetFile;

    if (!QFile::exists(targetFile)) {

        QFile inFile(resourceFile);
        if (!inFile.open(QIODevice::ReadOnly)) {
//            qWarning() << "Cannot open resource file!";
        } else {
            QFile outFile(targetFile);
            if (!outFile.open(QIODevice::WriteOnly)) {
//                qWarning() << "Cannot create target file!";
            } else {
                outFile.write(inFile.readAll());
                outFile.close();
//                qDebug() << "Resource copied successfully to " << targetFile;
            }
            inFile.close();
        }
    }

    QFile file(targetFile);
    if (!file.open(QIODevice::ReadOnly)) {
//        qWarning() << "Cannot open employees file:" << targetFile;
    } else {
        QByteArray data = file.readAll();
//        qDebug() << "Employees file loaded successfully, size:" << data.size();
        file.close();
    }

    load();
}
///////////////////////////////////////////////////////////////
void EmployeeStorage::load()
{
    m_employeeData = QJsonArray();

    QFile file(m_filePath);
    if (!file.open(QIODevice::ReadOnly)) {
//        qWarning() << "Cannot open employees file:" << m_filePath;
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
    file.close();

    if (!doc.isArray()) {
//        qWarning() << "Invalid JSON format in employees file!";
        return;
    }

    m_employeeData = doc.array();
}
/////////////////////////////////////////////////////////////
QJsonArray EmployeeStorage::getAllEmployees() const
{
    return m_employeeData;
}

/////////////////////////////////////////////////////////////
bool EmployeeStorage::isValidEmployeeId(const QString& id) const
{
    for (const auto& val : m_employeeData) {
        QJsonObject obj = val.toObject();
        if (obj["id"].toString() == id)
            return true;
    }
    return false;
}
