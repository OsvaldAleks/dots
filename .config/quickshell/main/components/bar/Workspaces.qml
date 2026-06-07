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

    property int permanentCount: 3

    readonly property int maxWorkspaceId: {
        const ids = Hyprland.workspaces.values.map(w => w.id)
        return ids.length ? Math.max(...ids) : 0
    }

    gradient: Style.bgGradientNone

    border{
        color: Style.colorBorders
        width: 0
    }

    Behavior on implicitWidth { NumberAnimation { duration: 50 } }

    HoverHandler {
        id: hoverChecker
        margin: 2*Style.padding
        onHoveredChanged: {
            if (hovered) {
                overview.active = true
            }
        }
    }

    RowLayout {
        id: content
        height: parent.height

        // --- Special workspace toggle ---
        Rectangle {
            id: specialWorkspaceButton

            property bool active: {
                Hyprland.activeToplevel && Hyprland.activeToplevel.workspace.name === "special:main"
            }

            height: workspaces.height
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
                    Hyprland.dispatch("hl.dsp.workspace.toggle_special( \"main\" )")
                }
            }
        }

        // --- Workspace icons ---
        Repeater {
            model: Hyprland.workspaces
            height: parent.height

            delegate: Text {
                visible: modelData.id > 0 && modelData.monitor.name=="eDP-1"
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
                Hyprland.dispatch("hl.dsp.focus( {workspace = \"m-1\" })")
            } else {
                Hyprland.dispatch("hl.dsp.focus( {workspace = \"m+1\" })")
            }
        }
    }
}
