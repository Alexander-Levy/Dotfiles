-- ===========================================================================
-- Levy's Hyprland Plugins
-- ===========================================================================
hl.config({
    plugin = {
        scrolloverview = {
            gesture_distance = 300, -- how far is the "max" for the gesture
            scale = 0.5,            -- preferred overview scale
            workspace_gap = 100,
            layout = "vertical",    -- vertical or horizontal
            wallpaper = 0,          -- 0: global only, 1: per-workspace only, 2: both
            blur = true,           -- blur only the main overview wallpaper
        },
    },
})

-- Toggle ScrollOverview with {Super + Tab} or with 3 finger gesture on touchpad
hl.bind("SUPER + TAB", function()
    hl.plugin.scrolloverview.overview("toggle all")
end)
hl.plugin.scrolloverview.gesture({ fingers = 3, direction = "vertical" })
