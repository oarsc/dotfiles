-- Input configuration

hl.config({
    input = {
	    kb_layout = "es",
	    kb_variant = "",
	    kb_model = "",
	    kb_options = "",
	    kb_rules = "",

        accel_profile = "flat",
        repeat_rate = 30,
        repeat_delay = 250,

        follow_mouse = 0,
        -- sensitivity = -0.25,

        touchpad = {
            natural_scroll = false
        }
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    cursor = {
        no_hardware_cursors = 1,
    },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
