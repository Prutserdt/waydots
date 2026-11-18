-- ~/.config/hypr/bindings/applications.lua

local M = {}

function M.setup()
  local appsMod = "SUPER + CTRL + ALT"

  -- Stock ticker
  hl.bind(
    appsMod .. " + A",
    hl.dsp.exec_cmd("ghostty -e zsh -lc ~/.config/aandelen.py")
  )

  -- Emacs
  hl.bind(
    appsMod .. " + E",
    hl.dsp.exec_cmd("~/.config/open_emacs.sh")
  )

  -- GIMP
  hl.bind(
    appsMod .. " + G",
    hl.dsp.exec_cmd("gimp")
  )

  -- Mousepad
  hl.bind(
    appsMod .. " + M",
    hl.dsp.exec_cmd("mousepad")
  )

  -- KeePass
  hl.bind(
    appsMod .. " + P",
    hl.dsp.exec_cmd("keepass ~/stack/WoordenInDeWacht/wachtwoorden.kdbx")
  )

  -- PCManFM
  hl.bind(
    appsMod .. " + SHIFT + T",
    --hl.dsp.exec_cmd("ghostty -e zsh -lc yazi")
    hl.dsp.exec_cmd("pcmanfm")
  )

  -- Doublecmb
  hl.bind(
    appsMod .. " + T",
    hl.dsp.exec_cmd("QT_STYLE_OVERRIDE=Adwaita-Dark QT_QPA_PLATFORMTHEME=gtk3 doublecmd")
  )

  -- Hyprlock
  hl.bind(
    appsMod .. " + L",
    hl.dsp.exec_cmd("hyprlock")
  )

  -- Visho
  hl.bind(
    appsMod .. " + V",
    hl.dsp.exec_cmd("ghostty -e zsh -lc ~/.config/visho.py")
  )
end

return M
