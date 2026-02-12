import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.UPower
import "root:/styles"
import "root:/components/common"

Item{
    id: wrapper

    implicitWidth: miscMenu.implicitWidth
    implicitHeight: miscMenu.implicitHeight
    
    property bool expanded: hoverChecker.hovered


    RectangularShadow {
        id: shadow
        anchors.centerIn: miscMenu
        visible: expanded || opacity > 0
        opacity: expanded*0.49
        Behavior on opacity { NumberAnimation { duration: 200 } }

        readonly property real pad: blur + spread + 2

        width: miscMenu.width + pad * 2
        height: miscMenu.height + pad * 2

        radius: miscMenu.radius
        blur: 10
        spread: 10
        color: expanded ? Style.bg : "transparent"
        material: ShadowIgnoreBg {
            opacity: parent.opacity
            rectSize: Qt.size(miscMenu.implicitWidth*0.5, miscMenu.implicitHeight*0.5)
            iResolution: Qt.vector3d(width, height, 1.0)
        }
    }

Rectangle {
    id: miscMenu
    implicitHeight: expanded ? contentWrapper.height+ Style.padding : Style.panelHeight
    implicitWidth: contentWrapper.width + expanded*2*Style.padding
    radius: Style.cornerRadius
    
    property bool expanded: hoverChecker.hovered

    Behavior on implicitWidth { NumberAnimation { duration: 50 } }
    Behavior on implicitHeight { NumberAnimation { duration: 50 } }

    gradient: expanded ? Style.bgGradient : Style.transparentGradient
    
    border{
        color: Style.colorBorders
        width: expanded ? Style.borders : 0
    }
    HoverHandler {
        id: hoverChecker
        margin: Style.padding
    }

    Item{
        id: contentWrapper
        implicitWidth: Math.max(allContent.implicitWidth, expander.implicitWidth)
        implicitHeight: Math.max(allContent.implicitHeight, expander.implicitHeight)
        anchors.right: parent.right

        ColumnLayout{
            id: allContent
            anchors.right: parent.right
            anchors.rightMargin: Style.padding

            property var expanded: false
            spacing:0
            
            Rectangle{
                Layout.topMargin: Style.panelHeight + Style.padding
                visible: miscMenu.expanded
                implicitWidth: powerDropdown.implicitWidth
                implicitHeight: powerDropdown.implicitHeight

                color: Style.darkGray
                radius: dropdownToggle.radius

                Behavior on implicitHeight { NumberAnimation { duration: powerDropdown.expanded ? 50 : 0 } }

                ColumnLayout{
                    id: powerDropdown
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.top: parent.top
                    property var expanded: false
                    spacing:0
                    Label{
                        id: dropdownToggle
                        Layout.fillWidth: true
                        icon: ""
                        content: "Power options"
                        textColor: Style.black
                        iconBackground: Style.white
                        labelBackground: Style.gray

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: () => {
                                powerDropdown.expanded = !powerDropdown.expanded
                            }
                        }
                    }

                    Button{
                        visible: powerDropdown.expanded && miscMenu.expanded
                        opacity: powerDropdown.expanded
                        Behavior on opacity { NumberAnimation { duration: 125 } }
                        Layout.fillWidth: true
                        icon: ""
                        text: "Log out"
                        alignment: "left"
                        backgroundColor: Style.darkGray
                        textColor: Style.white
                        onClicked: () => {
                            Quickshell.execDetached({
                                command: ["hyprctl", "dispatch", "exit"]
                            })
                        }
                    }
                    Button{
                        visible: powerDropdown.expanded && miscMenu.expanded
                        opacity: powerDropdown.expanded
                        Behavior on opacity { NumberAnimation { duration: 125 } }
                        Layout.fillWidth: true
                        icon: ""
                        text: "Reboot"
                        alignment: "left"
                        backgroundColor: Style.darkGray
                        textColor: Style.white
                        onClicked: () => {
                            Quickshell.execDetached({
                                command: ["reboot"]
                            })
                        }
                    }
                    Button{
                        id: finalOption
                        visible: powerDropdown.expanded && miscMenu.expanded
                        opacity: powerDropdown.expanded
                        Behavior on opacity { NumberAnimation { duration: 125 } }
                        Layout.fillWidth: true
                        icon: ""
                        text: "Power Off"
                        alignment: "left"
                        backgroundColor: Style.colorUrgent
                        textColor: Style.black
                        onClicked: () => {
                            Quickshell.execDetached({
                                command: ["poweroff"]
                            })
                        }
                    }
                }
            }
            RowLayout{
                visible: expanded
                Layout.fillWidth: true
                Layout.topMargin: Style.padding
                Button{
                    Layout.fillWidth: true
                    icon: "󰈊"
                    onClicked: () => {
                        Quickshell.execDetached({
                            command: ["hyprpicker"]
                        })
                    }
                }
                Button{
                    Layout.fillWidth: true
                    icon: "󰹑"
                    onClicked: () => {
                        Quickshell.execDetached({
                            command: ["hyprshot", "-m", "region"]
                        })
                    }
                }
            }
        }

        Rectangle{
            id: expander
            implicitHeight: Style.panelHeight - 2*Style.borders
            implicitWidth: expanderIcon.width + expanded*0.2*miscMenu.implicitWidth

            anchors{
                right:parent.right
                top:parent.top
                topMargin: Style.borders
            }

            topLeftRadius: height/2
            bottomLeftRadius: height/2

            color: expanded ? Style.white : Style.gray
            
            Label{ 
                id: expanderIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                icon: expanded ? "" : "󰤇"
                content: expanded ? "Search" : ""
                labelBackground: "transparent"
                iconBackground: "transparent"
                textColor: Style.black
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: () => {
                    Quickshell.execDetached({
                        command: ["fuzzel"]
                    })
                }
            }
        }
    }
}
}
