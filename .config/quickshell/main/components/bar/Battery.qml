import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import "root:/styles"
import "root:/components/common"

Rectangle {
    implicitHeight: Style.panelHeight
    implicitWidth: batteryInfo.width + isCharging*chargingLabel.width + Style.padding
    radius: Style.cornerRadius

    property bool isCharging: { return UPower.displayDevice.state === 1 }

    gradient: Style.bgGradientNone
    border{
        color: Style.colorBorders
        width: 0
    }
    RowLayout{
        anchors.centerIn: parent
        spacing: 0
        SliderInfo{
            id: batteryInfo
            ratio: UPower.displayDevice.percentage
            iconList: ["󰂎","󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]
        }
        Text{
            id: chargingLabel
            visible: isCharging
            color: Style.yellow
            text: ""
        }
    }
}
