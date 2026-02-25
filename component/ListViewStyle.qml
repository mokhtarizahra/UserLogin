import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

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
    property real col4Width: 90
    property real col5Width: 120

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
                    model: ["Number", "User Name", "User ID", "Status Login", "Timer Login", "Login & Logout"]
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
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: -1
            spacing: 5
            clip: true
            delegate: Rectangle {
                id: rowRect
                property bool isHovered: false
                scale: isHovered ? 1.001 : 1.0

                width: parent.width
                height: root.rowHeight
                color: listView.currentIndex === index ? ThemeManager.currentTheme.tableSelected
                     : (index % 2 === 0 ? ThemeManager.currentTheme.tableRowEven : ThemeManager.currentTheme.tableRowOdd)
                radius: 8
                border.color: ThemeManager.currentTheme.tableBorder
                border.width: 2
                anchors.margins: 5

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
                    columns: 6
                    rowSpacing: 0
                    columnSpacing: 0

                    //  1: Number
                    AppLabel {
                        text: (index + 1) + ". "
                        Layout.preferredWidth: root.col0Width
                        centerAligned: true
                        Layout.margins: 2
                    }

                    //  2: User Name
                    AppLabel {
                        text: model.username
                        Layout.preferredWidth: root.col1Width
                        centerAligned: true
                        Layout.margins: 2
                    }

                    //  3: User ID
                    AppLabel {
                        text: model.userid
                        Layout.preferredWidth: root.col2Width
                        centerAligned: true
                        Layout.margins: 2
                    }

                    // 4: Status Login
                    RowLayout {
                        Layout.preferredWidth: root.col3Width
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 5

                        AppLabel {
                            text: "Active:"
                            centerAligned: true
                        }

                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: model.isActive ? "lightgreen" : "indianred"
                        }
                    }

                    //  5: Timer Login → model.duration
                    AppLabel {
                        text: model.duration
                        Layout.preferredWidth: root.col4Width
                        centerAligned: true
                        Layout.margins: 2
                    }

                    //  6: Login & Logout
                    AppLabel {
                        text: "Login:  " + Qt.formatDateTime(new Date(model.loginTime), "yyyy-MM-dd  -  hh:mm:ss") +
                                  "\nLogout: " + (model.logoutTime ? Qt.formatDateTime(new Date(model.logoutTime), "yyyy-MM-dd  -  hh:mm:ss") : "-")
                        Layout.preferredWidth: root.col5Width
                        centerAligned: true
                        Layout.margins: 2
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: rowRect.isHovered = true
                    onExited: rowRect.isHovered = false
                    onClicked: listView.currentIndex = index
                }
            }
        }    }
}
