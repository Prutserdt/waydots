-- Central place for commands used by the rest of the configuration.
-- Other config files can load this module with:
--   local programs = require("config.programs")
local programs = {
  terminal = "kitty",
  browser = "firefox",
  file_manager = "thunar",
  launcher = "fuzzel",
  lock = "hyprlock",
}
return programs
