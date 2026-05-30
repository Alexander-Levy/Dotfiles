-- ===========================================================================
-- Levy's Hyprland Programs & Keybinds
-- ===========================================================================
-- Default Programs 
local menu         = "vicinae toggle"
local browser      = "firefox"
local terminal     = "kitty"
local gameLauncher = "steam"

-- Shell Elements
local nitroSense   = "DAMX"
local notification = "swaync-client -t"
local fileManager  = terminal .. " -e yazi"
local taskManager  = terminal .. " -o font_size=13.0 -e btop"

-- Desktop utilities
local lockScreen     = "hyprlock"
local screenshot     = "hyprshot -m region --clipboard-only"
local saveScreenshot = "hyprshot -m region"
local colorPicker    = "hyprpicker -n -a"
local clipBoard      = 'vicinae vicinae://launch/clipboard/history'
local closeSession   = "hyprshutdown"

-- Animated Wallpaper
StartMpvpaper     = "mpvpaper -s -o '--hwdec=auto --vd-lavc-threads=2 --profile=fast no-audio loop' ALL "
AnimatedWallpaper = "~/Wallpapers/Smoking-girl-city.mp4"

-- Restart shell elements
local restartWaybar    = "pkill waybar; waybar"
local changeToHyprpaper = "pkill mpvpaper; hyprpaper"
local changeToMpvpaper  = "pkill hyprpaper; " .. StartMpvpaper .. AnimatedWallpaper
local killWallpapers    = "pkill mpvpaper; pkill hyprpaper"

-- ===========================================================================
-- Keybinds
-- ===========================================================================
local mainMod = "SUPER"

-- App launcher, terminal & close windows
hl.bind("ALT  + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("CTRL + SPACE", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- App switcher
hl.bind("ALT  + TAB", hl.dsp.exec_cmd('snappy-switcher next'))
hl.bind("ALT  + SHIFT + TAB", hl.dsp.exec_cmd('snappy-switcher prev'))

-- Programs
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(gameLauncher))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(nitroSense))

-- System Utilities 
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipBoard))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notification))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(colorPicker))
hl.bind(mainMod .. " + SHIFT+ S", hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + CTRL + SHIFT+ S", hl.dsp.exec_cmd(saveScreenshot))
hl.bind("SUPER + SHIFT + ESCAPE", hl.dsp.exec_cmd(taskManager))

-- Session binds (logout & exit Hyprland)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(lockScreen))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(closeSession))

-- Reload shell
local wallpaperBackend = "animated" -- Options: image or animated
local function toggle_wallpaper()
    if wallpaperBackend == "image" then
        hl.exec_cmd(changeToMpvpaper)
        wallpaperBackend = "animated"
    else
        hl.exec_cmd(changeToHyprpaper)
        wallpaperBackend = "image"
    end
end
hl.bind(mainMod .. " + CTRL + W", toggle_wallpaper)
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(restartWaybar))
hl.bind(mainMod .. " + CTRL + SHIFT + W", hl.dsp.exec_cmd(killWallpapers))

-- ===========================================================================
-- Window binds
-- ===========================================================================
-- Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move window focus 
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- Change window mode:
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" })) -- toggle fullscreen
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))      -- toggle tiled/floating mode

-- ===========================================================================
-- Layout binds
-- ===========================================================================
local currentLayout = "scrolling"

-- Scrolling layout binds
local function bind_scrolling()
    hl.bind(mainMod .. " + K", hl.dsp.layout("swapcol r"))
    hl.bind(mainMod .. " + J", hl.dsp.layout("swapcol l"))
    hl.bind(mainMod .. " + H", hl.dsp.layout("colresize +conf"))
end
local function unbind_scrolling()
    hl.unbind(mainMod .. " + K")
    hl.unbind(mainMod .. " + J")
    hl.unbind(mainMod .. " + H")
end
bind_scrolling() -- Enable scrolling binds (default layout)

-- Dwindle layout binds
local function bind_dwindle()
    hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
    hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"))
end
local function unbind_dwindle()
    hl.unbind(mainMod .. " + J")
    hl.unbind(mainMod .. " + K")
end

-- Toggle between scrolling and dwindle
local function toggle_layout()
    if currentLayout == "scrolling" then
        -- Change layout binds
        hl.timer(function()
            unbind_scrolling()
            bind_dwindle()
        end, { timeout = 50, type = "oneshot" })
        hl.config({
            general = {
                layout = "dwindle",
                col = { active_border = "rgba(37f499ff)" }, -- Change borders to green (dwindle)
            }
        })
        currentLayout = "dwindle"
    else
        -- Change layout binds
        hl.timer(function()
            unbind_dwindle()
            bind_scrolling()
        end, { timeout = 50, type = "oneshot" })
        hl.config({
            general = {
                layout = "scrolling",
                col = { active_border = "rgba(04d1f9ff)" }, -- Change borders to blue (scrolling)
            }
        })
        currentLayout = "scrolling"
    end
end

-- Toggle between dwindle and scrolling layouts
hl.bind(mainMod .. " + CTRL + T", toggle_layout)

-- ===========================================================================
-- Floating Mode
-- ===========================================================================
local floating_workspaces = {}
local function toggle_workspace_float()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local ws_id = ws.id

    floating_workspaces[ws_id] = not (floating_workspaces[ws_id] or false)
    local should_float = floating_workspaces[ws_id]
    -- Toggle all existing windows on this workspace
    for _, win in ipairs(hl.get_windows()) do
        if win.workspace.id == ws_id and win.floating ~= should_float then
            -- Pass the window object directly as the selector
            hl.dispatch(hl.dsp.window.float({ action = "toggle", window = win }))
        end
    end
    -- Add/remove a window rule so new windows on this workspace open floating
    local rule_name = "ws-float-" .. ws_id
    local rule = hl.window_rule({
        name = rule_name,
        match = { workspace = tostring(ws_id) },
        float = true,
    })
    rule:set_enabled(should_float)
end
hl.bind(mainMod .. " + CTRL + SHIFT + T", toggle_workspace_float)

-- ===========================================================================
-- Workspaces binds
-- ===========================================================================
-- Switch workspaces & move windows around workspaces 
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Move through existing workspaces
hl.bind("CTRL + SUPER + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + SUPER + right", hl.dsp.focus({ workspace = "e+1" }))

-- ===========================================================================
-- Media binds
-- ===========================================================================
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

