import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: root

    modal: true
    property int rowToEdit: -1
    property string title: "Edit Information"

    property alias nameFieldText     : nameField.text
    property alias passwordFieldText : passwordField.text

    property alias okButtonText       : okBtn.text
    property alias cancelButtonText   : cancelBtn.text

    property string errorMessage : ""
    property bool   showError    : false

    signal saveRequested()
    signal canceled()

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

//    background: Rectangle {
//        radius: 12
//        color: ThemeManager.currentTheme.dialogText
//    }

    contentItem: Rectangle {
        anchors.fill: parent
        color: ThemeManager.currentTheme.dialogBackground

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 16
            width: parent.width * 0.9

            // Title
            Label {
                text: root.title
                font.family: ThemeManager.currentTheme.fontFamily
                font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                font.bold:  ThemeManager.currentTheme.fontBold
                color: ThemeManager.currentTheme.dialogText
                Layout.alignment: Qt.AlignHCenter
            }

//            // Username
            TextFieldStyle {
                id: nameField
                placeholderText: "User Name"
                Layout.fillWidth: true
            }

            // Password
            TextFieldStyle {
                id: passwordField
                placeholderText: "Password"
//                echoMode: TextInput.Password
                Layout.fillWidth: true
            }

            // Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Item { Layout.fillWidth: true }

                ButtonStyle {
                    id: okBtn
                    text: "Save"
                    implicitWidth : 180
                    implicitHeight: 40
                    onClicked: root.saveRequested()
                }

                ButtonStyle {
                    id: cancelBtn
                    text: "Cancel"
                    implicitWidth : 180
                    implicitHeight: 40
                    onClicked: {
                        root.canceled()
                        root.close()
                    }
                }
            }

            // Error Message
            Label {
                text: root.errorMessage
                visible: root.showError
                color: "red"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
