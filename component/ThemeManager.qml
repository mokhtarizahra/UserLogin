pragma Singleton
import QtQuick 2.12

QtObject {
    id: manager

    property string mode: "dark"

    property QtObject dark: Qt.createQmlObject('import "./themes"; ThemeDark {}', manager)
    property QtObject light: Qt.createQmlObject('import "./themes"; ThemeLight {}', manager)

    property QtObject currentTheme: mode === "dark" ? dark : light

    function toggleTheme() {
        mode = mode === "dark" ? "light" : "dark"
    }
}
