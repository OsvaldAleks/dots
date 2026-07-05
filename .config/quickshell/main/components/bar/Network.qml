import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import "root:/styles"

Rectangle {
    implicitHeight: Style.panelHeight
    gradient: Style.bgGradientNone

    implicitWidth: content.width + Style.padding

    radius: Style.cornerRadius

    border{
        color:Style.colorBorders
        width: 0
    }

    QtObject {
        id: network

        readonly property NetworkDevice activeDevice: {
            var wifi = null

            for (let i = 0; i < Networking.devices.values.length; i++) {
                const dev = Networking.devices.values[i]

                if (!dev.connected)
                    continue

                if (dev.type === DeviceType.Wired)
                    return dev

                if (dev.type === DeviceType.Wifi)
                    wifi = dev
            }
            return wifi
        }

        readonly property string icon: {
            if (!activeDevice)
                return "󰖪"

            switch (activeDevice.type) {
            case DeviceType.Wired:
                return "󱎔"
            case DeviceType.Wifi:
                return "󰖩"
            default:
                return "󰖪"
            }
        }

        readonly property string name: {
            if (!activeDevice)
                return Networking.wifiEnabled ? "Disconnected" : "Disabled"

            for (let i = 0; i < activeDevice.networks.values.length; i++) {
                const net = activeDevice.networks.values[i]
                if (net.connected)
                return net.name 
            }

            return activeDevice.name
        }

        readonly property color textColor: activeDevice ? Style.blue : Style.darkRed
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

            RowLayout {
                id: connectedNetworkLabel
                spacing: Style.padding
                anchors.centerIn: parent

                Text {
                    id: connectedNetworkIcon
                    text: network.icon
                    color: network.textColor
                    font: Style.fontIcons
                }

                Text {
                    id: connectedNetworkText
                    text: network.name
                    color: network.textColor
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
