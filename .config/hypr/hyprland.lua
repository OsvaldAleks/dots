--- DEVICES
require("./sources/devices.lua")

--- KEYBINDINGS & GESTURES
--- source = ./sources/binds.conf
require("./sources/binds.lua")

--- LOOK AND FEEL
--- source = ./sources/look_and_feel.conf

--- AUTOSTART
require("./sources/autostart.lua")

---------------------------------------------------------
--- OTHER 
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
        font_family = "DejaVu Sans Mono"
    },
})

--- PLUGINS
--- permission = /usr/(bin|local/bin)/hyprpm, plugin, allow

--- source = ./sources/plugins.conf
