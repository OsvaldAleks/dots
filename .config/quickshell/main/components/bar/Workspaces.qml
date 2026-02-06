import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "root:/styles"

Rectangle {
    id: workspaces
    height: Style.panelHeight

    implicitWidth: content.width + Style.padding
    topRightRadius: Style.cornerRadius
    bottomRightRadius: Style.cornerRadius

    property int permanentCount: 1

    readonly property int maxWorkspaceId: {
        const ids = Hyprland.workspaces.values.map(w => w.id)
        return ids.length ? Math.max(...ids) : 0
    }

    gradient: Style.bgGradient

    border{
        color:Style.colorBorders
        width:Style.borders
    }

    Behavior on implicitWidth { NumberAnimation { duration: 50 } }

    RowLayout {
        id: content
        height: parent.height

        // --- Special workspace toggle ---
        Rectangle {
            id: specialWorkspaceButton

            property bool active: {
                Hyprland.activeToplevel && Hyprland.activeToplevel.workspace.name === "special:main"
            }

            height: workspaces.height - (2 * Style.borders)
            implicitWidth: terminalIcon.implicitWidth + 2*Style.padding

            Layout.alignment: Qt.AlignVCenter
            
            topRightRadius: height / 2
            bottomRightRadius: height / 2

            color: specialWorkspaceButton.active ? Style.white : Style.gray

            Text {
                id: terminalIcon
                text: specialWorkspaceButton.active ? "" : ""
                color: Style.black
                font.pixelSize: Style.textSize
                anchors.centerIn: parent
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Hyprland.dispatch("togglespecialworkspace main")
                }
            }
        }

        // --- Workspace icons ---
        Repeater {
            model: Hyprland.workspaces
            height: parent.height

            delegate: Text {
                visible: modelData.id > 0
                readonly property bool isPermanent: modelData.id <= workspaces.permanentCount

                text: (modelData.active && !specialWorkspaceButton.active ? "" : (isPermanent ? "󰟟" : "󱔐"))
                color: modelData.active
                    ? specialWorkspaceButton.active
                        ? Style.white
                        : Style.accent 
                    : modelData.urgent
                        ? Style.colorUrgent
                        : Style.gray

                font.pixelSize: Style.textSize

                MouseArea {
                    anchors.fill: parent
                    cursorShape: !modelData.active ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked:  !modelData.active ? modelData.activate() : { } 
                }
            }
        }
    }
    WheelHandler {
        id: wheel
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        margin: Style.padding
        onWheel: (event) => {
            if (event.angleDelta.y > 0) {
                Hyprland.dispatch("workspace m-1")
            } else {
                Hyprland.dispatch("workspace m+1")
            }
        }
    }
}
