import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import "root:/styles/"
import "root:/components/overview/"

PanelWindow {
    anchors {
        left: true
        top: true
    }
    margins {
        top: Style.panelHeight + Style.padding
    }

    implicitHeight: body.implicitHeight + 4*Style.padding
    implicitWidth: body.implicitWidth + 4*Style.padding
    exclusionMode: ExclusionMode.Ignore

    color: "transparent"
    
    Item{
        id: wrapper

        anchors.centerIn: parent

        implicitWidth: body.implicitWidth
        implicitHeight: body.implicitHeight

        property bool expanded: true

        RectangularShadow {
            id: shadow
            anchors.centerIn: body
            visible: wrapper.expanded || opacity > 0
            opacity: wrapper.expanded*0.49
            Behavior on opacity { NumberAnimation { duration: 200 } }

            readonly property real pad: blur + spread + 2

            width: body.width
            height: body.height + pad * 2

            radius: body.radius
            blur: 10
            spread: 10
            color: wrapper.expanded ? Style.bg : "transparent"
            material: ShadowIgnoreBg {
                opacity: shadow.opacity
                rectSize: Qt.size(body.implicitWidth*0.5, body.implicitHeight*0.5)
                iResolution: Qt.vector3d(width, height, 1.0)
            }
        }
        Rectangle {
            id: body
            implicitHeight: workspaceGrid.height + 2*Style.padding
            implicitWidth: workspaceGrid.width + 2*Style.padding
            radius: Style.cornerRadius

            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            
            gradient: wrapper.expanded ? Style.bgGradient : Style.bgGradientNone
            border{
                color:Style.colorBorders
                width:Style.borders
            }

            GridLayout {
                id: workspaceGrid
                anchors.centerIn: parent
                rowSpacing: Style.padding
                columnSpacing: Style.padding
                columns: 5
                
                property int hoveredWorkspace: 0

                Repeater {
                    id: workspaceIterator
                    model: Hyprland.workspaces

                    delegate: Workspace{
                        visible: modelData.id > 0
                        id: workspaceIndicator

                        workspace: modelData
                    }
                }
                Rectangle {
                    id: newWorkspaceTile
                    color: hoverHandler.hovered ? Style.white : Style.black
                    width: newWorkspaceText.width + 2*Style.padding
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.minimumHeight: newWorkspaceText.width + 2*Style.padding
                    radius: Style.cornerRadius
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    Text {
                        id: newWorkspaceText
                        text: "+"
                        color: hoverHandler.hovered ? Style.black : Style.white
                        font.pixelSize: 24
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Hyprland.dispatch('workspace ' + Hyprland.workspaces.values[Hyprland.workspaces.values.length-1].id+1)
                        }
                    }

                    HoverHandler {
                        id: hoverHandler
                        onHoveredChanged: {
                            if(hovered){
                                workspaceGrid.hoveredWorkspace = Hyprland.workspaces.values[Hyprland.workspaces.values.length-1].id+1
                            }
                            else   
                                workspaceGrid.hoveredWorkspace = 0
                        }
                    }
                }
            }
            HoverHandler {
                id: hoverChecker
                margin: 2*Style.padding
                onHoveredChanged: {
                    if (!hovered) {
                        overview.active = false
                    }
                }
            }
            HoverHandler {
                onHoveredChanged: {
                    if (!hovered) {
                        workspaceGrid.hoveredWorkspace = Hyprland.focusedWorkspace.id
                    }
                    else{
                        workspaceGrid.hoveredWorkspace = 0
                    }
                }
            }
        }
    }
}
