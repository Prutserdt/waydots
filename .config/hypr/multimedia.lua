-- ~/.config/hypr/lua/multimedia.lua

local M = {}

function M.setup()
  -- Volume
  hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
  )

  hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
  )

  hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
  )

  -- Applications
  hl.bind(
    "XF86Calculator",
    hl.dsp.exec_cmd("[float] qalculate-gtk")
  )

  -- Hyprsunset brightness/color temperature
  hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("hyprctl hyprsunset gamma -10"),
    { locked = true, repeating = true }
  )

  hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("hyprctl hyprsunset gamma +10"),
    { locked = true, repeating = true }
  )

  hl.bind(
    "XF86Launch9",
    hl.dsp.exec_cmd("hyprctl hyprsunset gamma 100"),
    { locked = true }
  )

  -- Screenshots
  hl.bind(
    "PRINT",
    hl.dsp.exec_cmd([[sh -c 'xfce4-screenshooter -r -s "$HOME/Downloads"']])
  )

  hl.bind(
    "SHIFT + PRINT",
    hl.dsp.exec_cmd("~/.config/screenshot2text.sh")
  )
end

return M
