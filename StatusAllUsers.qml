import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "./component"


Item {
    anchors.fill: parent

    GridLayout {
        anchors.fill: parent
        rows: 2

        ListViewStyle {
            id: userlist
            model: modelManager.userModel
            rowHeight: 60
            Layout.row: 0
            Layout.margins: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.row: 1
            Layout.fillWidth: true
            spacing: 10
            Layout.margins: 10

            ButtonStyle {
                text: "Clear Users"
                implicitWidth : 180
                implicitHeight: 50
                enabled: userlist.count > 0
                onClicked: modelManager.userModel.clear()
            }

            ButtonStyle {
                text: "Remove User"
                implicitWidth : 180
                implicitHeight: 50
                enabled: userlist.count > 0 && userlist.currentIndex >= 0
                onClicked: {
                    modelManager.userModel.removeUser(userlist.currentIndex)
                }
            }


            Item { Layout.fillWidth: true }

        }
    }




}
