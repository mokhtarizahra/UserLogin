#include "genericitem.h"

GenericItem::GenericItem(const QMap<QString, QVariant> &data, QObject *parent)
    : QObject(parent),
      m_data(data)
{

    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &GenericItem::onTimerTick);

    if (m_data.value("isActive").toBool()) {
            startTimer();
        }

}

///////////////////////////////////////////////////
GenericItem::~GenericItem() {
    if (m_timer) {
        m_timer->stop();
        m_timer->deleteLater();
    }
}

///////////////////////////////////////////////////
QVariant GenericItem::get(const QString &key) const
{
    if (key == "isActive") {
        return m_data.value("isActive");
    }
    if (key == "loginTime") {
        return m_data.value("loginTime");
    }
    return m_data.value(key);
}

///////////////////////////////////////////////////
void GenericItem::set(const QString &key, const QVariant &value)
{
//    qDebug() << "GenericItem::set called with key =" << key << "value =" << value;

    if (key == "loginTime") {

        m_data["loginTime"] = value;
        m_data["logoutTime"] = "";

    } else if (key == "logoutTime") {
        QString loginStr = m_data.value("loginTime").toString();
        QString logoutStr = value.toString();

        if (!loginStr.isEmpty() && !logoutStr.isEmpty()) {
            QMap<QString, QString> entry;
            entry["loginTime"] = loginStr;
            entry["logoutTime"] = logoutStr;

            if (m_loginLogoutHistory.isEmpty()) {
//                qDebug() << "History empty, adding entry:" << entry;
                m_loginLogoutHistory.append(entry);
            } else if (m_loginLogoutHistory.last() != entry) {
//                qDebug() << "Last history entry different, adding entry:" << entry;
                m_loginLogoutHistory.append(entry);
            } else {
//                qDebug() << "Duplicate entry detected, not adding:" << entry;
            }
        }

        m_data["logoutTime"] = value;

    } else {
        m_data[key] = value;

        if (key == "isActive") {
            if (value.toBool()) startTimer();
            else stopTimer();
        }
    }

    emit dataChangedInternally();
}


///////////////////////////////////////////////////
QMap<QString, QVariant> GenericItem::getAttributes() const
{
    return m_data;
}
///////////////////////////////////////////////////
void GenericItem::startTimer()
{
    if (!m_timer->isActive()) {

        if (m_data.contains("duration")) {
            m_startTime = QDateTime::currentDateTime()
                              .addSecs(-m_data["duration"].toLongLong());
        } else {
            m_startTime = QDateTime::currentDateTime();
            m_data["duration"] = 0;
        }

        m_timer->start();
    }

}


///////////////////////////////////////////////////
void GenericItem::stopTimer()
{
    m_timer->stop();
}

///////////////////////////////////////////////////
bool GenericItem::isTimerRunning() const
{
    return m_timer->isActive();
}

///////////////////////////////////////////////////
void GenericItem::onTimerTick()
{
    QDateTime current = QDateTime::currentDateTime();
    qint64 durationSeconds = m_startTime.secsTo(current);

    m_data["duration"] = durationSeconds;
    emit dataChangedInternally();

}
///////////////////////////////////////////////////
QJsonObject GenericItem::toJson() const{
    QJsonObject m_json;

    for (auto i = m_data.constBegin(); i != m_data.constEnd(); ++i) {
        m_json[i.key()] = QJsonValue::fromVariant(i.value());
    }

    return m_json;
}
///////////////////////////////////////////////////
GenericItem* GenericItem::fromJson(const QJsonObject& m_json)
{
    QMap<QString, QVariant> data;

    for (auto i = m_json.begin(); i != m_json.end(); ++i)
        data[i.key()] = i.value().toVariant();

    return new GenericItem(data, nullptr);
}
///////////////////////////////////////////////////
QJsonArray GenericItem::loginLogoutHistoryToJson() const
{
    QJsonArray historyArray;

//    qDebug() << "Converting login/logout history to JSON, entries:" << m_loginLogoutHistory.size();

    for (const auto &entry : m_loginLogoutHistory) {
        QJsonObject obj;
        for (auto it = entry.constBegin(); it != entry.constEnd(); ++it) {
            obj[it.key()] = it.value();
        }
        historyArray.append(obj);
    }

//    qDebug() << "Generated JSON array:" << historyArray;
    return historyArray;
}
///////////////////////////////////////////////////
