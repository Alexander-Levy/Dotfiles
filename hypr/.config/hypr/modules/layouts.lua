------------------------------------------------------------------------------
-- Levy's Hyprland layouts 
------------------------------------------------------------------------------
hl.config({
    -- Options: dwindle, master, scrolling, monocle.
    general = { layout = "scrolling" },

    -- Layout settings
    master = { new_status = "master" },
    dwindle = { preserve_split = true },
    scrolling = {
        direction                = "right", -- Options:left/right/down/up
        column_width             = 0.5,
        explicit_column_widths   = "0.5, 1.0",
        fullscreen_on_one_column = true,
    },
    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- Disable the random hyprland logo / anime girl background. :)
    },
})

