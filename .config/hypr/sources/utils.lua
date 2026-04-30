--- BASE ---
------------
-- get active window info
local function get_active_window_json(callback)
    hl.exec_cmd("hyprctl activewindow -j", function(out)
        callback(out)
    end)
end

-- get active workspace info
local function get_workspace_info(id, callback)
    hl.exec_cmd("hyprctl workspaces -j", function(out)
        callback(out)
    end)
end

--- PINCHES ---
---------------
--- 2 finger window pinches
local function handleIn()
    get_active_window_json(function(wininfo)
        local floating   = wininfo:match('"floating":%s*(%w+)') == "true"
        local fullscreen = tonumber(wininfo:match('"fullscreen":%s*(%d+)')) or 0
        local workspace  = tonumber(wininfo:match('"workspace":%s*{[^}]-"id":%s*(%d+)'))

        if floating then
            hl.dsp.window.float({ action = "toggle" })
        else
            get_workspace_info(workspace, function(wsinfo)
                local num = tonumber(wsinfo:match('"id":%s*'..workspace..'.-"windows":%s*(%d+)')) or 0

                if num == 1 then
                    hl.dsp.window.fullscreenstate({ internal = 2, client = -1 })
                else
                    if fullscreen < 2 then
                        hl.dsp.window.fullscreenstate({ internal = fullscreen + 1, client = -1 })
                    end
                end
            end)
        end
    end)
end

local function handleOut()
    get_active_window_json(function(wininfo)
        local floating   = wininfo:match('"floating":%s*(%w+)') == "true"
        local fullscreen = tonumber(wininfo:match('"fullscreen":%s*(%d+)')) or 0
        local workspace  = tonumber(wininfo:match('"workspace":%s*{[^}]-"id":%s*(%d+)'))

        if fullscreen > 0 then
            get_workspace_info(workspace, function(wsinfo)
                local num = tonumber(wsinfo:match('"id":%s*'..workspace..'.-"windows":%s*(%d+)')) or 0

                if num == 1 then
                    hl.dsp.window.fullscreenstate({ internal = 0, client = -1 })
                else
                    hl.dsp.window.fullscreenstate({ internal = fullscreen - 1, client = -1 })
                end
            end)
        elseif not floating then
            hl.dsp.window.float({ action = "toggle" })
end

--- 3 finger enviroment pinches
local statefile = "/tmp/hyprexpo_active"

local function handle3in()
    hl.exec_cmd("test -f " .. statefile .. " && echo 1 || echo 0", function(out)
        if out:match("1") then
            hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo select")
            hl.exec_cmd("rm " .. statefile)
        else
            hl.exec_cmd("pgrep -x fuzzel", function(p)
                if p == "" then
                    hl.dsp.exec_cmd("fuzzel --show drun")
                end
            end)
        end
    end)
end

local function handle3out()
    hl.exec_cmd("pgrep -x fuzzel", function(p)
        if p == "" then
            hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo toggle")
            hl.exec_cmd("touch " .. statefile)
            hl.dsp.exec_cmd("hyprctl dispatch hyprexpo:expo on")
        else
            hl.exec_cmd("pkill fuzzel")
        end
    end)
end
