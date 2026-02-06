pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: brightnessReader

    property int brightness: 0
    property int maxBrightness: 1
    property real percent: 0

    // current brightness
    FileView {
        id: backlight
        path: "/sys/class/backlight/amdgpu_bl2/brightness"
        watchChanges: true
        preload: true

        onLoaded: {
            brightness = parseInt(text())
            percent = brightness / maxBrightness
        }
        onFileChanged: reload()
    }

    // max brightness
    FileView {
        id: maxBacklight
        path: "/sys/class/backlight/amdgpu_bl2/max_brightness"
        preload: true
        watchChanges: false

        onLoaded: {
            maxBrightness = parseInt(text())
            percent = brightness / maxBrightness
        }
    }

    onBrightnessChanged: {
        percent = Math.round(brightness / maxBrightness * 100)
    }
}
