------------------
---- MONITORS ----
------------------

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "noctalia msg panel-toggle launcher"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        border_size = 0, -- default 1
    },

    decoration = {
        rounding = 10, -- default 0

        inactive_opacity = 0.95, -- default 1

        shadow = {
            range = 12, -- default 4
        },

        blur = {
            xray   = true, -- default false
            size   = 3,    -- default 8
            passes = 2,    -- default 1
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- default false
    },

    misc = {
        -- Disables the built-in mascot wallpaper, not just a logo.
        disable_hyprland_logo = true, -- default false
    },
})

-- Everything stays instant except the focus opacity fade (fadeSwitch).
-- speed is in units of 100ms, so 2 = 200ms.
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.animation({ leaf = "global",     enabled = false })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "easeOutQuint" })


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us, gr",
        kb_options = "grp:win_space_toggle",

        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.device({ name = "syna32aa:00-06cb:ce17-touchpad", accel_profile = "adaptive" })

hl.device({ name = "syna32aa:00-06cb:ce17-mouse", accel_profile = "adaptive" })


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local ipc     = "noctalia msg "

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- "fullscreen" covers the bar and drops gaps; "maximized" keeps both.
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Resize window with mainMod + Shift + arrow keys
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x =  10, y =   0, relative = true }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -10, y =   0, relative = true }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x =   0, y = -10, relative = true }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x =   0, y =  10, relative = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lock screen
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind("ALT + Tab",           hl.dsp.exec_cmd(ipc .. "window-switcher hold"))

-- SUPER on its own. Binding a modifier to itself needs release, otherwise it
-- fires on press and every SUPER combo triggers it too.
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"), { release = true })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"))

-- Laptop multimedia keys. Routed through noctalia so its OSD shows the
-- change; wpctl/brightnessctl would adjust silently.
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(ipc .. "volume-up"),      { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(ipc .. "volume-down"),    { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(ipc .. "volume-mute"),    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(ipc .. "brightness-up"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"),{ locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),{ locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignore maximize requests from apps.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Float dialogs. XWayland apps advertise _NET_WM_WINDOW_TYPE_DIALOG and float
-- on their own; native Wayland apps have no such hint in xdg-shell, so their
-- dialogs are plain toplevels that dwindle tiles. These rules approximate the
-- hint.

-- Portal dialogs — file pickers, screenshare picker
hl.window_rule({
    name  = "float-portal-gtk",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
})

hl.window_rule({
    name  = "float-portal-impl-gtk",
    match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" },
    float = true,
})

-- GTK/Qt dialog toplevels, matched by title
hl.window_rule({
    name  = "float-dialog-titles",
    match = { title = "^(Open|Open File|Open Files|Open Folder|Save|Save As|Save File|Choose Files|Select a File)$" },
    float = true,
})

hl.window_rule({
    name   = "center-floating",
    match  = { float = true },
    center = true,
})

hl.window_rule({
    name  = "noctalia-settings",
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size  = { 1080, 920 },
})

hl.layer_rule({
    name  = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim      = true,
    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

------------------
---- THEMING ----
------------------

local ok, theme = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/noctalia.lua")
if ok and type(theme) == "table" and theme.apply_theme then
    theme.apply_theme()
end
