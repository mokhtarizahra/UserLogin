#ifndef GENERICITEM_H
#define GENERICITEM_H

#include <QVariant>
#include <QMap>
#include <QString>
#include <QTimer>
#include <QDebug>
#include <QDateTime>
#include <QObject>
#include <QJsonObject>
#include <QJsonArray>


class GenericItem : public QObject {
    Q_OBJECT
public:
    explicit GenericItem(const QMap<QString, QVariant> &data, QObject *parent = nullptr);
    ~GenericItem();

    QVariant get(const QString &key) const;
    void set(const QString &key, const QVariant &value);
    QMap<QString, QVariant> getAttributes() const;    

    void startTimer();
    void stopTimer();
    bool isTimerRunning() const;
    QJsonObject toJson() const;
    static GenericItem* fromJson(const QJsonObject& m_json);
    QJsonArray loginLogoutHistoryToJson() const    ;


signals:
    void dataChangedInternally();

private slots:
    void onTimerTick();

private:
    QMap<QString, QVariant> m_data;
    QVector<QMap<QString, QString>> m_loginLogoutHistory;
    QTimer *m_timer = nullptr;
    QDateTime m_startTime;
};

#endif // GENERICITEM_H
