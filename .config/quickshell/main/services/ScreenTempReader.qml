pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: screenTempReader

    property int minVal: 1500
    property int maxVal: 6500
    property int currentTemp: 5000
    property real ratio: 0
    property bool disabled: true

    onDisabledChanged: {
        if(disabled){
            Quickshell.execDetached({
                command: ["busctl", "--user", "set-property", "rs.wl-gammarelay", "/", "rs.wl.gammarelay", "Temperature", "q", screenTempReader.maxVal]
            })
        }
    }

    property Process proc: Process {

        running: true

        command: [ "sh", "-c", "wl-gammarelay-rs watch {t}" ]

        stdout: SplitParser {
            onRead: (line) => {
                const value = parseInt(line.trim())
                if (!isNaN(value)) {
                    screenTempReader.currentTemp = value
                    screenTempReader.ratio = (value-screenTempReader.minVal)/(screenTempReader.maxVal-screenTempReader.minVal)
                }
            }
        }
    }
}
