---------------
--- GENERAL ---
---------------

--- Modifiers
local mod = SUPER

--- Colors
local white = "rgba(d3d4cbff)"
local blue = "rgba(acb4ebff)"
local active_border = "rgb(d3d4cb)"
local inactive_border = "rgba(14141e80)"
local warning = "rgba(e17b7bff)"
local text = "rgba(14141eff)"
local active_shadow = "rgba(14141edd)"
local inactive_shadow = "rgba(14141e55)"
local black = "rgb(14141e)"
local green = "rgb(7bd687)"

--- Look and feel
local rounding = 5
local gaps = 5
local borders = 0

local blur_size = 5
local blur_passes = 3
local noise = 0.05
local contrast = 0.5
local vibrancy = 0.1
local vibrancy_darkness = 0.1

--- Programs
local terminal = "kitty"
local fileManager = "nautilus &"
local browser = "zen-browser"
local menu = "fuzzel"
local menu-toggle = "pkill fuzzel || $menu"

---------------------
--- ENV VARIABLES ---
---------------------

hl.env("HYPRSHOT_DIR", "/home/aleks/Pictures/Screenshots")

hl.env("LIBVA_DRIVER_NAME","nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
