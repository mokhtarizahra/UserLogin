import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

Control {
    id: root
    property int   radius:      12
    property alias text:        btn.text
    property bool  disabled:    false

    signal clicked()

    width:  btn.implicitWidth  + 40
    height: btn.implicitHeight + 40

    contentItem: Button {
        id: btn
        enabled: !root.disabled
        anchors.centerIn: parent

        background: Rectangle {
            radius: root.radius
            color: !btn.enabled ? root.ThemeManager.currentTheme .buttonDisabled
                 : btn.down     ? Qt.darker(root.ThemeManager.currentTheme .buttonBase, 1.2)
                 : btn.hovered  ? root.ThemeManager.currentTheme .buttonHover
                 : root.ThemeManager.currentTheme .buttonBase

            border.width: 1
            border.color: btn.hovered ? Qt.lighter(ThemeManager.currentTheme.buttonBorder, 1.3)
                                       : Qt.darker(ThemeManager.currentTheme.buttonBorder, 0.8)
}

        contentItem: Text {
            text: btn.text
            font.family: ThemeManager.currentTheme.fontFamily
            font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
            font.bold:  ThemeManager.currentTheme.fontBold
            color: root.ThemeManager.currentTheme .buttonText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        onClicked: root.clicked()
    }

    DropShadow {
        anchors.fill: btn
        horizontalOffset: 2
        verticalOffset: 3
        radius: 12
        samples: 16
        color: "#40000000"
        source: btn
        visible: btn.enabled && !btn.down
    }
}
