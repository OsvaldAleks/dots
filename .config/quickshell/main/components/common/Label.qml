import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/styles"

Rectangle {
    id: labelWrapper

    implicitHeight: labelContent.implicitHeight
    implicitWidth: labelContent.implicitWidth + Style.padding
    radius: height/2

    property var icon: ""
    property var content: ""
    property var labelBackground: Style.darkGray
    property var iconBackground: Style.accent
    property var textColor: Style.white
    property var iconColor: Style.black

    color: labelBackground

    RowLayout {
        id: labelContent    

        Rectangle{
            id: iconWrapper

            visible: icon
 
            implicitHeight: iconField.implicitHeight
            implicitWidth: iconField.implicitWidth + labelText.visible*2*Style.padding
            radius: height/2
            Layout.leftMargin: !labelText.visible*Style.padding

            color: iconBackground

            Text {
                id: iconField
                anchors.centerIn: parent
                text: icon
                font: Style.fontIcons
                color: iconColor
            }
        }
        Text{
            id: labelText
            visible: content
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: content
            font: Style.fontMain
            color: textColor
        }
    }
}

