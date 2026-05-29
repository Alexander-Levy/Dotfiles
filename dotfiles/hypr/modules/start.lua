-- ===========================================================================
-- Levy's Hyprland Autostart 
-- ===========================================================================
hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")         -- Status Bar 
    hl.exec_cmd("swaync")         -- Notification center
    -- hl.exec_cmd("hyprpaper")      -- Wallpaper 
    hl.exec_cmd("vicinae server") -- App launcher
    hl.exec_cmd("snappy-switcher --daemon") -- App switcher
    hl.exec_cmd(StartMpvpaper .. AnimatedWallpaper) -- Animated wallpaper 
    hl.exec_cmd("systemctl --user start hyprpolkitagent") -- Authorization engine
end)

