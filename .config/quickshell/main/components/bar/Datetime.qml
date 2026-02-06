import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import "root:/styles"
import "root:/components/common"

Rectangle {
    id: datetime
    implicitHeight: expanded ? content.implicitHeight : Style.panelHeight

    gradient: Style.bgGradient

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
    property var expanded: hoverChecker.hovered

    border{
        color:Style.colorBorders
        width:Style.borders
    }

    HoverHandler {
        id: hoverChecker
        margin: Style.padding
        onHoveredChanged: {
            if (!hovered) {
                selectedDate = now
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
                        const d = selectedDate
                        const day = Math.min(
                            d.getDate(),
                            new Date(d.getFullYear(), d.getMonth() + delta, 0).getDate()
                        )

                        selectedDate = new Date(
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

            month: selectedDate.getMonth()
            year: selectedDate.getFullYear()

            delegate: Rectangle{
                    height: Style.panelHeight
                    width: Style.panelHeight
                    radius: height/2

                    property bool isSelected:
                        model.year === selectedDate.getFullYear() &&
                        model.month === selectedDate.getMonth() &&
                        model.day === selectedDate.getDate()

                    color: isSelected ? Style.accent : "#00ffffff"
                    Text{
                        id: dayLabel
                        anchors.centerIn: parent
                        text: model.day
                        opacity: model.month === selectedDate.getMonth() ? 1 : 0.25
                        font: Style.fontMain
                        color: isSelected ? Style.black : Style.white
                    }
                }
                onClicked: (date) => {
                    selectedDate = date
            }
        }
    }
}
