-- ===========================================================================
-- Levy's Hyprland Plugins
-- ===========================================================================
local function plugin_loaded(name)
    for _, plugin in pairs(hl.get_loaded_plugins()) do
        if plugin.name == name then
            return true
        end
    end
    return false
end

if plugin_loaded("scrolloverview") then
    hl.config({
        plugin = {
            scrolloverview = {
                gesture_distance = 300,
                scale = 0.55,
                workspace_gap = 100,
                layout = "vertical", -- vertical | horizontal
                wallpaper = 0,       -- 0: global, 1: per-workspace, 2: both
                blur = true,
            },
        },
    })

    hl.bind("SUPER + TAB", function()
        hl.plugin.scrolloverview.overview("toggle all")
    end)
    hl.plugin.scrolloverview.gesture({
        fingers = 3, direction = "vertical",
    })
end
