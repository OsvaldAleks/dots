import QtQuick
import "root:/styles"

ShaderEffect {
    property color color : Style.black
    property real blur : 20
    property real radius : Style.cornerRadius
    property size rectSize 
    property vector3d iResolution

    fragmentShader : Qt.resolvedUrl("ignoreBgShadow.frag.qsb")
    vertexShader : Qt.resolvedUrl("ignoreBgShadow.vert.qsb")
}
