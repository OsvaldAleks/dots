----------------
--- KEYBINDS ---
----------------
local vars = require("./values.lua")
local utils = require("./utils.lua")

hl.bind( vars.mainMod .. " + Escape", hl.dsp.exit( ))
hl.bind( vars.mainMod .. " + L", hl.dsp.exec_raw( "hyprlock" ))
hl.bind("switch:Lid Switch", hl.dsp.exec_raw( "hyprlock" ))

--- Open apps ---
-----------------
hl.bind( vars.mainMod .. " + Return", hl.dsp.exec_raw( vars.terminal ))
hl.bind( vars.mainMod .. " + D", hl.dsp.exec_raw( vars.fileManagers ))
hl.bind( vars.mainMod .. " + Z", hl.dsp.exec_raw( vars.browser ))

--- Utility
hl.bind( vars.mainMod .. " + C", hl.dsp.exec_raw( "hyprpicker -a -n" ))
hl.bind( "PRINT", hl.dsp.exec_raw( "hyprshot -z -m region" ))
hl.bind( "alt + PRINT", hl.dsp.exec_raw( "hyprshot -z -m window" ))

--- Dmenu
hl.bind( vars.mainMod .. " + space", hl.dsp.exec_raw( vars.menu-toggle ))
hl.bind( vars.mainMod .. " + E", hl.dsp.exec_raw( 'pkill fuzzel || BEMOJI_PICKER_CMD="fuzzel -d" bemoji' ))
hl.bind( vars.mainMod .. " + N", hl.dsp.exec_raw( "pkill fuzzel || networkmanager_dmenu" ))
hl.bind( vars.mainMod .. " + B", hl.dsp.exec_raw( "pkill fuzzel || DMENU_BLUETOOTH_LAUNCHER=fuzzel dmenu-bluetooth" ))

--- Window utilities ---
------------------------
hl.bind( vars.mainMod .. " + Backspace", hl.dsp.window.close() )
hl.bind( vars.mainMod .. " + V", hl.dsp.window.float( "toggle" ))
hl.bind( vars.mainMod .. " + P", hl.dsp.window.pin( ))
hl.bind( vars.mainMod .. " + mouse:274", hl.dsp.window.pin( ))
hl.bind( vars.mainMod .. " + J", hl.dsp.layout( "togglesplit" ) )
hl.bind( vars.mainMod .. " + F", hl.dsp.window.fullscreen_state( "-1 2" ))
hl.bind( vars.mainMod .. " + ALT + F", hl.dsp.window.fullscreen_state( "-1 1" ))

--- Move focus
hl.bind(vars.mainMod .. " + T", function()
    local c = client.focus
    if not c then return end

    if c.floating then
        hl.dsp.cycle_next({ tiled = true })
    else
        hl.dsp.cycle_next({ floating = true })
    end
end)

hl.bind( vars.mainMod .. " + T",    hl.dsp.cycle_next( ) ))
hl.bind( vars.mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind( vars.mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind( vars.mainMod .. " + right",hl.dsp.focus({ direction = "right" }))
hl.bind( vars.mainMod .. " + up",   hl.dsp.focus({ direction = "up" }))
hl.bind( vars.mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

--- Resize using submap
hl.bind( vars.mainMod .. " + mouse:273" hl.dsp.window.resize( ))
hl.bind( vars.mainMod .. " + R", hl.dsp.exec_raw( "~/.config/hypr/scripts/window_control.sh --resize_window" ))

hl.define_submap("resize", function()
    hl.bind("right", hl.resize({ x = 10, y = 0, relative = true}), { repeating = true })
    hl.bind("left", hl.resize({ x = -10, y = 0, relative = true}), { repeating = true })
    hl.bind("up", hl.resize({ x = 0, y = 10, relative = true}), { repeating = true })
    hl.bind("down", hl.resize({ x = 10, y = -10, relative = true}), { repeating = true })

    hl.bind("escape", hl.dsp.exec_raw( "~/.config/hypr/scripts/window_control.sh --disable_resize" ))
    hl.bind("Return", hl.dsp.submap( "~/.config/hypr/scripts/window_control.sh --disable_resize" ))
end)

--- Move floating using submap
hl.bind( vars.mainMod .. " + mouse:272", hl.dsp.window.drag( ))
hl.bind( vars.mainMod .. " + R", hl.dsp.exec_raw( "~/.config/hypr/scripts/window_control.sh --move_window" ))

hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.move({ x = 10, y = 0, relative = true}), { repeating = true })
    hl.bind("left", hl.dsp.window.move({ x = -10, y = 0, relative = true}), { repeating = true })
    hl.bind("up", hl.dsp.window.move({ x = 0, y = 10, relative = true}), { repeating = true })
    hl.bind("down", hl.dsp.window.move({ x = 10, y = -10, relative = true}), { repeating = true })

    hl.bind("escape", hl.dsp.exec_raw( "~/.config/hypr/scripts/window_control.sh --disable_move" ))
    hl.bind("Return", hl.dsp.submap( "~/.config/hypr/scripts/window_control.sh --disable_move" ))
end)

--- Group stuff
hl.bind( vars.mainMod .. " + G", hl.dsp.group.toggle( ))
hl.bind( vars.mainMod .. " + ALT + G", hl.dsp.group.lock_active( ))
hl.bind( vars.mainMod .. " + comma", hl.dsp.group.prev( ))
hl.bind( vars.mainMod .. " + period", hl.dsp.group.next( ))
hl.bind( vars.mainMod .. " + SHIFT + comma", hl.dsp.group.move_window({ forward = false })
hl.bind( vars.mainMod .. " + SHIFT + period", hl.dsp.group.move_window({ forward = true })
for key = 1, 10 do
    hl.bind(mainMod .. " + SHIFT" .. key, hl.dsp.group.active({ index = key }))
end

--- workspaces ---
------------------

for i = 1, 10 do
    local key = i % 10
    --- Switch workspaces (absolute)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i}))
    --- Move active window
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
end

