import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pipewire
import "root:/styles"
import "root:/services" as Services
import "root:/components/common"

Item{
    id: wrapper

    implicitWidth: mediaBar.implicitWidth
    implicitHeight: mediaBar.implicitHeight
    
    property bool expanded: hoverChecker.hovered

    RectangularShadow {
        id: shadow
        anchors.centerIn: mediaBar
        visible: expanded || opacity > 0
        opacity: expanded*0.49
        Behavior on opacity { NumberAnimation { duration: 200 } }

        readonly property real pad: blur + spread + 2

        width: mediaBar.width + pad * 2
        height: mediaBar.height + pad * 2

        radius: mediaBar.radius
        blur: 10
        spread: 10
        color: expanded ? Style.bg : "transparent"
        material: ShadowIgnoreBg {
            opacity: parent.opacity
            rectSize: Qt.size(mediaBar.implicitWidth*0.5, mediaBar.implicitHeight*0.5)
            iResolution: Qt.vector3d(width, height, 1.0)
        }
    }

Rectangle {
    id: mediaBar
    implicitHeight: wrapper.expanded ? 200 : Style.panelHeight
    implicitWidth: content.width + 2*Style.padding
    radius: Style.cornerRadius

    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    
    Behavior on implicitWidth { NumberAnimation { duration: 50 } }
    Behavior on implicitHeight { NumberAnimation { duration: 50 } }

    gradient: expanded ? Style.bgGradient : Style.bgGradientNone
    border{
        color:Style.colorBorders
        width:Style.borders
    }

    HoverHandler {
        id: hoverChecker
        margin: Style.padding
    }

    PwObjectTracker {
        id: sinkTracker
        objects: [Pipewire.defaultAudioSink]
    }
    PwObjectTracker {
        id: sourceTracker
        objects: [Pipewire.defaultAudioSource]
    }

    RowLayout {
        id: content
        implicitHeight: parent.implicitHeight
        spacing: Style.padding
        anchors.rightMargin: Style.padding
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        SliderInfo{
            id: micInfo
            visible: wrapper.expanded || (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio.muted)
            expanded: wrapper.expanded
            opacity: wrapper.expanded || (Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio.muted)
            Behavior on opacity { NumberAnimation { duration: 75 } }
            Layout.topMargin: wrapper.expanded*Style.padding 
            Layout.bottomMargin: wrapper.expanded*Style.padding
            Layout.alignment: Qt.AlignVCenter
            ratio: Pipewire.defaultAudioSource ? Pipewire.defaultAudioSource.audio.volume : 0
            isDisabled: !Pipewire.defaultAudioSource || Pipewire.defaultAudioSource.audio.muted
            iconList: [""]
            disabledIcon: ""
            onLabelClicked: {
                Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted
            }
            onTrackClicked: (ratio) => {
                Pipewire.defaultAudioSource.audio.volume = ratio
            }
        }

        SliderInfo{
            id: volInfo
            expanded: wrapper.expanded
            Layout.topMargin: wrapper.expanded*Style.padding 
            Layout.bottomMargin: wrapper.expanded*Style.padding
            Layout.alignment: Qt.AlignVCenter
            ratio: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
            isDisabled: !Pipewire.defaultAudioSink || Pipewire.defaultAudioSink.audio.muted
            iconList: ["","",""]
            disabledIcon: ""
            onLabelClicked: {
                Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
            }
            onTrackClicked: (ratio) => {
                Pipewire.defaultAudioSink.audio.volume = ratio
            }
        }

        SliderInfo{
            id: brightInfo
            expanded: wrapper.expanded
            Layout.topMargin: wrapper.expanded*Style.padding 
            Layout.bottomMargin: wrapper.expanded*Style.padding 
            ratio: Services.BrightnessReader.percent
            iconList: ["󰃚", "󰃛", "󰃜", "󰃞", "󰃟", "󰃠"]
            onTrackClicked: (ratio) => {
                var percent = Math.round(ratio * 100)
                Quickshell.execDetached({
                    command: ["brightnessctl", "set", percent + "%"]
                })
            }
        }
    
        SliderInfo{
            id: tempInfo
            visible: wrapper.expanded || !Services.ScreenTempReader.disabled
            expanded: wrapper.expanded
            Layout.topMargin: wrapper.expanded*Style.padding 
            Layout.bottomMargin: wrapper.expanded*Style.padding 
            ratio: 1-Services.ScreenTempReader.ratio
            iconList: ["","","","",""]
            disabledIcon: "󰸁"
            isDisabled: Services.ScreenTempReader.disabled
            onLabelClicked: {
                Services.ScreenTempReader.disabled = !Services.ScreenTempReader.disabled
                if(!Services.ScreenTempReader.disabled){
                    const max = Services.ScreenTempReader.maxVal
                    const min = Services.ScreenTempReader.minVal
                    const target = Math.floor((1-ratio)*(max-min)+min)
                    Quickshell.execDetached({
                        command: ["busctl", "--user", "set-property", "rs.wl-gammarelay", "/", "rs.wl.gammarelay", "Temperature", "q", target]
                    })
                }
            }

            onTrackClicked: (ratio) => {
                if(Services.ScreenTempReader.disabled)
                    return
                const max = Services.ScreenTempReader.maxVal
                const min = Services.ScreenTempReader.minVal
                const target = Math.floor((1-ratio)*(max-min)+min)
                Quickshell.execDetached({
                    command: ["busctl", "--user", "set-property", "rs.wl-gammarelay", "/", "rs.wl.gammarelay", "Temperature", "q", target]
                })
            }
        }
    }
}
}
