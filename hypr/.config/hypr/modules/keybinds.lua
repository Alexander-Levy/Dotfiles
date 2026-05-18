-- ===========================================================================
-- Levy's Hyprland Programs & Keybinds
-- ===========================================================================
-- Default Programs 
local menu         = "wofi"
local browser      = "firefox"
local terminal     = "kitty"
local gameLauncher = "steam"

-- Shell Elements
local nitroSense   = "DAMX"
local lockScreen   = "hyprlock"
local notification = "swaync-client -t"
local fileManager  = terminal .. " -e yazi"
local taskManager  = terminal .. " -o font_size=14.0 -e btop"
local closeSession = "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"

-- Utilities
local colorPicker = "hyprpicker -n -a"
local screenSaver = terminal .. " -e cmatrix -sa -u 3 -C cyan"
local clipBoard   = 'cliphist list | wofi --dmenu --pre-display-cmd "echo \'%s\' | cut -f 2" | cliphist decode | wl-copy'

-- ===========================================================================
-- Keybinds
-- ===========================================================================
local mainMod = "SUPER"

-- App launcher, terminal & close windows
hl.bind("ALT  + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Programs
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(gameLauncher))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(nitroSense))
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.exec_cmd(taskManager))

-- System Utilities 
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipBoard))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notification))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(colorPicker))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(screenSaver))

-- Session binds (logout & exit Hyprland)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lockScreen))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(closeSession))

-- Change window Mode: Tiled, Floating, Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- Rearrange tiled windows (scrolling)
hl.bind(mainMod .. " + K", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + J", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + H", hl.dsp.layout("colresize +conf"))

-- Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move window focus 
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- Switch workspaces & move windows around workspaces 
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Move through existing workspaces
hl.bind("CTRL + SUPER + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + SUPER + right", hl.dsp.focus({ workspace = "e+1" }))

-- Laptop multimedia keys for play, pause, fowards and reverse
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Laptop multimedia keys for volume and screen brightness
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })

