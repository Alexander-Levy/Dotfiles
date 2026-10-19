-- ===========================================================================
-- Levy's Hyprland Programs & Keybinds
-- ===========================================================================
local mainMod = "SUPER"
local ipc     = "noctalia msg "

-- Default Programs 
local browser      = "zen-browser"
local terminal     = "kitty"
local gameLauncher = "steam"

-- Shell Elements
local fileManager  = terminal .. " -e yazi"
local taskManager  = terminal .. " -o font_size=12.0 -e btop"

-- Desktop utilities
local closeSession   = "hyprshutdown"
local colorPicker    = "hyprpicker -n -a"

-- ===========================================================================
-- Functions
-- ===========================================================================
-- Keybinds for scrolling layout
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

-- Keybinds for dwindle layout 
local function bind_dwindle()
    hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
    hl.bind(mainMod .. " + K", hl.dsp.layout("swapsplit"))
end
local function unbind_dwindle()
    hl.unbind(mainMod .. " + J")
    hl.unbind(mainMod .. " + K")
end

-- Toggle between scrolling & dwindle layouts
local currentLayout    = "scrolling"
local function toggle_layout()
    if currentLayout == "scrolling" then
        hl.timer(function()
            unbind_scrolling()
            bind_dwindle()
        end, { timeout = 50, type = "oneshot" })
        hl.config({
            general = { layout = "dwindle", col = { active_border = "rgba(37f499ff)" } }
        })
        currentLayout = "dwindle"
    else
        hl.timer(function()
            unbind_dwindle()
            bind_scrolling()
        end, { timeout = 50, type = "oneshot" })
        hl.config({
            general = { layout = "scrolling", col = { active_border = "rgba(04d1f9ff)" } }
        })
        currentLayout = "scrolling"
    end
end

-- Make all windows in a workspace float 
local floating_workspaces = {}
local function toggle_workspace_float()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local ws_id = ws.id
    floating_workspaces[ws_id] = not (floating_workspaces[ws_id] or false)
    local should_float = floating_workspaces[ws_id]
    for _, win in ipairs(hl.get_windows()) do
        if win.workspace.id == ws_id and win.floating ~= should_float then
            hl.dispatch(hl.dsp.window.float({ action = "toggle", window = win }))
        end
    end
    local rule = hl.window_rule({
        name = "ws-float-" .. ws_id,
        match = { workspace = tostring(ws_id) },
        float = true,
    })
    rule:set_enabled(should_float)
end

-- ===========================================================================
-- General binds
-- ===========================================================================
-- App launcher, terminal & close windows
hl.bind("ALT + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Programs
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(gameLauncher))

-- System Utilities 
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(colorPicker))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd(taskManager))

-- Shell elements
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ipc .. "panel-open clipboard"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(ipc .. "panel-toggle noctalia/mpvpaper:picker"))
hl.bind(mainMod .. " + SHIFT+ S",        hl.dsp.exec_cmd(ipc .. "screenshot-region"))
hl.bind(mainMod .. " + CTRL + SHIFT+ S", hl.dsp.exec_cmd(ipc .. "screenshot-annotate"))

-- Session binds (logout & exit)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(ipc .. "session lock"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(closeSession))

-- ===========================================================================
-- Window binds
-- ===========================================================================
-- Move window focus 
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true }) -- Move windows
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Resize windows

-- Change window mode
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" })) -- toggle tiled/floating mode
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" })) -- toggle fullscreen

-- Layout binds
hl.bind(mainMod .. " + CTRL + T", toggle_layout) -- Toggle between dwindle and scrolling layouts
hl.bind(mainMod .. " + CTRL + SHIFT + T", toggle_workspace_float) -- Toggle per workspace floating mode

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

-- ===========================================================================
-- Volume and Brightness binds
-- ===========================================================================
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(ipc .. "mic-mute"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

