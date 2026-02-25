import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.12


Item {
    id: root
    property alias contentItem: contentLoader.sourceComponent
//    property int cardWidth: 300
//    property int cardHeight: 200
    property real radius: 12
    property real elevation: 10

//    width: cardWidth
//    height: cardHeight

    Rectangle {
        id: cardRect
        anchors.fill: parent
        color: ThemeManager.currentTheme.cardBackground
        border.color:ThemeManager.currentTheme.cardBorder
        radius: root.radius
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#40000000"
            radius: root.elevation
            horizontalOffset: 0
            verticalOffset: 2
        }

//        Column {
//            id: cardContent
//            anchors.fill: parent
//            anchors.margins: 16
//            spacing: 10

            Loader {
                id: contentLoader
                anchors.fill: parent
            }
        }
    }
//}
