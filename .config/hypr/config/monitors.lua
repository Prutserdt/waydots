-- ~/.config/hypr/config/monitors.lua

local M = {}

function M.setup()
  hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
  })
end

return M
