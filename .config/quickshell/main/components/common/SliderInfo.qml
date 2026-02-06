import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "root:/styles"

ColumnLayout{
    id: sliderInfo
    property bool expanded: false
    property real ratio: 0.0
    property bool isDisabled: false
    property var iconList: []
    property var disabledIcon: ""
    signal labelClicked()
    signal trackClicked(real ratio)

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
                    let idx = Math.floor(sliderInfo.ratio * sliderInfo.iconList.length)
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
        color: isDisabled ? Style.black : Style.accentSecondary

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
            anchors.bottom: parent.bottom
            implicitWidth: parent.width
            height: parent.height * sliderInfo.ratio
            radius: Style.cornerRadius/2
            Behavior on height { NumberAnimation { duration: 50 } }

            color: isDisabled ? Style.colorUrgent : Style.accent
        }

        MouseArea {
            id: seekArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            property bool dragging: false

            onPressed: (mouse) => {
                dragging = true
                sliderInfo.ratio = (parent.height-mouse.y)/parent.height
                sliderInfo.trackClicked(sliderInfo.ratio)
            }

            onReleased: (mouse) => {
                dragging = false
                sliderInfo.ratio = Math.max(0,Math.min(1,(parent.height-mouse.y)/parent.height))
                sliderInfo.trackClicked(sliderInfo.ratio)
            }

            onPositionChanged: (mouse) => {
                if(dragging){
                    sliderInfo.ratio = Math.max(0,Math.min(1,(parent.height-mouse.y)/parent.height))
                }
            }

            onClicked: (mouse) => {
                const ratio = (parent.height-mouse.y)/parent.height
                sliderInfo.trackClicked(ratio)
            }
        }
        WheelHandler {
            id: wheel
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            margin: Style.padding
            onWheel: (event) => {
                ratio = Math.min(1,Math.max(0,ratio + event.angleDelta.y/10000))
            }
        }
    }
}
