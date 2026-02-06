import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "root:/styles"
import "root:/components/menus/"

// Assuming this is in a Window or has a parent window
RowLayout {
    id: tray
    implicitHeight: contents.height
    visible: SystemTray.items.values.length > 0

    Repeater {
        id: contents
        model: SystemTray.items

        delegate: Item{
            implicitHeight: itemWrapper.implicitHeight
            implicitWidth: itemWrapper.implicitWidth
            Layout.fillHeight: true

            Rectangle{
                id: itemWrapper
                implicitWidth: itemContents.implicitWidth
                implicitHeight: itemContents.implicitHeight

                Behavior on implicitWidth { NumberAnimation { duration: 50 } }
                Behavior on implicitHeight { NumberAnimation { duration: 50 } }

                property bool expanded: hoverChecker.hovered

                HoverHandler {
                    id: hoverChecker
                }
                
                gradient: expanded ? Style.bgGradient : Style.transparentGradient
                radius: Style.cornerRadius

                ColumnLayout{
                    id: itemContents

                    Item {
                        Layout.leftMargin: itemWrapper.expanded * Style.padding
                        Layout.topMargin: 3
                        
                        implicitWidth: trayIcon.width
                        implicitHeight: trayIcon.height
                        
                        MultiEffect {
                            visible: !itemWrapper.expanded
                            source: trayIcon
                            anchors.fill: parent
                            shadowEnabled: true
                            shadowBlur: Style.shadowBlur
                            shadowColor: Style.shadowColor
                            shadowScale: Style.shadowScale
                            blurMax: Style.blurMax
                            blurMultiplier: Style.blurMultiplier
                        }
                        
                        IconImage {
                            id: trayIcon
                            source: modelData.icon
                            implicitSize: Style.panelHeight - Style.padding/2
                            
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                cursorShape: Qt.PointingHandCursor
                                onClicked: function(mouse) {
                                    if (mouse.button === Qt.LeftButton) {
                                        modelData.activate()
                                    } else if (mouse.button === Qt.MiddleButton) {
                                        modelData.secondaryActivate()
                                    }
                                }
                                onWheel: function(wheel) {
                                    var delta = wheel.angleDelta.y > 0 ? 1 : -1
                                    var horizontal = wheel.angleDelta.x !== 0
                                    modelData.scroll(delta, horizontal)
                                }
                            }
                        }
                    }
    
                    MenuPopup{
                        visible: itemWrapper.expanded
                        opener.menu: modelData.menu
                    }
                }
            }
        }
    }
}
