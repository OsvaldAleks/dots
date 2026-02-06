import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.Mpris
import "root:/styles"
import "root:/components/common"

Rectangle{
    id: controlWrapper

    property var activePlayer: Mpris.players.values
    property bool expanded: false

    implicitHeight: expanded ? controls.implicitHeight : Style.panelHeight - 2 * Style.borders
    Layout.preferredWidth: expanded ? -1 : controls.implicitWidth

    topLeftRadius: height / 2
    bottomLeftRadius: height / 2
    topRightRadius: height / 2
    bottomRightRadius: height / 2

    color: Style.gray
    
    RowLayout{
        id: controls

        anchors.fill: parent

        spacing: Style.padding

        Button{
            id: playBtn

            implicitHeight: parent.height
            topLeftRadius: expanded ? height / 2 : Style.cornerRadius/2
            bottomLeftRadius: expanded ? height / 2 : Style.cornerRadius/2
            Layout.alignment: Qt.AlignVCenter

            icon: (activePlayer && activePlayer.isPlaying) ? "" : ""
            backgroundColor: Style.white
            onClicked: activePlayer.togglePlaying()
        }

        Text {
            id: prevTrack
            visible: (activePlayer ? true : false && activePlayer.canGoPrevious)
            color: Style.black
            text: ""
            font: expanded ? Style.fontIcons : Style.fontMain
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: activePlayer.previous()
            }
        }

        Text {
            id: nextTrack
            visible: (activePlayer ? true : false && activePlayer.canGoNext)
            color: Style.black
            text: ""
            font: expanded ? Style.fontIcons : Style.fontMain
            Layout.rightMargin: expanded ? 0 : Style.padding
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: activePlayer.next()
            }
        }

        Rectangle{
            id: track
            visible: expanded
            implicitHeight: parent.height
            Layout.fillWidth: expanded
            Layout.preferredWidth: expanded ? -1 : controls.implicitWidth
            radius: height/2
            color: (activePlayer ? true : false && activePlayer.positionSupported) ? Style.accentSecondary : Style.black

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
                implicitHeight: parent.implicitHeight
                width: activePlayer ? parent.width * (activePlayer.position / activePlayer.length) : 0
                Behavior on width { NumberAnimation { duration: 50 } }

                color: (activePlayer ? true : false && activePlayer.positionSupported) ? Style.accent : Style.white
            }

            MouseArea {
                id: seekArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                property bool dragging: false

                onPressed: (mouse) => {
                    dragging = true
                    let ratio = Math.max(0,Math.min(1,mouse.x / width))
                    let targetPos = ratio * activePlayer.length
                    activePlayer.position = targetPos
                }

                onReleased: (mouse) => {
                    dragging = false
                    let ratio = Math.max(0,Math.min(1,mouse.x / width))
                    let targetPos = ratio * activePlayer.length
                    activePlayer.position = targetPos
                }

                onPositionChanged: (mouse) => {
                    if(dragging){
                        let ratio = Math.max(0,Math.min(1,mouse.x / width))
                        let targetPos = ratio * activePlayer.length
                        activePlayer.position = targetPos
                    }
                }

                onClicked: (mouse) => {
                    if (!activePlayer || !activePlayer.positionSupported || activePlayer.length <= 0) return
                    let ratio = mouse.x / width
                    let targetPos = ratio * activePlayer.length
                    activePlayer.position = targetPos
                }

            }
        }
        Text {
            visible:expanded
            text: {
                if (!activePlayer) return "--:-- / --:--"
                
                var formatTime = function(seconds) {
                    var minutes = Math.floor(seconds / 60)
                    seconds = seconds % 60
                    // Add leading zero for seconds
                    return minutes + ":" + (seconds < 10 ? "0" : "") + Math.floor(seconds)
                }
                
                return formatTime(activePlayer.position) + "/" + formatTime(activePlayer.length)
            }
            font: Style.fontMain
            color: Style.black
            Layout.rightMargin: (activePlayer && activePlayer.shuffleSupported) || (activePlayer && activePlayer.loopSupported) ? 0 : Style.padding
        }
        Text {
            id: loopState
            visible: expanded && activePlayer.loopSupported
            color: !activePlayer || (activePlayer.loopState === MprisLoopState.None)
                ? Style.black
                : Style.accentSecondary
            text: activePlayer && (activePlayer.loopState === MprisLoopState.Track)
                ? ""
                : ""
            font: expanded ? Style.fontIcons : Style.fontMain
            Layout.rightMargin: activePlayer && activePlayer.shuffleSupported ? 0 : Style.padding
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: { 
                    if(activePlayer.loopState === MprisLoopState.None)
                        activePlayer.loopState = MprisLoopState.Playlist
                    else if(activePlayer.loopState === MprisLoopState.Playlist)
                        activePlayer.loopState = MprisLoopState.Track
                    else
                        activePlayer.loopState = MprisLoopState.None
                }
            }
        }

        Text {
            id: shuffleState
            visible: expanded && activePlayer && activePlayer.shuffleSupported
            color: activePlayer && activePlayer.shuffle ? Style.accentSecondary : Style.black
            text: ""
            font: Style.fontIcons 
            Layout.rightMargin: Style.padding
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: { activePlayer.shuffle  = !activePlayer.shuffle }
            }
        }
    }

    Timer{
      running: expanded && activePlayer.playbackState == MprisPlaybackState.Playing
      // updates once per second.
      interval: 1000
      repeat: true
      onTriggered: activePlayer.positionChanged()
  }
}
