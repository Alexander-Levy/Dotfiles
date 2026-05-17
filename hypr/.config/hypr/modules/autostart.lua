-- ===========================================================================
-- Levy's Hyprland Autostart 
-- ===========================================================================
hl.on("hyprland.start", function ()
  hl.exec_cmd("waybar")    -- Status Bar 
  hl.exec_cmd("swaync")    -- Notification center
  hl.exec_cmd("hyprpaper") -- Wallpaper 

  hl.exec_cmd("systemctl --user start hyprpolkitagent")       -- Authorization engine
  hl.exec_cmd("wl-paste --type text --watch cliphist store")  -- Copy text
  hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Copy Images
end)

