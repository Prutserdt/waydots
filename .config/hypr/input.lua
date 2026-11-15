-- ~/.config/hypr/lua/input.lua

local M = {}

function M.setup()
  hl.config({
    input = {
      kb_layout = "us",
      kb_variant = "",
      kb_model = "",
      kb_options = "",
      kb_rules = "",

      follow_mouse = 1,
      sensitivity = 0,

      repeat_rate = 50,
      repeat_delay = 180,

      touchpad = {
        natural_scroll = false,
      },
    },
  })

  hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
  })
end

return M
