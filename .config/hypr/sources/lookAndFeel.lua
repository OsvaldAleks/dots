local vars = require("sources.values")

hl.config({
    general = {
        gaps_in = vars.gaps,
        gaps_out = 2 * vars.gaps,

        border_size = vars.borders,

        col = {
            active_border = vars.color_transparent,
            inactive_border = vars.color_transparent,
        },

        resize_on_border = true,
        allow_tearing = false,

        layout=dwindle,

        snap = {
            enabled = true,
            respect_gaps = true
        }
    },

    dwindle = {
        smart_split = false,
        preserve_split = true
    },

    scrolling = {
        fullscreen_on_one_column = false,
        follow_min_visible = 1.1,
        focus_fit_method = 0
    },

    group = {
        focus_removed_window = false,
        merge_floated_into_tiled_on_groupbar = true,
        col = {
            border_active = vars.color_transparent,
            border_inactive = vars.color_transparent,
            border_locked_active = vars.color_transparent,
            border_locked_inactive = vars.color_transparent,
        },
        groupbar = {
            col = {
                active = vars.white,
                inactive = vars.inactive_border,
                locked_active = vars.active_border,
                locked_inactive = vars.black
            },
            indicator_height = 25,
            indicator_gap = 0,
            gaps_in = vars.gaps,
            gaps_out = vars.gaps,
            keep_upper_gap = false,
            rounding = vars.rounding,
            round_only_edges = false,
            blur = true,
            font_size = 14,
            height = 1,
            text_color = vars.text,
            text_color_inactive = vars.active_border,
            text_padding = vars.gaps,
            text_offset = -13
        }
    },

    cursor = {
        default_monitor = "eDP-1",
        inactive_timeout = 180,
        persistent_warps = true,
        hide_on_key_press = true
    },

    decoration = {
        rounding = vars.rounding,
        rounding_power = 2,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_around = 0.1,
        dim_special = 0.1,

        active_opacity = 1.0,
        inactive_opacity = 0.85,

        shadow = {
            enabled = true,
            range = 50,
            render_power = 2,
            color = vars.active_shadow,
            color_inactive= vars.inactive_shadow
        },

        blur = {
            enabled = true,
            size = vars.blur_size,
            passes = vars.blur_passes,

            vibrancy = vars.vibrancy,
            vibrancy_darkness = vars.vibrancy_darkness,
            noise = vars.noise,
            contrast = vars.contrast,

            popups = true,
            ignore_opacity = false,
            popups_ignorealpha = 0.49
        }
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
        font_family = "DejaVu Sans Mono"
    },
})


hl.window_rule({ match = { workspace = "special:main" }, border_color = vars.active_border })

hl.window_rule({ match = { float = false }, border_color = vars.color_transparent })
hl.window_rule({ match = { float = false }, no_shadow = false })
hl.window_rule({ match = { float = false }, opacity = "1.0 1.0" })
hl.window_rule({ match = { pin = true }, border_color = vars.active_border })
hl.window_rule({ match = { pin = true }, no_shadow = true })
hl.window_rule({ match = { pin = true }, opacity = "1.0 override 1.0 override" })

hl.window_rule({ match = { fullscreen_state_internal = 1 }, border_color = vars.white })
hl.window_rule({ match = { fullscreen_state_internal = 1 }, opacity = "1.0 override 1.0 override" })

hl.window_rule({ match = { fullscreen_state_internal = 1 }, border_size = vars.borders })


--[[

# PINNED RULES

windowrule = match:pin true, border_color $active_border $active_border $active_border
windowrule = match:pin true, opacity 1.0 override 1.0 override

# RIGHT CLICK MENUS
windowrule=match:class ^()$,match:title ^()$, no_blur off
windowrule=match:class ^()$,match:title ^()$, opaque 0

# FULLSCREEN WINDOWS
windowrule=match:fullscreen_state_internal 1, border_size 2
]]

hl.layer_rule({ match = { namespace = "launcher" }, blur = true, dim_around = true })

hl.layer_rule({ match = { namespace = "notifications" }, blur = true})

hl.layer_rule({ match = { namespace = "quickshell" }, blur = true})

hl.layer_rule({ match = { namespace = "quickshell" }, ignore_alpha = 0.49})

hl.layer_rule({ match = { namespace = "^hypr.*" }, no_anim = true })
--[[

# Fuzzel
layerrule=match:namespace launcher, blur on
layerrule=match:namespace launcher, dim_around on
# dunst
layerrule=match:namespace notifications, blur on
# Quickshell
layerrule=match:namespace quickshell,blur on

layerrule=match:namespace ^hypr.*,no_anim on
layerrule=match:namespace selection,no_anim on
layerrule=match:namespace swww-daemon, no_anim on

layerrule=match:namespace ^.*, ignore_alpha 0.49

--]]


hl.curve( "quick", { type = "bezier", points = { {0.7, 0.9}, {0.1, 1.0} } } )
hl.curve( "overshoot", { type = "bezier", points = { {0.5, 0.9}, {0.1, 1.1} } } )

hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "quick" })

hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "overshoot", style = "slide" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 4, bezier = "overshoot" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2, bezier = "quick" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "overshoot", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2, bezier = "overshoot", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, bezier = "overshoot", style = "slide top" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 1, bezier = "quick" })

--[[

# https://wiki.hyprland.org/Configuring/Variables/#animations
animations {
    enabled = true

    # https://wiki.hyprland.org/Configuring/Animations/
    bezier = easeOutQuint,0.23,1,0.32,1
    bezier = almostLinear,0.5,0.5,0.75,1.0
    bezier = quick,0.5,0,0.1,1

    animation = global, 1, 10, quick
    animation = border, 1, 5.39, easeOutQuint
    animation = windows, 1, 2, easeOutQuint
    animation = windowsIn, 1, 2, easeOutQuint, popin 87%
    animation = windowsOut, 1, 1.49, quick, popin 87%
    animation = fadeIn, 1, 1.73, almostLinear
    animation = fadeOut, 1, 1.46, almostLinear
    animation = fade, 1, 3.03, quick
    animation = layers, 1, 1.2, quick, slidevert
    animation = layersIn, 1, 1.2, quick, slidevert
    animation = layersOut, 1, 1.2, quick, slidevert
    animation = fadeLayersIn, 1, 1.79, almostLinear
    animation = fadeLayersOut, 1, 1.39, almostLinear
    animation = workspaces, 1, 1.5, almostLinear
    animation = workspacesIn, 1, 1.2, almostLinear
    animation = workspacesOut, 1, 1.2, almostLinear
    animation = specialWorkspace, 1, 1.4, quick, slidevert 20%
}

]]
