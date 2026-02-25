import QtQuick 2.12

QtObject {
    // Base UI
    property color surface     : "#b9d1e5"
    property color sidebar     : "#2c5e86"
    property color sidebarText : "#000000"
    property color mainArea    : "#b9d1e5"
    property color mainAreaText: "#0d0d0d"
    property color logincard   : "#2c5e86"

    // Button
    property color buttonBase     : "#12446c"
    property color buttonHover    : "#447094"
    property color buttonDisabled : "#e6e0fc"
    property color buttonText     : "#0d0d0d"
    property color buttonBorder   : "#878677"


    // TextField
    property color inputBase         : "#416989"
    property color inputFocus        : "#89a2b6"
    property color inputText         : "#0d0d0d"
    property color inputPlaceholder  : "#3a3a3a"

    // ListView
    property color tableHeader     : "#2c5e86"
    property color tableRowEven    : "#96afc3"
    property color tableRowOdd     : "#d5dfe7"
    property color tableSelected   : "#b9d1e5"
    property color tableBorder     : "#506a80"
    property color tableText       : "#0d0d0d"
    property color itemUserInfo    : "#b9d1e5"


    // Dialog
    property color dialogBackground     : "#b9d1e5"
    property color dialogSidebar        : "#2c5e86"
    property color dialogMainbar        : "#b9d1e5"
    property color dialogImage          : "#b9d1e5"
    property color dialogContentArea    : "#b9d1e5"
    property color dialogHeader         : "#2c5e86"
    property color dialogHeaderText     : "#f5f5f5"
    property color dialogText           : "#0d0d0d"
    property color dialogBorder         : "#3a4555"
    property color dialogRecLastTime    : "#b9d1e5"
    property color dialogRecLastTimeText:"#000000"

    // Accent / Alert
    property color accentHighlight : "#ff0000"

    property string fontFamily       : "Times New Roman"
    property int    fontSizeSmall    : 12
    property int    fontSizeMedium   : 16
    property int    fontSizeLarge    : 20
    property bool   fontBold         : true
}
