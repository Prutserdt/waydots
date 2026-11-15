-- theme.lua

local M = {}

M.colors = {
  bg           = "#1a1b26",
  bg_dark      = "#24283b",
  bg_highlight = "#414868",
  subtle       = "#565f89",
  fg           = "#c0caf5",
  fg_secondary = "#a9b1d6",
  red          = "#f7768e",
  orange       = "#ff9e64",
  yellow       = "#e0af68",
  green        = "#9ece6a",
  teal         = "#73daca",
  cyan         = "#b4f9f8",
  blue         = "#7aa2f7",
  purple       = "#bb9af7",
  pink         = "#f7768e",
}

function M.setup()
  -- Put Hyprland theme configuration here, if needed.
  -- Example:
  -- hl.config({
  --   general = {
  --     col.active_border = M.colors.blue,
  --   },
  -- })
end

return M
