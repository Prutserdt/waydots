-- ~/.config/hypr/lua/layouts.lua

local M = {}

function M.setup()
  -- Dwindle layout
  hl.config({
    dwindle = {
      preserve_split = true,
    },
  })

  -- Master layout
  hl.config({
    master = {
      orientation = "center",
      slave_count_for_center_master = false,
      new_status = "slave",
      always_keep_position = true,
    },
  })

  -- Scrolling layout
  hl.config({
    scrolling = {
      fullscreen_on_one_column = true,
    },
  })
end

return M
