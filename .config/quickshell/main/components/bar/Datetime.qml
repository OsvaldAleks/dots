import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import QtQuick.Controls
import "root:/styles"
import "root:/components/common"
Item{
    id: wrapper

    implicitWidth: datetime.implicitWidth
    implicitHeight: datetime.implicitHeight
    
    property bool expanded: hoverChecker.hovered

    RectangularShadow {
        id: shadow
        anchors.centerIn: datetime
        visible: expanded || opacity > 0
        opacity: expanded*0.49
        Behavior on opacity { NumberAnimation { duration: 200 } }

        readonly property real pad: blur + spread + 2

        width: datetime.width + pad * 2
        height: datetime.height + pad * 2

        radius: datetime.radius
        blur: 10
        spread: 10
        color: expanded ? Style.bg : "transparent"
        material: ShadowIgnoreBg {
            opacity: parent.opacity
            rectSize: Qt.size(datetime.implicitWidth*0.5, datetime.implicitHeight*0.5)
            iResolution: Qt.vector3d(width, height, 1.0)
        }
    }
    Rectangle {
        id: datetime
        implicitHeight: expanded ? content.implicitHeight : Style.panelHeight

        gradient: expanded ? Style.bgGradient : Style.bgGradientNone

        implicitWidth: content.width
        radius: Style.cornerRadius

        Behavior on implicitWidth { NumberAnimation { duration: 50 } }
        Behavior on implicitHeight { NumberAnimation { duration: 50 } }
       
        SystemClock {
            id: clockItem
            precision: SystemClock.Seconds
        }

        property var now: new Date()
        property var selectedDate: now

        border{
            color:Style.colorBorders
            width:Style.borders
        }

        HoverHandler {
            id: hoverChecker
            margin: Style.padding
            onHoveredChanged: {
                if (!hovered) {
                    datetime.selectedDate = datetime.now
                }
            }
        }

        ColumnLayout{
            id: content
            anchors{
                left: parent.left
                margins: Style.borders
            }
            width: expanded ? 350 : undefined

            RowLayout {
                id: topLine
                height: Style.panelHeight
                Layout.fillWidth: true
                Layout.topMargin: Style.borders

                Rectangle{
                    color: Style.gray
                    height: Style.panelHeight - 2*Style.borders
                    implicitWidth: monthControls.implicitWidth + expanded*Style.padding

                    Behavior on implicitWidth { NumberAnimation { duration: 100 } }
                    
                    radius: height / 2

                    RowLayout{
                        id: monthControls
                        height: Style.panelHeight - 2*Style.borders
                        spacing: 0
                        Rectangle {
                            color: Style.white
                            implicitHeight: Style.panelHeight - 2*Style.borders
                            implicitWidth: date.implicitWidth + 2*Style.padding

                            Layout.alignment: Qt.AlignVCenter
                            
                            topRightRadius: height / 2
                            bottomRightRadius: height / 2
                            topLeftRadius: Style.cornerRadius/2
                            bottomLeftRadius: Style.cornerRadius/2

                            Text {
                                id: date
                                anchors.centerIn: parent
                                font: Style.fontMain
                                color: Style.black
                                text: expanded ? Qt.formatDateTime(datetime.selectedDate, " MMM dd yyyy") : Qt.formatDateTime(datetime.selectedDate, " MMM dd")
                                Behavior on width { NumberAnimation { duration: 75 } }
                            }
                        }
                        function shiftMonth(delta) {
                            const d = datetime.selectedDate
                            const day = Math.min(
                                d.getDate(),
                                new Date(d.getFullYear(), d.getMonth() + delta, 0).getDate()
                            )

                            datetime.selectedDate = new Date(
                                d.getFullYear(),
                                d.getMonth() + delta,
                                day
                            )
                        }
                        Button{
                            implicitHeight: Style.panelHeight - 2*Style.borders
                            visible: expanded
                            icon: "" 
                            onClicked: monthControls.shiftMonth(-1)
                        }
                        Button{
                            implicitHeight: Style.panelHeight - 2*Style.borders
                            visible: expanded
                            icon: "" 
                            onClicked: monthControls.shiftMonth(1)

                        }
                    }
                }

                Text {
                    id: clockLabel
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: Style.padding
                    horizontalAlignment: Text.AlignRight
                    font: Style.fontMain
                    text: Qt.formatDateTime(clockItem.date, " hh:mm:ss")
                    color: Style.text
                }
            }

            DayOfWeekRow {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.margins: Style.padding
                Layout.bottomMargin: 0
                visible: expanded
                delegate: Rectangle{
                    implicitWidth: dofLabel.width
                    implicitHeight: dofLabel.height
                    radius: height/2
                    color: Style.gray
                    Text{
                        id: dofLabel
                        anchors.centerIn: parent
                        verticalAlignment: Text.AlignVCenter
                        text: shortName
                        font: Style.fontMain
                        color: Style.black
                    }
                }
            }

            MonthGrid{
                id: monthGrid

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                visible: expanded
                Layout.margins: Style.padding
                Layout.topMargin: 0

                month: datetime.selectedDate.getMonth()
                year: datetime.selectedDate.getFullYear()

                delegate: Rectangle{
                        height: Style.panelHeight
                        width: Style.panelHeight
                        radius: height/2

                        property bool isSelected:
                            model.year === datetime.selectedDate.getFullYear() &&
                            model.month === datetime.selectedDate.getMonth() &&
                            model.day === datetime.selectedDate.getDate()

                        color: isSelected ? Style.accent : "#00ffffff"
                        Text{
                            id: dayLabel
                            anchors.centerIn: parent
                            text: model.day
                            opacity: model.month === datetime.selectedDate.getMonth() ? 1 : 0.25
                            font: Style.fontMain
                            color: isSelected ? Style.black : Style.white
                        }
                    }
                    onClicked: (date) => {
                        datetime.selectedDate = date
                }
            }
        }
    }
}
