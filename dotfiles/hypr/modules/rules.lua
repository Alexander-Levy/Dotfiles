-- ===========================================================================
-- Levy's Hyprland Rules
-- ===========================================================================

-- ===========================================================================
-- Window Rules
-- ===========================================================================
-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Launch steam settings in floating mode but in a smaller window
hl.window_rule({
    name   = "steam-settings",
    match  = { class = "steam", title = "Steam Settings" },
    float  = true,
    center = true,
    size   = {850, 730},
})

-- Launch steam games in fullscreen 
hl.window_rule({
    name       = "steam-game",
    match      = { class = "steam_app_.*" },
    fullscreen = true,
})

-- Launch Nitro Sense Manager floating - Acer Nitro 5
hl.window_rule({
    name   = "Nitro-run",
    match  = { class = "DivAcerManagerMax" },
    float  = true,
    center = true,
})

-- ===========================================================================
-- Waybay widgets
-- ===========================================================================
-- Launch network manager floating 
hl.window_rule({
    name       = "nm-widget",
    match      = { title = "kitty-nmmgr" },
    float = true,
    move  = { 11 , 50 },
})

-- Launch bluetooth manager floating 
hl.window_rule({
    name       = "bl-widget",
    match      = { title = "kitty-blmgr" },
    float = true,
    move  = { 11 , 50 },
})

-- Launch network manager floating 
hl.window_rule({
    name       = "pw-widget",
    match      = { title = "kitty-pwmgr" },
    float = true,
    move  = { 630 , 50 },
})

-- ===========================================================================
-- Workspace Rules
-- ===========================================================================
hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })

