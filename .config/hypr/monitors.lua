-- ~/.config/hypr/lua/monitors.lua

local M = {}

function M.setup()
  hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
  })

  return M

