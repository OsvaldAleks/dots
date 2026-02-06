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
    readonly property color bg: "#8014141e"
    readonly property color accent: "#7BD687"
    readonly property color accentSecondary: "#4B8649"
    readonly property color blue: "#ACB4EB"
    readonly property color gray: "#AAAAAA"
    readonly property color darkGray: "#696969"
    readonly property color white: "#D3D4CB"
    readonly property color black: "#363647"
    readonly property color yellow: "#daee76"
    readonly property color red: "#E17B7B"
    readonly property color darkRed: "#8b4141"
    readonly property color brown: "#a09e45"

    readonly property color text: white
    readonly property color colorUrgent: red
    readonly property color colorBorders: "#696969" 

    // Gradients
    readonly property var bgGradient: Gradient {
        GradientStop { position: 0.0; color: bg }
        GradientStop { position: 1.0; color: "#8044444e"}
    }
    readonly property var transparentGradient: Gradient {
        GradientStop { position: 0.0; color: "transparent" }
    }

    // Sizes
    readonly property int panelHeight: 25
    readonly property int cornerRadius: 5
    readonly property int padding: 10
    readonly property int borders: 0

    // Effects
    readonly property real shadowBlur : 1
    readonly property color shadowColor : black
    readonly property real shadowScale : 1.3
}
