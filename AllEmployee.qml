import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "./component"


Item {
    anchors.fill: parent

    GridLayout {
        anchors.fill: parent
        rows: 2

        ListViewStyleEmployee {
            id: employeelist
            model: modelManager.employeeModel
            rowHeight: 60
            Layout.row: 0
            Layout.margins: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

    }




}
