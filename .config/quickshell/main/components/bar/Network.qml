import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import "root:/styles"
import "root:/services" as Services

Rectangle {
    implicitHeight: Style.panelHeight
    gradient: Style.bgGradientNone

    implicitWidth: content.width + Style.padding

    radius: Style.cornerRadius

    border{
        color:Style.colorBorders
        width: 0
    }

    RowLayout {
        id: content
        height: parent.height
        anchors.right: parent.right

        Item{
            implicitWidth: bluetoothLabel.width
            implicitHeight: bluetoothLabel.height
            RowLayout{
                id: bluetoothLabel
                Text{
                    id: connectedDevicesNum
                    visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled
                    text: {
                        let count = 0;
                        for (let i = 0; i < Bluetooth.devices.values.length; i++) {
                            const device = Bluetooth.devices.values[i];
                            if (device.connected) count++;
                        }
                        return count;
                    }
                    color: Style.white
                    font: Style.fontMain
                }
                Text{
                    id: bluetoothIcon
                    text: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled ? "󰂯" : "󰂲"
                    color: Style.white
                    font: Style.fontIcons
                }
            }
            MouseArea{
                anchors.fill: bluetoothLabel
                onClicked: Quickshell.execDetached({
                    command: ["sh", "-c", "DMENU_BLUETOOTH_LAUNCHER=fuzzel dmenu-bluetooth"]
                })
            }
        }

        Rectangle{
            implicitWidth: connectedNetworkLabel.width + 2*Style.padding
            implicitHeight: Style.panelHeight

            color: Style.white

            topLeftRadius: height / 2
            bottomLeftRadius: height / 2
            topRightRadius: Style.cornerRadius/2
            bottomRightRadius: Style.cornerRadius/2


            RowLayout{
                id: connectedNetworkLabel
                spacing: Style.padding
                anchors.centerIn: parent
                Text{
                    id: connectedNetworkIcon
                    text: {
                        switch (Services.NetworkReader.connectionType) {
                        case "wifi":
                            return "󰖩"
                        case "ethernet":
                            return "󱎔"
                        default:
                            return "󰖪"
                        }
                    }
                    color: (Services.NetworkReader.connectionType == "none") ? Style.darkRed : Style.blue
                    font: Style.fontIcons
                }
                Text{
                    id: connectedNetworkText
                    text: Services.NetworkReader.connectionName
                    color: (Services.NetworkReader.connectionType == "none") ? Style.darkRed : Style.blue
                    font: Style.fontMain
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: Quickshell.execDetached({
                    command: ["networkmanager_dmenu", "&"]
                })
            }
        }
    }
}
