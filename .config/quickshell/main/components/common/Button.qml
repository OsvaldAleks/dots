import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/styles"
import "root:/components/common"

Rectangle{
    id: button
    property var icon: ""
    property var text: ""
    property var backgroundColor: Style.gray
    property var textColor: Style.black
    property var alignment: "center"
    signal clicked

    HoverHandler {
        id: hoverChecker
    }

    implicitHeight: buttonLabel.implicitHeight
    implicitWidth: buttonLabel.implicitWidth

    color: backgroundColor
    opacity: !hoverChecker.hovered * 0.25 + 0.75
    Behavior on opacity { NumberAnimation { duration: 75 } }
    radius: implicitHeight/2

    Label{
        id: buttonLabel
        anchors{
            horizontalCenter: alignment === "center" ? parent.horizontalCenter : undefined
            left: alignment === "left" ? parent.left : undefined
        }
        icon: button.icon
        content: button.text
        opacity: !hoverChecker.hovered * 0.25 + 0.75
        Behavior on opacity { NumberAnimation { duration: 75 } }
        labelBackground: "transparent"
        iconBackground: "transparent"
        textColor: button.textColor
        iconColor: button.textColor
    }

    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            button.clicked()
        }
    }
}

