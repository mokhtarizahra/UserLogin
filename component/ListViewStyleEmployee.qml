import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import "." as Components

Control {
    id: root

    property alias model: listView.model
    property alias currentIndex: listView.currentIndex
    property alias count: listView.count
    property int rowHeight: 50
    property real col0Width: 60
    property real col1Width: 80
    property real col2Width: 80
    property real col3Width: 90
    property real col4Width: 120

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

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
                    model: ["Number", "Employee ID", "Employee Name", "Employee City", "Employee Position"]
                    AppLabel {
                        text: modelData
                        Layout.preferredWidth: [root.col0Width, root.col1Width, root.col2Width, root.col3Width, root.col4Width, root.col5Width][index]
                        centerAligned: true
                        Layout.margins: 2
                    }
                }
            }

        }


        // ListView
        ListView {
            id                                    : listView
            Layout.fillWidth                      : true
            Layout.fillHeight                     : true
            currentIndex                          : -1
            spacing                               : 5
            clip: true
            delegate                              : Rectangle {
                id                                : rowRect
                property bool  isHovered          : false
                scale                             : isHovered ? 1.001 : 1.0

                width                             : parent.width
                height                            : root.rowHeight
                color: listView.currentIndex === index ? ThemeManager.currentTheme.tableSelected
                                                       : (index % 2 === 0 ? ThemeManager.currentTheme.tableRowEven : ThemeManager.currentTheme.tableRowOdd)
                radius                            : 8
                border.color                      : ThemeManager.currentTheme.tableBorder
                border.width                      : 2
                anchors.margins                   : 5

                layer.enabled                     : true
                layer.effect                      : DropShadow {
                    horizontalOffset              : 2
                    verticalOffset                : 2
                    radius                        : 8
                    samples                       : 16
                    color                         : "#50000000"

                    GridLayout {
                        id                        : grid
                        anchors.fill              : parent
                        anchors.margins           : 10
                        columns                   : 6
                        rowSpacing                : 0
                        columnSpacing             : 0

                        AppLabel {
                            text           : (index + 1) + ". "
                            Layout.preferredWidth: root.col0Width
                            centerAligned: true
                            Layout.margins: 2
                        }
                        AppLabel {
                            text                   : model.id
                            centerAligned: true
                            Layout.preferredWidth: root.col1Width
                            Layout.margins: 2
                        }
                        AppLabel {
                            text                   : model.name
                            centerAligned: true
                            Layout.preferredWidth: root.col2Width
                            Layout.margins: 2
                        }

                        AppLabel {
                            text                   : model.city
                            centerAligned: true
                            Layout.preferredWidth: root.col3Width
                            Layout.margins: 2
                        }
                        AppLabel {
                            text                   : model.position
                            centerAligned: true
                            Layout.preferredWidth: root.col4Width
                            Layout.margins: 2
                        }
                    }

                }
                MouseArea { anchors.fill          : parent
                    hoverEnabled          : true
                    onEntered             : rowRect.isHovered = true
                    onExited              : rowRect.isHovered = false
                    onClicked             : listView.currentIndex = index
                    onDoubleClicked: {
                        const empId = model.id
                        listView.currentIndex = index
                        var proxy = modelManager.userProxyModel
                        if (proxy) {
                            proxy.employeeId = empId
                        }

                        stackView.push("qrc:/PersonalEmployee.qml")
                    }
                }
            }
        }
    }
}
