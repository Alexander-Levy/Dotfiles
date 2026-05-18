-- ===========================================================================
-- Levy's Hyprland Look and Feel 
-- ===========================================================================
hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 5,

        border_size = 2,
        col = {
            active_border   = "rgba(00f69bff)",
            inactive_border = "rgba(595959aa)",
        },

        allow_tearing = false,
        resize_on_border = true,
    },

    decoration = {
        rounding       = 6, -- Corners: 1: square, 4 semi, 10 round 
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },
})

