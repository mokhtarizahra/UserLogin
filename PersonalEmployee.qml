import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import "./component" 1.0


Item {
    id: root

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar
        Rectangle {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 250
            color: ThemeManager.currentTheme.sidebar
            layer.enabled: true
            layer.effect: DropShadow {
                color: "#40000000"
                radius: 10
                horizontalOffset: 3
                verticalOffset: 0
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 0

                // Header
                Text {
                    text: "Personal Panel"
                    font.family: ThemeManager.currentTheme.fontFamily
                    font.pixelSize: ThemeManager.currentTheme.fontSizeLarge
                    font.bold:  ThemeManager.currentTheme.fontBold
                    color: ThemeManager.currentTheme.sidebarText
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 30
                }

                // Menu Buttons

                // Spacer
                Item {
                    Layout.fillHeight: true
                }

                // Back Button
                ButtonStyle {
                    text: "Back"
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth : 180
                    implicitHeight: 40
                    onClicked: stackView.pop()
                }
            }
        }

        // Main Content Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: ThemeManager.currentTheme.mainArea

            GridLayout {
                anchors.fill: parent
                rows: 2

                ListViewStyle {
                    id: userlist
                    model:modelManager.userProxyModel
                    rowHeight: 60
                    Layout.row: 0
                    Layout.margins: 10
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

            }
        }
    }

}



