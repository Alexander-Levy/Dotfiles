-- ===========================================================================
-- Levy's Hyprland Animations 
-- ===========================================================================
hl.config({ animations = { enabled = true } })

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Animations
hl.animation({ leaf = "global",     enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7,    bezier = "quick" })
hl.animation({ leaf = "windows",    enabled = true, speed = 1.5,  bezier = "quick",   style = "slide bottom" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.27, bezier = "linear",  style = "popin" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5,  bezier = "default", style = "slidevert" })
