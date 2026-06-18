---------------
--- GENERAL ---
---------------
local val = {}

--- Modifiers
val.mainMod = "SUPER"

--- Colors
val.white = "rgba(F1E4D0ff)"
val.blue = "rgba(45CBCEff)"
val.active_border = "rgba(89847d80)"
val.inactive_border = "rgba(1D1C1A80)"
val.warning = "rgba(F2412Aff)"
val.text = "rgba(1D1C1Aff)"
val.active_shadow = "rgba(1D1C1A77)"
val.inactive_shadow = "rgba(1D1C1A22)"
val.black = "rgb(1D1C1A)"
val.accent = "rgb(ead91f)"
val.color_transparent = "rgba(00000000)"

--- Look and feel
val.rounding = 3
val.gaps = 5
val.borders = 2

val.blur_size = 3
val.blur_passes = 2
val.noise = 0.05
val.contrast = 0.8
val.vibrancy = 0.4
val.vibrancy_darkness = 0.3

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
