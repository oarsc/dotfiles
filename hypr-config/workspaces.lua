-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.

MONITOR1_WORKSPACES = {}
MONITOR2_WORKSPACES = {}

for i = 1, 8 do
	local name = tostring(i)
	hl.workspace_rule({ workspace = name, monitor = MONITOR1, default = i==1, persistent = i < 5 })
    table.insert(MONITOR1_WORKSPACES, name)
end

for i = 9, 16 do
	local name = tostring(i)
	hl.workspace_rule({ workspace = name, monitor = MONITOR2, default = i==9, persistent = i < 13 })
    table.insert(MONITOR2_WORKSPACES, name)
end

-- special workspaces
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = false })

-- For other layouts such as scrolling, see example below
-- hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true, layout = "master" })
