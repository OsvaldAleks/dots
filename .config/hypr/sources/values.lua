---------------
--- GENERAL ---
---------------
local val = {}

--- Modifiers
val.mainMod = "SUPER"

--- Colors
val.white = "rgba(d3d4cbff)"
val.blue = "rgba(acb4ebff)"
val.active_border = "rgba(aaaaaa80)"
val.inactive_border = "rgba(14141e80)"
val.warning = "rgba(e17b7bff)"
val.text = "rgba(14141eff)"
val.active_shadow = "rgba(14141e77)"
val.inactive_shadow = "rgba(14141e22)"
val.black = "rgb(14141e)"
val.green = "rgb(7bd687)"
val.color_transparent = "rgba(00000000)"

--- Look and feel
val.rounding = 5
val.gaps = 5
val.borders = 1

val.blur_size = 3
val.blur_passes = 2
val.noise = 0.05
val.contrast = 0.7
val.vibrancy = 0.2
val.vibrancy_darkness = 0.2

--- Programs
val.terminal = "kitty"
val.fileManager = "nautilus &"
val.browser = "zen-browser"
val.menu = "fuzzel"
val.menuToggle = "pkill fuzzel || fuzzel"

---------------------
--- ENV VARIABLES ---
---------------------

hl.env("HYPRSHOT_DIR", "/home/aleks/Pictures/Screenshots")

hl.env("LIBVA_DRIVER_NAME","nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")

return val
