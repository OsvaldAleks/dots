import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import "root:/styles"

ColumnLayout {
    property alias opener: opener
    QsMenuOpener {
        id: opener
    }
    id: entryList
    spacing: 0
    Repeater {
        model: opener.children
        delegate: MenuItem {
            item: modelData
        }
    }
}

