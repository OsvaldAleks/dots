//@ pragma UseQApplication

import QtQuick
import Quickshell
import "root:/components/"
import "root:/components/menus"
import "root:/services" as Services

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Bar{}
    }

    Loader {
        active: false
        sourceComponent: RightEdge{}
    }
}
