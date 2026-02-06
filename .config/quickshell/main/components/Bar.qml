import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import "root:/styles/"
import "root:/components/bar"
import "root:/components/menus"

PanelWindow {
    id: panel

    exclusiveZone: Style.panelHeight + Style.padding
    implicitHeight: 400

    anchors{
        top: true
        left: true
        right: true
    }

    mask: Region {
        regions: [
            Region { item: leftGroup },
            Region { item: rightGroup },
            Region { item: centerGroup }
        ]
    }

    color: "transparent"

    // Left
    RowLayout{
        id: leftGroup
        spacing: Style.padding
        anchors{
            left: parent.left
            top: parent.top
        }
        
        Workspaces {
            id: workspaces
            permanentCount: 3
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }

        SystemTray {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }
        Player {
            id: player
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }
    }

    // Center
    RowLayout{
        id: centerGroup
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: Style.padding

        Datetime {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }
    }

    // Right side
    RowLayout{
        id: rightGroup
        anchors {
            right: parent.right
        }

        spacing: Style.padding

        MediaBar { 
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }

        Battery {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }

        Network { 
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }
        Misc {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Style.padding
        }
    }
}
