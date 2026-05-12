------------------------------------------------------------------------------
-- Levy's Hyprland input
------------------------------------------------------------------------------
hl.config({
    input = {
        -- Keyboard
        kb_layout    = "us",
        repeat_rate  = 35,
        repeat_delay = 200,
        -- Mouse & Touchpad
        sensitivity  = 0,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal",action = "workspace" })

