-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        extend_border_grab_area = 100,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { CACHYLBLUE, CACHYLGREEN },
                angle = 45,
            },
            inactive_border = CACHYGRAY,
        },
    },
    group = {
        col = {
            border_active = CACHYLBLUE,
            border_inactive = CACHYGRAY,
            border_locked_active = CACHYDBLUE,
            border_locked_inactive = CACHYGRAY,
        },
        groupbar = {
            col = {
                active = CACHYLGREEN,
                inactive = CACHYGRAY,
                locked_active = CACHYDBLUE,
                locked_inactive = CACHYGRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 4,
        rounding_power = 2,
        active_opacity = 1,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
            special = true,
        },
    },
})
