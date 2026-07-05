pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: brightnessReader

    property string backlightDir: ""
    property int brightness: 0
    property int maxBrightness: 1
    property real percent: 0

    Process {
        id: detectBacklight

        command: [
            "sh",
            "-c",
            "for d in /sys/class/backlight/*; do basename \"$d\"; break; done"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                brightnessReader.backlightDir =
                    "/sys/class/backlight/" + text.trim()
            }
        }
    }

    FileView {
        id: backlight

        path: backlightDir
            ? `${backlightDir}/brightness`
            : ""

        watchChanges: true
        preload: true

        onLoaded: {
            brightness = parseInt(text())
            percent = brightness / maxBrightness
            console.log("brightness", brightness,
                    "max", maxBrightness,
                    "percent", percent)

        }

        onFileChanged: reload()
    }

    FileView {
        id: maxBacklight

        path: backlightDir
            ? `${backlightDir}/max_brightness`
            : ""

        preload: true

        onLoaded: {
            maxBrightness = parseInt(text())
            percent = brightness / maxBrightness
        }
    }
}
