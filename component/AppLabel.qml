import QtQuick 2.12
import QtQuick.Layouts 1.12

Text {
    id: root
    property bool rightAligned: false
    property bool centerAligned: false

    property int  fontSize: ThemeManager.currentTheme.fontSizeMedium

    font.family: ThemeManager.currentTheme.fontFamily
    font.pixelSize: fontSize
    font.bold: ThemeManager.currentTheme.fontBold
    color: ThemeManager.currentTheme.dialogText

    horizontalAlignment: centerAligned ? Text.AlignHCenter
                        : rightAligned ? Text.AlignRight
                        : Text.AlignLeft

    Layout.alignment: centerAligned ? Qt.AlignHCenter | Qt.AlignVCenter
                      : rightAligned ? Qt.AlignRight | Qt.AlignVCenter
                      : Qt.AlignLeft | Qt.AlignVCenter
}
