-----------------------------------------------------------
---- Hyprland configuration file, created by Prutserdt ----
-----------------------------------------------------------
-- ~/.config/hypr/hyprland.lua

local theme = require("config.theme")
local profiles = require("hardware.profiles")

profiles.setup()
theme.setup()

require("config.monitors").setup()
require("startup").setup()
require("bindings.applications").setup()
require("bindings.main").setup()
require("bindings.media").setup()
require("bindings.rofi").setup()
require("bindings.workspaces").setup()
require("config.appearance").setup(theme.colors, profiles.layout)
require("config.environment").setup()
require("config.input").setup()
require("config.layouts").setup()
require("rules.rules").setup(theme.colors)
