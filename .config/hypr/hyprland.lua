-----------------------------------------------------------
---- Hyprland configuration file, created by Prutserdt ----
-----------------------------------------------------------
  
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})
-- FIXME. monitors.lua werkt niet? require("monitors").setup()

local system = require("system")
local theme = require("theme")

system.setup()
theme.setup()

require("autostart").setup()
require("environment").setup()
require("keybinds_main").setup()
require("keybinds_rofi").setup()
require("keybinds_applications").setup()
require("input").setup()
require("layouts").setup()
require("multimedia").setup()
require("appearance").setup(theme.colors, system.layout)
require("rules").setup(theme.colors)

----------------
----  MISC  ----
----------------

hl.config({
  misc = {
    force_default_wallpaper = -1,            -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo   = false,         -- If true disables the random hyprland logo / anime girl background. :(
    enable_swallow = true,                   -- Window swallowing for my terminal
    swallow_regex = "com.mitchellh.ghostty", -- The classname of ghostty is very weird!
  },
})

