//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/components/"
import "root:/components/menus"
import "root:/services" as Services

ShellRoot {
    id: root

    Loader {
        id: overview
        active: false
        sourceComponent: Overview{}

        onActiveChanged: {
            if(active){
                Hyprland.activeTopLevel = null
            }
        }
    }

    Loader {
        active: true
        sourceComponent: Bar{}
    }
}
