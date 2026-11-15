-- ~/.config/hypr/lua/appearance.lua

local M = {}

function M.setup(theme, layout)
  hl.config({
    general = {
      gaps_in = 0,
      gaps_out = 0,

      border_size = 1,

      col = {
        active_border = {
          colors = { theme.fg },
        },

        inactive_border = theme.bg_highlight,
      },

      resize_on_border = false,
      allow_tearing = false,

      layout = layout,
    },

    decoration = {
      wobble = {
        enabled = true,
        mesh = 16,
        stiffness = 250,
        damping = 10,
        mass = 0.3,
        intensity = 0.5,
      },

      rounding = 10,
      rounding_power = 10,

      active_opacity = 1.0,
      inactive_opacity = 1.0,

      shadow = {
        enabled = false,
      },

      blur = {
        enabled = false,
      },
    },

    animations = {
      enabled = false,
    },
  })
end

return M
