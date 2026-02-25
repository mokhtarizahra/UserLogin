import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12


Control {
    id: root

    property color baseColor    : "#b6edf4"
    property color hoverColor   : "#f7f7f7"
    property color textColor    : "black"
    property int   radius       : 10
    property alias currentIndex : comboBox.currentIndex
    property alias model        : comboBox.model

    contentItem: ComboBox {
        id                      : comboBox
        anchors.fill            : parent
        font.family: ThemeManager.currentTheme.fontFamily
        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
        font.bold:  ThemeManager.currentTheme.fontBold
        background              : Rectangle {
            radius              : root.radius
            color               : comboBox.hovered || comboBox.activeFocus ? root.hoverColor : root.baseColor
            border.color        : "black"
            border.width        : 2
        }

        delegate                : ItemDelegate {
            width               : comboBox.width
            text                : modelData
            font.family: ThemeManager.currentTheme.fontFamily
            font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
            font.bold:  root.ThemeManager.currentTheme.fontBold

            background          : Rectangle {
                anchors.fill    : parent
                radius          : 10
                color           : hovered ? root.hoverColor
                                : checked ? "#4a90e2"
                                : root.baseColor
            }

        }

    }
    DropShadow {
        anchors.fill           : comboBox
        horizontalOffset       : 2
        verticalOffset         : 3
        radius                 : 10
        samples                : 16
        color                  : "#50000000"
        source                 : comboBox
        visible                : comboBox.enabled
    }
}
