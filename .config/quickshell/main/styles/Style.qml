pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: style

    // Fonts properties
    readonly property string fontFamMain: "DejaVu Sans Mono"

    readonly property int textSize: 14
    readonly property int textSizeLg: 20

    readonly property font fontMain: Qt.font({
        family: fontFamMain,
        pixelSize: textSize
    })
    readonly property font fontIcons: Qt.font({
        pixelSize: 18,
        renderType: Text.NativeRendering,
        hintingPreference: Font.PreferNoHinting,
        letterSpacing: 0,
        wordSpacing: 0
    })    

    // Colors
    readonly property color bg: "#801D1C1A"
    readonly property color accent: "#ead91f"
    readonly property color accentSecondary: "#b3640b"
    readonly property color green: "#65E127"
    readonly property color darkGreen: "#4d7503"
    readonly property color blue: "#1c5e5b"
    readonly property color gray: "#89847d"
    readonly property color darkGray: "#4c4a46"
    readonly property color white: "#F1E4D0"
    readonly property color black: "#1D1C1A"
    readonly property color yellow: "#EAD91F"
    readonly property color red: "#F2412A"
    readonly property color darkRed: "#852204"
    readonly property color brown: "#a09e45"

    readonly property color text: white
    readonly property color colorUrgent: red
    readonly property color colorBorders: "#804c4a46" 

    // Gradients
    readonly property var bgGradient: Gradient {
        GradientStop { position: 0.0; color: bg }
        GradientStop { position: 1.0; color: "#801D1C1A"}
    } 
    readonly property var bgGradientNone: Gradient {
        GradientStop { position: 0.0; color: bg }
    }
    readonly property var transparentGradient: Gradient {
        GradientStop { position: 0.0; color: "transparent" }
    }

    // Sizes
    readonly property int panelHeight: 25
    readonly property int cornerRadius: 5
    readonly property int padding: 10
    readonly property int borders: 1

    // Effects
    readonly property real shadowBlur : 1
    readonly property color shadowColor : black
    readonly property real shadowScale : 1.3
}
