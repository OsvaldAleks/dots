
import Quickshell
import Quickshell.Wayland
import QtQuick
import "root:/components/"

PanelWindow {
    id: edge
    anchors {
        right: true
        top: true
        bottom: true
    }

    implicitWidth: 0
    color: "transparent"
    visible: true

    property bool hovered: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (!edge.hovered) {
                edge.hovered = true
            }
        }
    }

    Loader {
        anchors.fill: parent
        active: edge.hovered
        sourceComponent: RightPanel {}
    }
}
