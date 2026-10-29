------------------
---- MONITORS ----
------------------

-- DVI-D-1 is physically rotated; transform 1 makes it 1080x1920 effective.
-- If the image comes out upside down, change 1 to 3.
hl.monitor({ output = "DVI-D-1",  mode = "1920x1080@60",     position = "0x0",      scale = 1, transform = 1 })
hl.monitor({ output = "DP-1",     mode = "1920x1080@239.76", position = "1080x420", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@30",     position = "3000x420", scale = 2 })

-- Both are held off by video=*:d so Plymouth and SDDM only ever see DP-1.
-- DVI comes back here; the TV waits for SUPER + T.
hl.on("hyprland.start", function()
    hl.exec_cmd("sudo drm-connector DVI-D-1 on")
end)

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("sudo drm-connector HDMI-A-1 toggle"))


--------------------
---- WORKSPACES ----
--------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-1",    persistent = true, default_name = "1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1",    persistent = true, default_name = "2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1",    persistent = true, default_name = "3" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1",    persistent = true, default_name = "4" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1",    persistent = true, default_name = "5" })
