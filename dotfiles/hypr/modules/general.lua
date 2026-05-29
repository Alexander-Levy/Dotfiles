-- ===========================================================================
-- Levy's Hyprland Look and Feel 
-- ===========================================================================
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 5,

        border_size = 2,
        col = {
            active_border   = "rgba(04d1f9ff)",
            inactive_border = "rgba(595959aa)",
        },

        allow_tearing = false,
        resize_on_border = true,
    },
    decoration = {
        rounding       = 5, -- Corners: 1: square, 4 semi, 10 round 
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        -- shadow = {
        --     enabled      = true,
        --     range        = 4,
        --     render_power = 3,
        --     color        = "rgba(1a1a1aee)",
        -- },
        blur = {
            enabled   = true,
            size      = 2,
            passes    = 4,
            vibrancy  = 0.1696,
        },
    },
})

-- Layouts settings
hl.config({
    -- Options: dwindle, master, scrolling, monocle.
    -- Default binds assume scrolling layout, func exists to switch between them.
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

