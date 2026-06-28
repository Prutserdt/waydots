----------------------------------------------------------
---- Hyprland configuration file, created by Prutserd ----
----------------------------------------------------------

-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function () 
  hl.exec_cmd("xrdb ~/.Xresources")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hyprsunset")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("waybar")
  hl.exec_cmd("syncthing")
  hl.exec_cmd("emacs --daemon")
  hl.exec_cmd("sh -c 'wl-paste --type text --watch cliphist store &'")  --  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("sh -c 'wl-paste --type image --watch cliphist store &'") --  hl.exec_cmd("wl-paste --type image --watch cliphist store")
--  hl.exec_cmd("kanata")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

-- Not used, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- My theme

local tokyo_night = {
  bg = "rgb(1a1b26)",
  bg_dark = "rgb(24283b)",
  bg_highlight = "rgb(414868)",
  subtle = "rgb(565f89)",
  fg = "rgb(c0caf5)",
  fg_secondary = "rgb(a9b1d6)",
  red = "rgb(f7768e)",
  orange = "rgb(ff9e64)",
  yellow = "rgb(e0af68)",
  green = "rgb(9ece6a)",
  teal = "rgb(73daca)",
  cyan = "rgb(b4f9f8)",
  blue = "rgb(7aa2f7)",
  purple = "rgb(bb9af7)",
  pink = "rgb(f7768e)",
}

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        repeat_rate = 50,
        repeat_delay = 180,
        touchpad = {
            natural_scroll = false,
        },
    },
})
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,

        border_size = 2,

        col = {
            active_border   = { colors = { tokyo_night.orange } },
            inactive_border = tokyo_night.bg_highlight,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
        layout = "master",
        --layout = "scrolling",
        --layout = "monocle",
    },
    
    decoration = {
        --rounding       = 1,
        --rounding_power = 2,
        rounding       = 10,
        rounding_power = 10,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        
        shadow = {
            enabled      = false,
        },
        
        blur = {
            enabled   =  false,
        },
    },

    animations = {
        enabled = false,
    },
})

-- Curves and animations not used, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more

hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more

hl.config({
    master = {
        new_status = "master",
        orientation = "center",
        slave_count_for_center_master = false,
        new_status = "slave",
        always_keep_position = true,
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------


hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
local rofiMod = "SUPER + CTRL"
local appsMod= "SUPER + CTRL + ALT"

-- Make selected window the master

hl.bind(mainMod .. " + SPACE", hl.dsp.layout("swapwithmaster master"))

-- Open the terminal
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))

-- Kill the active window, with  custom emacs handling
--hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("~/.config/close_window.sh"))

-- Toggle floating

hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- Waybar toggle

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill waybar || waybar"))

-- Lock screen, NOTE: ik denk dat ik super L toch anders ga kiezen zie ook focus directions....
--hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Move focus with mainMod + vim keys
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))

-- Move windows through the stack
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ direction = "down" }))

-- Switch layouts

hl.bind("SUPER + P", hl.dsp.window.pseudo())
-- FIXME, switching to different layouts does not work!
--hl.bind(mainMod .. " + U", hl.dsp.exec_cmd('hyprctl keyword general:layout master'))
--hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd('hyprctl keyword general:layout dwindle'))
--hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd('hyprctl keyword general:layout "dwindle"'))
--hl.bind(mainMod .. " + U", hl.dsp.exec_cmd('hyprctl keyword general:layout "master"'))
--hl.bind(mainMod .. " + I", hl.dsp.exec_cmd('hyprctl keyword general:layout "monocle"'))
--hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("hyprctl keyword general:layout 'scrolling'"))

-- Fullscreen

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ state = 0 }))

-- Workspaces

for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end

-- Move active window to workspace

for i = 1, 5 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Resize active window

