import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "." as Components

Control {
    id: root


    property alias text: field.text
    property alias placeholderText: field.placeholderText
    property color baseColor: ThemeManager.currentTheme.inputBase
    property color hoverColor: ThemeManager.currentTheme.inputFocus
    property int radius: 10

    contentItem: TextField {
        id: field
        font.family: ThemeManager.currentTheme.fontFamily
        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
        color: ThemeManager.currentTheme.inputText
        placeholderTextColor: ThemeManager.currentTheme.inputPlaceholder
        placeholderText: root.placeholderText

        background: Rectangle {
            radius: root.radius
            color: field.activeFocus ? root.hoverColor : root.baseColor
            border.color: field.activeFocus ? ThemeManager.currentTheme.buttonBase : "transparent"
            border.width: field.activeFocus ? 2 : 0
        }
    }

    DropShadow {
        anchors.fill: field
        horizontalOffset: 2
        verticalOffset: 3
        radius: 10
        samples: 16
        color: "#30000000"
        source: field
        visible: field.enabled
    }
}
