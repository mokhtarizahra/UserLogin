#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "model_user.h"
#include "userstorage.h"
#include "userproxymodel.h"
#include "employeemodel.h"
#include "modelmanager.h"

#ifdef _DEBUG
    #define _CRTDBG_MAP_ALLOC
    #include <crtdbg.h>
#endif
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ModelManager modelManager;

    engine.rootContext()->setContextProperty("modelManager", &modelManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