-- FIXME: does not work
-- error: x and y are required ddispatcher must be a dispatcher or a lua function
--hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ dx = -20, dy = 0 }))
--hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.resize({ x = -20, y = 0 }))
--hl.bind(mainMod .. " + SHIFT  + L", hl.dsp.window.resize({ x = 20,  y = 0 }))
--hl.bind(mainMod .. " + SHIFT  + K", hl.dsp.window.resize({ x = 0,   y = -20 }))
--hl.bind(mainMod .. " + SHIFT  + J", hl.dsp.window.resize({ x = 0,   y = 20 }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


--hl.bind(mainMod .. " + SHIFT, H", "resizeactive -20 0")
--hl.bind(mainMod .. " + SHIFT + H", hl.dsp.resizeactive, -20, 0)
--hl.bind(mainMod .. " + SHIFT + H", "resizeactive -20 0")
--hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec, "hyprctl dispatch resizeactive -20 0")

-- hl.bind(mainMod .. " + SHIFT + H", function()
--   os.execute("hyprctl dispatch resizeactive -20 0")
-- end)
--hl.bind(mainMod .. " + SHIFT + H", hl.dsp.resizeactive("-20 0"))

-- hl.bind(mainMod .. " + SHIFT + H", function()
--   os.execute("hyprctl dispatch resizeactive -20 0")
-- end)

--hl.bind("H", function()
--  os.execute("notify-send test")
--end)

-- hl.bind("SUPER + SHIFT + H", function()
--   os.execute("notify-send test")
-- end)

--hl.bind("SUPER + SHIFT + H", function()
--  os.execute("hyprctl dispatch resizeactive -20 0")
--end)

--------------------------------
---- APPLICATION BINDINGS ------
--------------------------------

hl.bind(appsMod .. " + E", hl.dsp.exec_cmd("~/.config/open_emacs.sh"))
hl.bind(appsMod .. " + G", hl.dsp.exec_cmd("gimp"))
hl.bind(appsMod .. " + M", hl.dsp.exec_cmd("mousepad"))
hl.bind(appsMod .. " + P", hl.dsp.exec_cmd("keepass ~/stack/WoordenInDeWacht/wachtwoorden.kdbx"))
hl.bind(appsMod .. " + SHIFT + T", hl.dsp.exec_cmd("pcmanfm"))
--hl.bind(appsMod .. " + T", hl.dsp.exec_cmd("ghostty -e yazi"))
hl.bind(appsMod .. " + T", hl.dsp.exec_cmd("ghostty -e zsh -lc yazi"))

------------------------
---- ROFI BINDINGS -----
------------------------

hl.bind(rofiMod .. " + DELETE", hl.dsp.exec_cmd("~/.config/rofi/rofi_delete_process.sh"))
hl.bind(rofiMod .. " + B",      hl.dsp.exec_cmd("~/.config/rofi/rofi_internet_bookmarks.sh"))
hl.bind(rofiMod .. " + D",      hl.dsp.exec_cmd("~/.config/rofi/rofi_app_launcher.sh"))
hl.bind(rofiMod .. " + M",      hl.dsp.exec_cmd("~/.config/rofi/rofi_drive_mounter.sh"))
hl.bind(rofiMod .. " + S",      hl.dsp.exec_cmd("~/.config/rofi/rofi_monitor_selector.sh"))
hl.bind(rofiMod .. " + V",      hl.dsp.exec_cmd("~/.config/rofi/rofi_clipboard_manager.sh"))
hl.bind(rofiMod .. " + W",      hl.dsp.exec_cmd("~/.config/rofi/rofi_wallpaper_selector.sh"))
hl.bind(rofiMod .. " + Q",      hl.dsp.exec_cmd("~/.config/rofi/rofi_exit_hyprland.sh"))

--------------------------------
---- MULTIMEDIA BINDINGS -------
--------------------------------

-- Laptop multimedia keys for volume and LCD brightness

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
--hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86Calculator",         hl.dsp.exec_cmd("[float] qalculate-gtk"))

hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"), { locked = true, repeating = true })
hl.bind("XF86Launch9",            hl.dsp.exec_cmd("hyprctl hyprsunset gamma 100"),  { locked = true })

hl.bind("PRINT",                  hl.dsp.exec_cmd([[sh -c 'xfce4-screenshooter -r -s "$HOME/Downloads"']]))
hl.bind("SHIFT + PRINT",          hl.dsp.exec_cmd("~/.config/screenshot2text.sh"))

--------------------------------
---- TEXTFILES BINDINGS --------
--------------------------------

hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("emacsclient -c -a \"emacs\" ~/stack/Command_line/urls"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("~/stack/rofi/rofi_app_list_update.sh"))

--------------------------------
---- WINDOW RULES --------------
--------------------------------

hl.window_rule({
    name  = "opacity-emacs",
    match = { class = "^Emacs$" },
    opacity = 0.9,
})

-- FIXME: swallowing does not work

--hl.dsp.set({
--    misc = {
--        enable_swallow = true,
--        swallow_regex = "^(Alacritty)$",
--    }
--})

hl.window_rule({ match = { class = "Emacs" }, border_color = tokyo_night.teal }) -- Tokyo Night green

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Workspace rules not used, see  https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
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


-- Hyprland-run windowrule

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
