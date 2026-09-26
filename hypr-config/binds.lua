local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

---------------------------
----- CUSTOM COMMANDS -----
---------------------------

function focusLastWorkspace()
    local currentWorkspace = hl.get_active_workspace()
    local windows = hl.get_windows()

    table.sort(windows, function(a, b)
        return a.focus_history_id < b.focus_history_id
    end)

    for _, w in pairs(windows) do
        if w.monitor == currentWorkspace.monitor and w.workspace ~= currentWorkspace then
            hl.dispatch(
                hl.dsp.focus({ window = w })
            )
            return
        end
    end
    hl.dispatch(
        hl.dsp.focus({ workspace = "previous_per_monitor" })
    )
end

function swapMonitorContents()
    local monitors = hl.get_monitors()
    if #monitors ~= 2 then return end

    local monitor1 = monitors[1]
    local monitor2 = monitors[2]

    local windowsInWorkspace1 = hl.get_workspace_windows(monitor1.active_workspace)
    local windowsInWorkspace2 = hl.get_workspace_windows(monitor2.active_workspace)

    for _, w in pairs(windowsInWorkspace1) do
        hl.dispatch(
            hl.dsp.window.move({ monitor = monitor2, window = w })
        )
    end

    for _, w in pairs(windowsInWorkspace2) do
        hl.dispatch(
            hl.dsp.window.move({ monitor = monitor1, window = w })
        )
    end
end

function moveToMonitorEmptyWorkspace(monitor, currentWindow)
    local workspaces = monitor.name == MONITOR1 and MONITOR1_WORKSPACES or MONITOR2_WORKSPACES

    for _, workspace in ipairs(workspaces) do
        if #hl.get_workspace_windows(workspace) == 0 then
            hl.dispatch(
                hl.dsp.window.move({ workspace = workspace, window = currentWindow })
            )
            return workspace
        end
    end
    return nil
end

function moveToEmptyWorkspace()
    local currentWindow = hl.get_active_window()
    if not currentWindow then return end

    moveToMonitorEmptyWorkspace(currentWindow.monitor, currentWindow)
end

function moveToSecondaryMonitorEmptyWorkspace()
    local monitors = hl.get_monitors()
    if #monitors ~= 2 then return end

    local currentWindow = hl.get_active_window()
    if currentWindow then
        local monitor = monitors[1] == currentWindow.monitor and monitors[2] or monitors[1]
        moveToMonitorEmptyWorkspace(monitor, currentWindow)
    else
        local currentMonitor = currentWindow and currentWindow.monitor or hl.get_active_monitor()
        local otherMonitor = monitors[1] == currentMonitor and monitors[2] or monitors[1]

        local windowsInOtherWorkspace = hl.get_workspace_windows(otherMonitor.active_workspace)
        if #windowsInOtherWorkspace > 0 then
            moveToMonitorEmptyWorkspace(currentMonitor, windowsInOtherWorkspace[1])
        end
    end
end

function toogleMonitor(monitorName)
    return function()
        hl.monitor({ output = monitorName, disabled = hl.get_monitor(monitorName) ~= nil })
    end
end

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

hl.bind(mainMod .. " + SHIFT + F1", toogleMonitor(MONITOR1))
hl.bind(mainMod .. " + SHIFT + F2", toogleMonitor(MONITOR2))


-- Window manipulation
hl.bind(mainMod .. " + Escape",               hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + Escape",       hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /session"))
hl.bind(mainMod .. " + SHIFT + Q",            hl.dsp.window.close())
hl.bind(mainMod .. " + T",                    hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",                    hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",                    hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + R",                    hl.dsp.layout("togglesplit"))

-- Change focus
hl.bind(mainMod .. " + Left",                 hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right",                hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",                   hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",                 hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + Tab",          hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + masculine",            hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + masculine",    hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + Tab",                  focusLastWorkspace)
hl.bind("ALT + Tab",                          hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Q",                    hl.dsp.exec_cmd(noctCall .. "window-switcher"))

hl.bind(mainMod .. " + CONTROL + masculine",  swapMonitorContents)
hl.bind(mainMod .. " + W",                    moveToEmptyWorkspace)
hl.bind(mainMod .. " + SHIFT + W",            moveToSecondaryMonitorEmptyWorkspace)

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + 1",                    hl.dsp.window.move({ monitor = MONITOR1 }))
hl.bind(mainMod .. " + SHIFT + 2",                    hl.dsp.window.move({ monitor = MONITOR2 }))
hl.bind(mainMod .. " + SHIFT + 3",                    hl.dsp.window.move({ monitor = MONITOR3 }))
--hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }))
--hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }))
--hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }))
--hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }))
end

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())


-- Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true})
hl.bind(mainMod .. " + Plus", function() zoomfunction(0.3) end, { repeating = true })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true })


------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return",         hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind(mainMod .. " + E",              hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + C",              hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind("XF86Calculator",               hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind("CONTROL + SHIFT + Escape",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -o confirm_os_window_close=0 -e btop"))
hl.bind(mainMod .. " + X",              hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Space",          hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind("ALT + Space",                  hl.dsp.exec_cmd("timeout 0.1s sh -c 'echo open > /tmp/ualth.pipe'"))
hl.bind(mainMod .. " + period",         hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
hl.bind(mainMod .. " + L",              hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind(mainMod .. " + ALT + C",        hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd("hyprpicker -a -n"))
hl.bind("Print",               hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on workspace number
-- Relative to monitor
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = "m~" .. i }))
end

-- Move to adjacent workspaces and next empty on a given monitor
hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "emptym" }))

hl.bind(mainMod .. " + Less",                  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + z",                     hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Less",          hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + SHIFT + z",             hl.dsp.window.move({ workspace = "m+1" }))

-- Scroll through existing workspaces & monitors
-- hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }))
-- hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }))
-- hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
-- hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special())
