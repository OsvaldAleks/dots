import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "root:/styles/"

Item {
    id: workspaceIndicator
    width: 200
    height: 175

    property bool hovered: false
    property HyprlandWorkspace workspace: null
    property var draggedToplevel: null

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: Style.cornerRadius
        border.width: Style.borders
        border.color: workspaceIndicator.hovered 
            ? Style.white
            : workspace.active
                ? Style.accent
                : Style.black
        Behavior on border.color {
            ColorAnimation { duration: 70 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            workspaceIndicator.hovered = true
            workspaceGrid.hoveredWorkspace = workspace.id
        }
        onExited: {
            workspaceIndicator.hovered = false
            if (workspaceGrid.hoveredWorkspace == workspace.id) {
                workspaceGrid.hoveredWorkspace = 0
            }
        }

        onClicked: {
            workspaceIndicator.workspace.activate()
            overview.active = false
        }
    }

    GridLayout {
        anchors.fill: parent
        anchors.rightMargin: Style.padding
        anchors.leftMargin: Style.padding
        anchors.topMargin: Style.padding
        anchors.bottomMargin: Style.padding
        columns: 3
        columnSpacing: Style.padding
        rowSpacing: Style.padding

        Repeater {
            model: workspace.toplevels.values

            delegate: Item {
                id: toplevelItem
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth: 54
                Layout.preferredHeight: 72

                property var toplevel: modelData
                property bool dragging: false

                // Captured lazily at drag-start once GridLayout has positioned the item
                property real originX: 0
                property real originY: 0
                property bool originCaptured: false

                function ensureOriginCaptured() {
                    if (!originCaptured) {
                        originX = x
                        originY = y
                        originCaptured = true
                    }
                }

                // Snap-back animation — only fires when dragging goes false
                Behavior on x {
                    enabled: !toplevelItem.dragging
                    NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                }
                Behavior on y {
                    enabled: !toplevelItem.dragging
                    NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                }

                // MouseArea handles zero-movement clicks.
                // preventStealing: false lets DragHandler take over once movement exceeds dragThreshold.
                MouseArea {
                    id: clickArea
                    anchors.fill: parent
                    preventStealing: false

                    onClicked: {
                        if (!toplevelItem.dragging) {
                            workspaceIndicator.workspace.activate()
                            overview.active = false
                        }
                    }
                }

                DragHandler {
                    id: dragHandler
                    target: toplevelItem
                    acceptedButtons: Qt.LeftButton
                    // Only activate after real movement — leaves small taps to MouseArea
                    dragThreshold: 8
                    grabPermissions: PointerHandler.CanTakeOverFromAnything

                    xAxis.enabled: true
                    yAxis.enabled: true

                    onActiveChanged: {
                        if (active) {
                            toplevelItem.ensureOriginCaptured()
                            dragging = true
                            workspaceIndicator.draggedToplevel = toplevel
                        } else {
                            dragging = false

                            var targetWorkspaceId = workspaceGrid.hoveredWorkspace

                            if (targetWorkspaceId !== 0 && targetWorkspaceId != workspace.id) {                    
                                Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${targetWorkspaceId}, follow = false, window = "address:0x${toplevel.address}" })`)
                            } else {
                                // Snap back to captured origin
                                toplevelItem.x = toplevelItem.originX
                                toplevelItem.y = toplevelItem.originY
                            }

                            workspaceIndicator.draggedToplevel = null
                        }
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 4
                    opacity: dragging ? 0.6 : 1.0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }

                    // Icon centered in its row
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48

                        IconImage {
                            anchors.centerIn: parent
                            source: {
                                var entry = DesktopEntries.byId(modelData.wayland.appId)
                                if (entry != null && entry.icon)
                                    return "file:///usr/share/icons/Papirus/48x48/apps/" + entry.icon + ".svg"
                                return "file:///usr/share/icons/Papirus/48x48/categories/application-default-icon.svg"

                            }
                            width: 32
                            height: 32
                        }
                    }

                    Text {
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData.title.length > 12
                              ? modelData.title.slice(0, 12) + "…"
                              : modelData.title
                        elide: Text.ElideRight
                        color: Style.white
                        font.pixelSize: 10
                    }
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
