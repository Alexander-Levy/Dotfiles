-- ===========================================================================
-- Levy's Hyprland Monitor & Scaling
-- ===========================================================================
hl.monitor({
    output   = "",
    mode     = "1920x1080@144",
    position = "auto",
    scale    = "1.20",
})

-- Unscale xwayland
hl.config({
    xwayland = { force_zero_scaling = true }
})

-- ===========================================================================
-- Enviroment Variables 
-- ===========================================================================
hl.env("XCURSOR_SIZE",    "26")
hl.env("HYPRCURSOR_SIZE", "26")

hl.env("GDK_SCALE", "1.20")
