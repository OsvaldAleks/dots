pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: net

    property string connectionName: "Disconnected"
    property string connectionType: "none"

    // ---- helper: authoritative snapshot ----
    Process {
        id: nmcliSnapshot

        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "device"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                // format: wlan0:wifi:connected:Redmi A3
                const parts = line.split(":")
                if (parts.length < 4) return

                const device = parts[0]
                const type = parts[1]
                const state = parts[2]
                const conn = parts[3]

                if (state === "connected") {
                    net.connectionName = conn
                    net.connectionType = (type === "wifi") ? "wifi" : "ethernet"
                }
                nmcliSnapshot.running = false
            }
        }
    }

    // ---- event stream ----
    Process {
        id: monitor

        command: ["nmcli", "monitor"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                // We only react to meaningful transitions

                if (line.includes("primary connection")) {
                    // force refresh full state (important)
                    nmcliSnapshot.running = true
                    return
                }

                if (line.includes("connected") && line.includes("wlan")) {
                    nmcliSnapshot.running = true
                    return
                }

                if (line.includes("disconnected") || line.includes("no primary")) {
                    net.connectionName = "Disconnected"
                    net.connectionType = "none"
                }
            }
        }
    }
}
