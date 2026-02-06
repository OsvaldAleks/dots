import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "root:/styles"

Item {
    id: root
    property QsMenuEntry item

    Layout.fillWidth: true 

    implicitWidth: row.implicitWidth
    implicitHeight: item.isSeparator ? Style.padding : row.implicitHeight

    // Separator
    Rectangle {
        id: seperator
        visible: item.isSeparator
        implicitHeight: Style.padding - 4
        width: parent.width - 2*Style.padding
        radius: height/2
        color: Style.colorBorders
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    // Normal menu entry
    Rectangle {
        id: background
        anchors.fill: parent

        radius: Style.cornerRadius

        color: "transparent"

        RowLayout {
            id: row
            visible: !item.isSeparator
            anchors.fill: parent
            spacing: Style.padding

            Rectangle {
                id: iconBackground
                implicitHeight: row.implicitHeight
                Layout.fillHeight: true
                width: Style.textSize + 2 * Style.padding
                color: Style.gray

                topRightRadius: height / 2
                bottomRightRadius: height / 2

                IconImage {
                    id: icon
                    source: item.icon
                    visible: item.icon !== ""
                    implicitSize: Style.textSize
                    anchors.centerIn: parent
                }

                Layout.preferredWidth: item.icon === "" ? 0 : Style.textSize + 2 * Style.padding
                Layout.maximumWidth: item.icon === "" ? 0 : Style.textSize + 2 * Style.padding
            }

            Text {
                id:text
                text: item.text.length > 30
                    ? item.text.slice(0, 27 - 3) + "…"
                    : item.text
                color: item.enabled ? Style.text : Style.colorUrgent
                font: Style.fontMain
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.rightMargin: Style.padding
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: !item.isSeparator && item.enabled
        hoverEnabled: true

        onClicked: {
            item.triggered()
            windowLoader.close()
        }

        onEntered: {
            background.color = Style.white
            iconBackground.color = Style.white
            text.color = Style.black
        }
        onExited: {
            background.color = "transparent"
            iconBackground.color = Style.gray
            text.color = Style.white
        }
    }
}

