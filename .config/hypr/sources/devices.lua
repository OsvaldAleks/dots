---------------
--- OUTPUTS ---
---------------

--- MONITOR SETUP ---
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

--- mirror
hl.monitor({
   output   = ""
   mirror   = "eDP-1"
})

--- HDMI out
--- monitor = ,preferred, 1920x540, 1
hl.monitor({
   output   = "HDMI-A-1"
    mode     = "preferred",
    position = "1920x0",
    scale    = "1",
})

--- phone
--- monitor = HEADLESS-66, 720x1650@60, -721x720, 1, transform, 2
--- iPad
--- monitor = HEADLESS-67, 2266x1488@60, 2560x-948, 1

hl.workspace_rule({ workspace = "0", persistent = true, default = true})
hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", })
hl.workspace_rule({ workspace = "4" })

--------------
--- INPUTS ---
--------------
hl.config({
    input = {
        kb_layout  = "si",
        numlock_by_default = true,
        touchpad = {
            natural_scroll = true,
        },
    },
})

device {
    name =    
    sensitivity = 0
}

hl.device({
    name = "logitech-wireless-mouse-1",
    accel_profile = "flat"
})
