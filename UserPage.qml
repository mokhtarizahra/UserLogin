import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import Qt.labs.platform 1.1
import "./component"
import "./component" 1.0


Item {
    id: userpage

    property url userImageSource: "./Icons/UserIcon.png"
    property var userProxyModel: modelManager.userProxyModel
    property var loginHistoryModel: modelManager.loginHistoryProxyModel
    property int userRow: -1

    FileDialog {
        id: imagePicker
        title: "Select User Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]

        onAccepted: {
            userpage.userImageSource = file
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        //  Sidebar
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
                spacing: 10

                Text {
                    text: "User Panel"
                    font.family: ThemeManager.currentTheme.fontFamily
                    font.pixelSize: ThemeManager.currentTheme.fontSizeLarge
                    font.bold:  ThemeManager.currentTheme.fontBold
                    color: ThemeManager.currentTheme.sidebarText
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 30
                }

                // User Image
                Rectangle {
                    Layout.topMargin: 20
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20
                    Layout.fillWidth: true
                    height: 200
                    radius: 50
                    clip: true


                    color: ThemeManager.currentTheme.dialogImage
                    border.color: ThemeManager.currentTheme.dialogBorder
                    border.width: 1

                    Image {
                        anchors.centerIn: parent
                        source: userImageSource
                        fillMode: Image.PreserveAspectCrop
                        width: parent.width
                        height: parent.height
                        clip: true
                        smooth: true
                    }
                }

                ButtonStyle {
                    text: "Change Photo"
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 180
                    implicitHeight: 36

                    onClicked: imagePicker.open()
                }


                Rectangle {
                    Layout.topMargin: 15
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20
                    Layout.fillWidth: true
                    height: 130
                    radius: 20
                    color: ThemeManager.currentTheme.dialogBackground
                    border.color: ThemeManager.currentTheme.dialogBorder
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        ListView {
                            id: userInfoList
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            model: userProxyModel

                            delegate:Item {
                                width: ListView.view.width
                                height: ListView.view.height

                                GridLayout {
                                    id: infoGrid
                                    anchors.centerIn: parent

                                    columns: 2
                                    rowSpacing: 12
                                    columnSpacing: 8

                                    // Username
                                    Text {
                                        text: "Username:"
                                        font.family: ThemeManager.currentTheme.fontFamily
                                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                                        font.bold:  ThemeManager.currentTheme.fontBold
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 0
                                        Layout.row: 0
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Text {
                                        text: model.username
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 1
                                        Layout.row: 0
                                    }

                                    // User ID
                                    Text {
                                        text: "User ID:"
                                        font.family: ThemeManager.currentTheme.fontFamily
                                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                                        font.bold:  ThemeManager.currentTheme.fontBold
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 0
                                        Layout.row: 1
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Text {
                                        text: model.userid
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 1
                                        Layout.row: 1
                                    }

                                    Text {
                                        text: "User Password:"
                                        font.family: ThemeManager.currentTheme.fontFamily
                                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                                        font.bold:  ThemeManager.currentTheme.fontBold
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 0
                                        Layout.row: 2
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Text {
                                        text: model.password
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 1
                                        Layout.row: 2
                                    }

                                    // Active
                                    Text {
                                        text: "Active:"
                                        font.family: ThemeManager.currentTheme.fontFamily
                                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                                        font.bold:  ThemeManager.currentTheme.fontBold
                                        color: ThemeManager.currentTheme.dialogText
                                        Layout.column: 0
                                        Layout.row: 3
                                        horizontalAlignment: Text.AlignRight
                                    }

                                    Rectangle {
                                        width: 16
                                        height: 16
                                        radius: 8
                                        color: model.isActive ? "green" : "red"
                                        Layout.column: 1
                                        Layout.row: 3
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
                ButtonStyle {
                    text: "Edit UserName"
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 180
                    implicitHeight: 40

                    onClicked: {
                        if (userProxyModel.rowCount() === 0)
                            return

                        var proxyIndex = userProxyModel.index(0, 0)
                        if (!proxyIndex.valid) return

                        var sourceIndex = userProxyModel.mapToSource(proxyIndex)
                        dialog2.rowToEdit = sourceIndex.row
                        if (!sourceIndex.valid) return

                        var userData = modelManager.userModel.getUser(sourceIndex.row)
                        dialog2.nameFieldText = userData["username"] || ""
                        dialog2.passwordFieldText = userData["password"] || ""
                        console.log("Opening dialog, rowToEdit =", sourceIndex.row)

                        dialog2.open()
                    }
                }

                ButtonStyle {
                    text: "LogOut"
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth : 180
                    implicitHeight: 40
                    onClicked: {
                        var user = modelManager.userModel.getUser(userRow)
                        modelManager.userModel.logoutUser(user.username, user.userid)
                        userProxyModel.userRow = -1

                        stackView.pop()
                    }
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


        DialogStyle {
            id: dialog2
            title: "Edit Information User"
            width: mainWindow.width * 0.4
            height: mainWindow.height * 0.4
            x: (mainWindow.width - width) / 2
            y: (mainWindow.height - height) / 2

            onSaveRequested: {
                //                console.log("=== Save Clicked in Dialog ===")
                //                console.log("rowToEdit:", rowToEdit)
                //                console.log("New username:", nameFieldText)
                //                console.log("New password:", passwordFieldText)

                if (rowToEdit < 0) {
                    //                    console.log("Invalid row, cannot save!")
                    return
                }

                var success = modelManager.userModel.updateUser(
                            rowToEdit,
                            nameFieldText,
                            passwordFieldText
                            )

                if (success) {
                    //                    console.log("User updated successfully")
                } else {
                    //                    console.log("Failed to update user")
                }

                dialog2.close()
            }
        }


        //Main Area
        Rectangle {
            id: wrapper
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: ThemeManager.currentTheme.mainArea


            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                // Header
                Rectangle {
                    Layout.topMargin:10
                    Layout.leftMargin:10
                    Layout.rightMargin:  10
                    Layout.fillWidth: true
                    height: 50
                    color: ThemeManager.currentTheme.dialogRecLastTime
                    radius: 8
                    border.color: ThemeManager.currentTheme.dialogBorder
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        ListView {
                            id: timeInfoList
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            model: userProxyModel

                            delegate:Item {
                                width: parent.width
                                height: 20

                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 12

                                    Text { text: "Last Login Time:"
                                        font.family: ThemeManager.currentTheme.fontFamily
                                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                                        font.bold:  ThemeManager.currentTheme.fontBold
                                        color: ThemeManager.currentTheme.dialogRecLastTimeText
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter}
                                    Text {         text: Qt.formatDateTime(new Date(model.loginTime), "yyyy-MM-dd  -  hh:mm:ss")

                                        font.family: ThemeManager.currentTheme.fontFamily
                                        font.pixelSize: ThemeManager.currentTheme.fontSizeMedium
                                        font.bold:  ThemeManager.currentTheme.fontBold
                                        color: ThemeManager.currentTheme.dialogRecLastTimeText
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter}
                                }
                            }
                        }

                    }
                }

                // ListView
                ListViewStyleloginHistory {
                    id: userlist
                    model: loginHistoryModel
                    rowHeight: 60
                    Layout.topMargin:10
                    Layout.leftMargin:10
                    Layout.rightMargin:  10
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }



            }
        }
    }

}
