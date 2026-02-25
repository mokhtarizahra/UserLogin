import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import "./component" 1.0



Item {
    id: root

    property string newId: ""
    property string newUsername: ""
    property string newPassword: ""
    property string errorMessage: ""
    property bool showError: false

    signal backRequested()

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

                Text {
                    text: "Sign Up Panel"
                    font.family: ThemeManager.currentTheme.fontFamily
                    font.pixelSize: ThemeManager.currentTheme.fontSizeLarge
                    font.bold:  ThemeManager.currentTheme.fontBold
                    color: ThemeManager.currentTheme.sidebarText
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 30
                }

                Item { Layout.fillHeight: true }

                ButtonStyle {
                    text: "Back"
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth : 180
                    implicitHeight: 40
                    onClicked: stackView.pop()
                }
            }
        }

        // Main Content
        Rectangle {
            id: wrapper
            Layout.fillHeight: true
            Layout.fillWidth: true
            radius: 12
            color: ThemeManager.currentTheme.mainArea

            Column {
                anchors.centerIn: parent
                spacing: 15

                // Title
                Text {
                    text: "User Registration"
                    font.family: ThemeManager.currentTheme.fontFamily
                    font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                    font.bold:  ThemeManager.currentTheme.fontBold
                    color: ThemeManager.currentTheme.mainAreaText
                    horizontalAlignment: Text.AlignHCenter
                    width: loginBox.width
                }

                // Login Box
                Rectangle {
                    id: loginBox
                    width: 360
                    radius: 12
                    color: ThemeManager.currentTheme.logincard

                    Column {
                        id: contentColumn
                        anchors.centerIn: parent
                        width: parent.width
                        spacing: 20

                        Item {
                            width: 1
                            height: 10 }

                        //id
                        TextFieldStyle {
                            id: employeeIdField
                            placeholderText: "Employee ID"
                            text: root.newId
                            onTextChanged: {
                                root.newId = text
                                var valid = modelManager.userModel.isValidEmployeeId(text)
                                idErrorLabel.visible = !valid
                                usernameField.enabled = valid
                                passwordField.enabled = valid
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.75
                            height: 40
                        }

                        Label {
                            id: idErrorLabel
                            text: "Invalid Employee ID"
                            visible: false
                            color: ThemeManager.currentTheme.accentHighlight
                            horizontalAlignment: Text.AlignHCenter
                               width: parent.width - 40
                               anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Username
                        TextFieldStyle {
                            id: usernameField
                            placeholderText: "Username"
                            text: root.newUsername
                            onTextChanged: {
                                root.newUsername = text
                                var valid = modelManager.userModel.isUsernameAvailable(text)
                                idErrorLabelUser.visible = !valid
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            enabled: false
                            width: parent.width * 0.75
                            height: 40
                        }

                        Label {
                            id: idErrorLabelUser
                            text: "Username already exists"
                            visible: false
                            color: ThemeManager.currentTheme.accentHighlight
                            horizontalAlignment: Text.AlignHCenter
                               width: parent.width - 40
                               anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // Password
                        TextFieldStyle {
                            id: passwordField
                            placeholderText: "Password"
                            text: root.newPassword
                            anchors.horizontalCenter: parent.horizontalCenter
                            onTextChanged: root.newPassword = text
                            enabled: false
                            width: parent.width * 0.75
                            height: 40
                        }

                        // Error Label
                        Label {
                            text: root.errorMessage
                            visible: root.showError
                            color: "red"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        // Buttons

                        ButtonStyle {
                            text: "Register"
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.6
                            height: 35
                            onClicked: {
                                //  ID
                                if (!modelManager.userModel.isValidEmployeeId(root.newId)) {
                                    root.errorMessage = "Invalid Employee ID"
                                    root.showError = true
                                    return
                                }

                                //  Username
                                var duplicate = false
                                for (var i = 0; i < modelManager.userModel.count; i++) {
                                    if (modelManager.userModel.get(i).username === root.newUsername) {
                                        duplicate = true
                                        break
                                    }
                                }

                                if (duplicate) {
                                    root.errorMessage = "Username already exists"
                                    root.showError = true
                                    return
                                }

                                var data = {
                                    "userid": root.newId,
                                    "username": root.newUsername,
                                    "password": root.newPassword,
                                    "isActive": false,
                                    "loginTime": "",
                                    "logoutTime": "",
                                    "duration": 0
                                }
                                modelManager.userModel.createItem(data)

                                root.newId = ""
                                root.newUsername = ""
                                root.newPassword = ""
                                root.showError = false
                                stackView.pop()
                            }
                        }

                        Item {
                            width: 1
                            height: 10 }
                    }
                    height: contentColumn.implicitHeight + 24

                }
            }
        }
    }
}
