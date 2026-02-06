import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import "root:/styles"
import "root:/components/common"
import "root:/components/playerComponents"

Rectangle {
    id: player
    implicitWidth: expanded ? 625 : playerControls.width + artistLabel.width + 2*Style.borders
    implicitHeight: expanded ? trackImage.height + + 2*Style.padding + 2*Style.borders : Style.panelHeight
    radius: Style.cornerRadius
    Behavior on implicitWidth { NumberAnimation { duration: 50 } }
    Behavior on implicitHeight { NumberAnimation { duration: 50 } }

    property var activePlayer: playerSwitcher.activePlayer
    property bool expanded: hoverChecker.hovered
    property int truncationLimit: expanded ? 41 : 30

    gradient: Style.bgGradient
    border {
        color: Style.colorBorders
        width: Style.borders
    }

    HoverHandler {
        id: hoverChecker
        margin: Style.padding
    }

    GridLayout {
        id: content

        anchors{
            fill: parent
        }

        columns: 2
        rows: 4
        
        flow: GridLayout.LeftToRight
    
        // --- CONTENT ---
        Image{
            id: trackImage
            visible: expanded
            opacity: expanded ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 75 } }   
            source: activePlayer ? activePlayer.trackArtUrl || "root:/assets/noTrack.png" : "root:/assets/noTrack.png"
            Layout.preferredWidth: 150
            Layout.preferredHeight: 150
            Layout.rowSpan: 4
            Layout.column: 0
            Layout.margins: Style.padding
            fillMode: Image.PreserveAspectFit
            enabled: expanded
        }

        PlayerSwitcher {
            id: playerSwitcher
            visible: expanded
            opacity: expanded ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 75 } }

            Layout.row: 0
            Layout.column: 1

            Layout.fillWidth: true
            Layout.topMargin: Style.padding
            Layout.rightMargin: Style.padding
        }

        PlayerControls {
            id: playerControls
            activePlayer: player.activePlayer
            expanded: player.expanded

            Layout.row: expanded ? 3 : 0
            Layout.column: expanded ? 1 : 0
            
            Layout.fillWidth: expanded ? true : false
            Layout.topMargin: expanded ? Style.padding : 0
            Layout.rightMargin: expanded ? Style.padding : 0
            Layout.bottomMargin: expanded ? Style.padding : 0
            Layout.leftMargin: Style.borders
        }

        Label{
            id: artistLabel
            Layout.row: expanded ? 1 : 0
            Layout.column: expanded ? 1 : 1
            Layout.topMargin: expanded ? Style.padding : 0
            Layout.rightMargin: expanded ? Style.padding : 0
            Behavior on implicitWidth { NumberAnimation { duration: 30 } }
            icon: expanded ? "" : ""
            content: activePlayer
                    ? activePlayer.trackTitle.length > truncationLimit
                        ? activePlayer.trackTitle.slice(0, truncationLimit - 3) + "…"
                        : activePlayer.trackTitle
                    : "Unkown Title"
            textColor: Style.white
            labelBackground: expanded ? Style.darkGray : "transparent"
        }

        RowLayout{
            visible: expanded 
            opacity: !expanded ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 75 } }

            Layout.row: 2
            Layout.column: 1
            Layout.topMargin: Style.padding
            Layout.rightMargin: Style.padding

            Label{
                visible: expanded && activePlayer.trackArtist
                opacity: (!activePlayer || !activePlayer.trackArtist) ? 0 : 1

                Behavior on opacity { NumberAnimation { duration: 75 } }
                Behavior on implicitWidth { NumberAnimation { duration: 30 } }
                
                icon: "󰍬"
                content: activePlayer
                        ? activePlayer.trackArtist.length > truncationLimit/2
                            ? activePlayer.trackArtist.slice(0, truncationLimit/2 - 3) + "…"
                            : activePlayer.trackArtist
                        : "Unknown Artist"
            }
            Label{
                visible: expanded && activePlayer.trackAlbum
                opacity: !activePlayer || !activePlayer.trackAlbum ? 0 : 1

                Behavior on opacity { NumberAnimation { duration: 75 } }

                Behavior on implicitWidth { NumberAnimation { duration: 30 } }

                icon: "󰀥"
                content: activePlayer
                        ? activePlayer.trackAlbum.length > truncationLimit/2
                            ? activePlayer.trackAlbum.slice(0, truncationLimit/2 - 3) + "…"
                            : activePlayer.trackAlbum
                        : "Unknown Album"
            }
        }
    }
}