--- Switch workspaces (relative)
hl.bind( vars.mainMod .. " + CTRL + left", hl.dsp.focus( {workspace = "m-1", on_current_monitor = true }))
hl.bind( vars.mainMod .. " + CTRL + right", hl.dsp.focus( {workspace = "m+1", on_current_monitor = true }))
hl.bind( vars.mainMod .. " + mouse_down", hl.dsp.focus( {workspace = "m-1", on_current_monitor = true }))
hl.bind( vars.mainMod .. " + mouse_up", hl.dsp.focus( {workspace = "m+1", on_current_monitor = true }))
hl.bind( vars.mainMod .. " + mouse:273", hl.dsp.focus( {workspace = "empty", on_current_monitor = true }))
hl.bind( vars.mainMod .. " + ALT + up", hl.dsp.focus( {workspace = "empty", on_current_monitor = true }))

--- Move active window (relative)
hl.bind( vars.mainMod .. " + SHIFT + CTRL + left", hl.dsp.window.move( {workspace = "m-1", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + CTRL + right", hl.dsp.window.move( {workspace = "m+1", follow = true }))

--- Toggle special
hl.bind( vars.mainMod .. " + S", hl.dsp.workspace.toggle_special( "main" )

--- media controls ---
----------------------
hl.bind( "XF86AudioRaiseVolume", hl.dsp.exec_raw( "wpctl set-volume -l 1 @DEFAULT_SINK@ .05+" ))
hl.bind( "XF86AudioLowerVolume", hl.dsp.exec_raw( "wpctl set-volume -l 1 @DEFAULT_SINK@ .05-" ))
hl.bind( "XF86AudioMute", hl.dsp.exec_raw( "wpctl set-mute @DEFAULT_SINK@ toggle" ))
hl.bind( "XF86AudioMicMute", hl.dsp.exec_raw( "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ))
hl.bind( "XF86MonBrightnessUp", hl.dsp.exec_raw( "brightnessctl set 5%+" ))
hl.bind( "XF86MonBrightnessDown", hl.dsp.exec_raw( "brightnessctl set 5%-" ))

hl.bind( vars.mainMod .. " + ALT + 1", hl.dsp.exec_raw( "openrgb -c F8DDB8" ))
hl.bind( vars.mainMod .. " + ALT + 2", hl.dsp.exec_raw( "openrgb -c FB7D4C" ))
hl.bind( vars.mainMod .. " + ALT + 3", hl.dsp.exec_raw( "openrgb -c F85909" ))
hl.bind( vars.mainMod .. " + ALT + 4", hl.dsp.exec_raw( "openrgb -c C8C949" ))
hl.bind( vars.mainMod .. " + ALT + 5", hl.dsp.exec_raw( "openrgb -c 78FD38" ))

----------------
--- GESTURES ---
----------------
hl.gesture({
    fingers = 2,
    direction = "pinchin",
    action = utils.handleIn
})

hl.gesture({
    fingers = 2,
    direction = "pinchout",
    action = utils.handleOut
})

hl.gesture({
    fingers = 3,
    direction = "pinchin",
    action = utils.handle3in
})

hl.gesture({
    fingers = 3,
    direction = "pinchout",
    action = utils.handle3out
})
