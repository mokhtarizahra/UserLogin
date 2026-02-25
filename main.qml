import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "./component" 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: Math.min(Screen.width * 0.9, 1400)
    height: Math.min(Screen.height * 0.8, 1000)
    title: qsTr("Main Page")


    background: Rectangle { color: ThemeManager.currentTheme.surface }

    ButtonStyle2 {
        text: ThemeManager.mode === "dark" ? " Light Mode" : " Dark Mode"
        iconSource: ThemeManager.mode === "dark"
                    ? "qrc:/Icons/icons8-sun.png"
                    : "qrc:/Icons/icons8-moon.png"

        anchors {
            top: parent.top
            right: parent.right
            margins: 20
        }
        width: 140
        height: 40

        onClicked: ThemeManager.toggleTheme()
    }


    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homePage

        onCurrentItemChanged: {
            if (!currentItem) return

            if (currentItem.loginSuccess !== undefined) {
                currentItem.loginSuccess.connect(function() {
                    stackView.pop()
                })
            }
            if (currentItem.canceled !== undefined) {
                currentItem.canceled.connect(function() {
                    stackView.pop()
                })
            }
        }
    }

    Component {
        id: homePage
        Item {
            Column {
                anchors.centerIn: parent
                spacing: 20

                ButtonStyle {
                    text: "Enter Manager"
                    width: 200
                    height: 50
                    radius: 12
                    onClicked: stackView.push("ManagerPage.qml")
                }

                ButtonStyle {
                    text: "Enter User"
                    width: 200
                    height: 50
                    radius: 12
                    onClicked: stackView.push("LoginPage.qml")
                }
            }
        }
    }
}
