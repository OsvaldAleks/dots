import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "root:/styles"

ColumnLayout{
    id: sliderInfo
    property bool expanded: false
    property real ratio: 0.3
    property bool isDisabled: false
    property var iconList: []
    property var disabledIcon: ""
    signal labelClicked()
    signal trackClicked(real ratio)

    property real internal_ratio: ratio
    Item {
        id: clickableLabel
        implicitWidth: 2*Style.panelHeight
        implicitHeight: Style.panelHeight
        Layout.alignment: Qt.AlignVCenter

        RowLayout {
            spacing: 0
            anchors.centerIn: parent
            Text {
                id: percent
                Layout.alignment: Qt.AlignVCenter
                font: Style.fontMain
                text: Math.round(ratio * 100) + "%"
                visible: !sliderInfo.isDisabled
                color: Style.white
            }

            Text {
                id: icon
                Layout.alignment: Qt.AlignVCenter
                font: Style.fontIcons
                color: sliderInfo.isDisabled
                    ? Style.colorUrgent
                    : Style.white
                renderType: Text.NativeRendering

                text: {
                    let idx = Math.floor(ratio * sliderInfo.iconList.length)
                    idx = Math.max(0, Math.min(idx, sliderInfo.iconList.length - 1))
                    idx = idx ? idx : 0

                    return sliderInfo.isDisabled
                        ? sliderInfo.disabledIcon
                        : sliderInfo.iconList[idx]
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: disabledIcon != "" ? Qt.PointingHandCursor : undefined
            onClicked: sliderInfo.labelClicked()
        }
    }

    Rectangle{
        id: track
        visible: expanded
        Layout.alignment: Qt.AlignHCenter
        Layout.fillHeight: true
        width: Style.panelHeight-Style.padding/2
        radius: width/2
        color: isDisabled ? Style.black : Style.darkGreen

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: track.width
                height: track.height
                radius: track.radius
                color: track.color
            }
        }

        Rectangle{
            id: marker

            anchors.bottom: parent.bottom
            implicitWidth: parent.width
            height: parent.height * ratio
            Behavior on height { NumberAnimation { duration: 50 } }
            radius: Style.cornerRadius/2
            Behavior on radius { NumberAnimation { duration: 150 } }

            color: isDisabled ? Style.colorUrgent : Style.green
        }

        MouseArea {
            id: seekArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            property bool dragging: false

            onPressed: (mouse) => {
                marker.radius = marker.width
                dragging = true
                internal_ratio = (parent.height-mouse.y)/parent.height
                sliderInfo.trackClicked(internal_ratio)
            }

            onReleased: (mouse) => {
                marker.radius = Style.cornerRadius/2
                dragging = false
                internal_ratio = Math.max(0,Math.min(1,(parent.height-mouse.y)/parent.height))
                sliderInfo.trackClicked(internal_ratio)
            }

            onPositionChanged: (mouse) => {
                if(dragging){
                    internal_ratio = Math.max(0,Math.min(1,(parent.height-mouse.y)/parent.height))
                    sliderInfo.trackClicked(internal_ratio)
                }
            }

            onClicked: (mouse) => {
                internal_ratio = (parent.height-mouse.y)/parent.height
                sliderInfo.trackClicked(internal_ratio)
            }
        }
        WheelHandler {
            id: wheel
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            margin: Style.padding
            onWheel: (event) => {
                internal_ratio = Math.min(1,Math.max(0,internal_ratio + event.angleDelta.y/10000))
                sliderInfo.trackClicked(internal_ratio)
            }
        }
    }
}
