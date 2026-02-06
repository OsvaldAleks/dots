import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import "root:/styles"
import "root:/components/common"

Rectangle{
    id: playerSwitcher
    property var playerList: {
        var filtered = []
        for (var i = 0; i < Mpris.players.values.length; i++) {
            var player = Mpris.players.values[i]
            if (!player.dbusName.includes(".playerctl")) {
                filtered.push(player)
            }
        }
        return filtered
    }
    property var playerIdx: 0
    property var activePlayer: {
        if(playerList[playerIdx] != undefined)
            playerList[playerIdx] 
        else
            playerList[playerIdx % playerList.length]
    }

    implicitHeight: activePlayerControls.implicitHeight
    radius: height/2

    color: Style.accentSecondary

    RowLayout{
        id: activePlayerControls

        anchors{
            left: parent.left
            right: parent.right
        }
        
        Button{
            id: buttonPrev
            icon: ""  
            onClicked: {
                playerIdx = (playerIdx - 1 + playerList.length) % playerList.length
            }
        }

        Item {
            Layout.fillWidth: true

            RowLayout{
                anchors.centerIn: parent
                spacing: Style.padding
                IconImage{
                    source: {
                        if(!activePlayer)
                            return ""
                        var entry = DesktopEntries.byId(activePlayer.desktopEntry)
                        if(entry != null)
                            return "file:///usr/share/icons/hicolor/48x48/apps/" + entry.icon + ".png"
                        else 
                            return ""
                        }
                    implicitSize: parent.height
                    visible: source != ""

                }
                Text{
                    text: activePlayer ? activePlayer.desktopEntry : "Unknown App"
                    color: Style.white
                    font: Style.fontMain
                    horizontalAlignment: Text.AlignLeft
                }
            }
        }

        Button{
            id: buttonNext
            icon:""
            onClicked: {
                playerIdx = (playerIdx + 1) % playerList.length
            }
        }
    }
}

