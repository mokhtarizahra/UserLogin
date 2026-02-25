// GenericTableView.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Control {
    id: root

    property var model
    property int rowHeight: 50
    property int currentIndex: -1

    property var columns: []

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 70
            radius: 10
            color: ThemeManager.currentTheme.tableHeader
            border.color: ThemeManager.currentTheme.tableBorder
            border.width: 2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Repeater {
                    model: root.columns
                    Text {
                        text: modelData.header
                        font.family: ThemeManager.currentTheme.fontFamily
                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium + 2
                        font.bold: ThemeManager.currentTheme.fontBold
                        Layout.preferredWidth: modelData.width
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: ThemeManager.currentTheme.tableText
                    }
                }
            }
        }

        // ListView
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            currentIndex: root.currentIndex
            spacing: 5
            clip: true

            delegate: Rectangle {
                id: rowRect
                width: parent.width
                height: root.rowHeight
                radius: 8
                border.color: ThemeManager.currentTheme.tableBorder
                border.width: 2
                anchors.margins: 5
                color: listView.currentIndex === index ? ThemeManager.currentTheme.tableSelected
                     : (index % 2 === 0 ? ThemeManager.currentTheme.tableRowEven : ThemeManager.currentTheme.tableRowOdd)

                property bool isHovered: false
                scale: isHovered ? 1.01 : 1.0

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 8
                    samples: 16
                    color: "#50000000"
                }

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    columns: root.columns.length
                    rowSpacing: 0
                    columnSpacing: 0

                    Repeater {
                        model: root.columns
                        Text {
                            text: modelData.role === "rowNumber" ? (index + 1) + ". " :
                                  modelData.type === "datetime" ? Qt.formatDateTime(new Date(model[modelData.role]), "yyyy-MM-dd - hh:mm:ss") :
                                  model[modelData.role] !== undefined ? model[modelData.role] : "-"
                            font.family: ThemeManager.currentTheme.fontFamily
                            font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                            font.bold: ThemeManager.currentTheme.fontBold
                            Layout.preferredWidth: modelData.width
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: ThemeManager.currentTheme.tableText
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: rowRect.isHovered = true
                    onExited: rowRect.isHovered = false
                    onClicked: listView.currentIndex = index
                    onDoubleClicked: {
                        if (root.onRowDoubleClicked) root.onRowDoubleClicked(index, model)
                    }
                }
            }
        }
    }

    signal onRowDoubleClicked(int index, var rowData)
}
