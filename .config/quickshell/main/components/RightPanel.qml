
import Quickshell
import Quickshell.Wayland
import QtQuick
import "root:/styles/"

PanelWindow {
    id: rightPanel

    implicitHeight: Screen.height - Style.panelHeight - Style.padding
    implicitWidth: 300

    anchors{
        right:true
    }

    exclusionMode: ExclusionMode.Auto
    
    color: "transparent"

    Rectangle{
        x: 0
        y: Style.padding

        height: parent.height - 2 * Style.padding
        width: parent.width - Style.padding

        radius: Style.cornerRadius

        color: Style.bg
        border{
            color: Style.text
            width: Style.borders
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: edge.hovered = false
    }
}
