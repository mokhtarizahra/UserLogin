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
    property string employeeName: ""
    property string employeePosition: ""

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


            GridLayout {
                id: mainGrid
                anchors.fill: parent
                columns: 6
                rows: 5
                rowSpacing: 20
                columnSpacing: 20
                anchors.margins: 20
                Layout.fillWidth: true
                Layout.fillHeight: true

                property int cardWidth: (mainGrid.width - (columns - 1) * columnSpacing) / columns
                property int cardHeight: (mainGrid.height - (rows - 1) * rowSpacing) / rows


                // User Image
                Card {
                    Layout.preferredWidth: mainGrid.cardWidth * 3 + mainGrid.columnSpacing * 2
                    Layout.fillHeight: true

                    Layout.column: 0
                    Layout.row: 0
                    Layout.rowSpan: 3
                    Layout.columnSpan: 3

                    contentItem:
                        ColumnLayout {
                        spacing: 8

                        Image {
                            source: userImageSource
                            fillMode: Image.PreserveAspectCrop
                            clip: true
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth: parent.width * 0.8
                            Layout.preferredHeight: Layout.preferredWidth
                        }

                        AppLabel {
                            text: employeeName
                            centerAligned: true
                        }
                        AppLabel {
                            text: employeePosition
                            centerAligned: true
                            fontSize: ThemeManager.currentTheme.fontSizeSmall

                        }

                        ButtonStyle {
                            text: "Change Photo"
                            Layout.alignment: Qt.AlignHCenter
                            implicitWidth: 180
                            implicitHeight: 30

                            onClicked: imagePicker.open()
                        }

                    }
                }

                // User Information
                Card {
                    Layout.preferredWidth: mainGrid.cardWidth * 3 + mainGrid.columnSpacing * 2
                    Layout.preferredHeight: mainGrid.cardHeight * 2 + mainGrid.rowSpacing

                    Layout.column: 3
                    Layout.row: 0
                    Layout.rowSpan: 2
                    Layout.columnSpan: 3

                    contentItem:

                        ColumnLayout {
                        Layout.margins: 5

                        ListViewStyleUserInfo{
                            id: userInfo
                            model: userProxyModel
                            Layout.topMargin: 10
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                // Last Login

                Card {
                    Layout.preferredWidth: mainGrid.cardWidth * 3 + mainGrid.columnSpacing * 2
                    Layout.preferredHeight: mainGrid.cardHeight
                    Layout.column: 3
                    Layout.row: 2
                    Layout.columnSpan: 3

                    contentItem:
                        ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: ThemeManager.currentTheme.itemUserInfo
                            radius: 8
                            border.color: ThemeManager.currentTheme.dialogBorder
                            border.width: 1

                            ListView {
                                anchors.fill: parent
                                model: userProxyModel
                                delegate: Item {
                                    width: ListView.view.width
                                    height: ListView.view.height


                                    RowLayout {
                                        spacing: 12
                                        anchors.centerIn: parent
                                        AppLabel {
                                            text: "Last Login Time:"
                                            centerAligned: true
                                        }
                                        AppLabel {
                                            text: Qt.formatDateTime(new Date(model.loginTime), "yyyy-MM-dd  -  hh:mm:ss")
                                            centerAligned: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                // Chart
                Card {
                    Layout.preferredWidth: mainGrid.cardWidth * 2 + mainGrid.columnSpacing
                    Layout.fillHeight: true

                    Layout.column: 0
                    Layout.row: 3
                    Layout.rowSpan: 2
                    Layout.columnSpan: 2

                }

                // ListView
                Card {
                    Layout.preferredWidth: mainGrid.cardWidth * 4 + mainGrid.columnSpacing * 3
                    Layout.fillHeight: true
                    Layout.column: 2
                    Layout.row: 3
                    Layout.rowSpan: 2
                    Layout.columnSpan: 4

                    contentItem:
                        ColumnLayout {
                        Layout.margins: 5

                        ListViewStyleloginHistory {
                            id: userlist
                            model: loginHistoryModel
                            rowHeight: 60
                            Layout.topMargin: 10
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }


            }
        }
    }

}
