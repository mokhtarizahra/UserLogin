import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Control {
    id: root


    property alias model: listView.model
    property alias currentIndex: listView.currentIndex
    property alias count: listView.count
    property int rowHeight: 300

    ColumnLayout {
        anchors.fill: parent
        spacing: 5


        // ListView
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: -1
            spacing: 5
            clip: true
            delegate:
                Rectangle {
                id: rowRect
                width: parent.width
                height: root.rowHeight
                color: "transparent"
                radius: 8
                border.color: ThemeManager.currentTheme.tableBorder
                border.width: 2

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 2
                    verticalOffset: 2
                    radius: 8
                    samples: 16
                    color: "#50000000"
                }

                ColumnLayout  {
                    anchors.fill: parent
                    anchors.margins: 10

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        color: ThemeManager.currentTheme.tableRowOdd

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            AppLabel {
                                text: "User Name:"
                                Layout.preferredWidth: 120
                            }

                            AppLabel {
                                text: username
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        color: ThemeManager.currentTheme.tableRowEven

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            AppLabel {
                                text: "User ID:"
                                Layout.preferredWidth: 120
                            }

                            AppLabel {
                                text: userid
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        color: ThemeManager.currentTheme.tableRowOdd

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            AppLabel {
                                text: "Password:"
                                Layout.preferredWidth: 120
                            }

                            AppLabel {
                                text: password
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        color: ThemeManager.currentTheme.tableRowEven

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            AppLabel {
                                text: "Active:"
                                Layout.preferredWidth: 120
                            }

                            Item {
                                Layout.fillWidth: true

                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: isActive ? "lightgreen" : "indianred"
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        radius: 8
                        color: ThemeManager.currentTheme.tableRowOdd

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            AppLabel {
                                text: "Timer Login:"
                                Layout.preferredWidth: 120
                            }

                            AppLabel {
                                text: duration
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}
