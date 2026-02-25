import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import "./component" 1.0
import "./component"



Item {
    id                             : root
    property string nameFieldText  : ""
    property string errorMessage   : ""
    property string passwordText   : ""
    property int    currentUserRow : -1
    property bool   showError      : false
    signal          loginRequested(string username, string userId)
    signal          canceled()

    function resetFields() {
        nameFieldText = ""
        passwordText = ""
        errorMessage  = ""
        showError     = false
        currentUserRow = -1
    }

    Component.onCompleted: {
        resetFields()
    }

    onVisibleChanged: {
        if (visible) {
            resetFields()
        }
    }

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
                    text: "User Login Panel"
                    font.family: ThemeManager.currentTheme.fontFamily
                    font.pixelSize: ThemeManager.currentTheme.fontSizeLarge
                    font.bold:  ThemeManager.currentTheme.fontBold
                    color: ThemeManager.currentTheme.sidebarText
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 30
                }

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

        // Main Area
        Rectangle {
            id: wrapper
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: ThemeManager.currentTheme.mainArea

            Column {
                anchors.centerIn: parent
                spacing: 15

                // Title
                Text {
                    text: "User Login"
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


                        TextFieldStyle {
                            placeholderText: "User Name"
                            text: root.nameFieldText
                            onTextChanged: root.nameFieldText = text
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.75
                            height: 40
                        }

                        TextFieldStyle {
                            placeholderText: "Password"
                            text: root.passwordText
                            onTextChanged: root.passwordText = text
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.75
                            height: 40
                        }

                        Item {
                            width: 1
                            height: 10 }

                        ButtonStyle {
                            text: "Login"
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.6
                            height: 35
                            onClicked: {
                                root.showError = false
                                var row = modelManager.userModel.loginUser( root.nameFieldText,root.passwordText)

                                if (row >= 0) {
                                    root.currentUserRow = row
                                    modelManager.userProxyModel.userRow = row
                                    var user = modelManager.userModel.getUser(row)
                                    modelManager.loginHistoryProxyModel.userId = user.userid
                                    var emp = modelManager.employeeModel.getEmployeeById(user.userid)
                                    var empName = emp["name"]
                                    var empPosition = emp["position"]
                                    stackView.push("UserPage2.qml")
                                    stackView.currentItem.userRow = row
                                    stackView.currentItem.employeeName = empName
                                    stackView.currentItem.employeePosition = empPosition

                                    root.nameFieldText = ""
                                    root.passwordText = ""
                                }
                            }
                        }

                        ButtonStyle {
                            text: "Sign Up"
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.6
                            height: 35
                            onClicked: {
                                stackView.push("Sign_up.qml")
                            }
                        }

                        Label {
                            text: root.errorMessage
                            visible: root.showError
                            color: ThemeManager.currentTheme.accentHighlight
                            horizontalAlignment: Text.AlignHCenter
                               width: parent.width - 40
                               anchors.horizontalCenter: parent.horizontalCenter
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


    Connections {
        target                    : modelManager.userModel
        onLoginFailed             : function(message) {
            root.errorMessage = message
            root.showError = true
        }
    }

}
