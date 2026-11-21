-- ~/.config/hypr/rules/rules.lua

local M = {}

function M.setup(theme)
  -- Qalculate
  hl.window_rule({
    match = {
      class = "qalculate-gtk",
    },
    move = "2 500",
  })

  -- Emacs opacity
  hl.window_rule({
    name = "opacity-emacs",
    match = {
      class = "^Emacs$",
    },
    opacity = 0.8,
  })

  -- Emacs border
  hl.window_rule({
    match = {
      class = "Emacs",
    },
    border_color = theme.orange,
  })

  -- Ghostty border
  hl.window_rule({
    match = {
      class = "com.mitchellh.ghostty",
    },
    border_color = theme.green,
  })

  -- Brave border
  hl.window_rule({
    match = {
      class = "brave-browser",
    },
    border_color = theme.purple,
  })

  -- Ignore maximize requests from applications
  hl.window_rule({
    name = "suppress-maximize-events",
    match = {
      class = ".*",
    },
    suppress_event = "maximize",
  })

  -- Fix some dragging issues with XWayland
  hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
      class = "^$",
      title = "^$",
      xwayland = true,
      float = true,
      fullscreen = false,
      pin = false,
    },
    no_focus = true,
  })

  -- Move hyprland-run near the bottom of the monitor
  hl.window_rule({
    name = "move-hyprland-run",
    match = {
      class = "hyprland-run",
    },
    move = "20 monitor_h-120",
    float = true,
  })

  hl.window_rule({
    name = "opacity-rofi",
    match = {
      class = "^Rofi$",
    },
    opacity = 0.90,
    --opacity = "0.90 override 0.90 override",
  })
end

return M
