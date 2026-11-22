-- ~/.config/hyprlua/binding/main.lua

local M = {}

local mainMod = "SUPER"

function M.setup()
  -------------------
  -- GENERAL ACTIONS
  -------------------

  -- Show keybindings
  hl.bind(
    mainMod .. " + SLASH",
    hl.dsp.exec_cmd(
      "cat ~/.config/hypr/bindings/README.org | "
        .. "rofi -dmenu -c -bw 2 -l 40 -i -p 'Search'"
    )
  )

  -- Make selected window the master
  hl.bind(
    mainMod .. " + SPACE",
    hl.dsp.layout("swapwithmaster master")
  )

  -- Terminals
  hl.bind(
    mainMod .. " + SHIFT + RETURN",
    hl.dsp.exec_cmd("alacritty")
  )

  hl.bind(
    mainMod .. " + RETURN",
    hl.dsp.exec_cmd("ghostty")
  )

  -- Close active window
  hl.bind(
    mainMod .. " + Q",
    hl.dsp.exec_cmd("~/.config/close_window.sh")
  )

  -- Reload hyprland configuration
  hl.bind(
    mainMod .. " + R",
    hl.dsp.exec_cmd("hyprctl reload")
  )

  -- Toggle floating
  hl.bind(
    mainMod .. " + T",
    hl.dsp.window.float({ action = "toggle" })
  )

  -- Toggle Waybar
  hl.bind(
    mainMod .. " + B",
    hl.dsp.exec_cmd("pkill waybar || waybar")
  )

  ----------------
  -- WINDOW FOCUS
  ----------------

  hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
  hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
  hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
  hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))

  ----------------
  -- WINDOW MOVING
  ----------------

  hl.bind(
    mainMod .. " + SHIFT + H",
    hl.dsp.window.move({ direction = "left" })
  )

  hl.bind(
    mainMod .. " + SHIFT + L",
    hl.dsp.window.move({ direction = "right" })
  )

  hl.bind(
    mainMod .. " + SHIFT + K",
    hl.dsp.window.move({ direction = "up" })
  )

  hl.bind(
    mainMod .. " + SHIFT + J",
    hl.dsp.window.move({ direction = "down" })
  )

  ----------------
  -- LAYOUTS
  ----------------

  local function set_layout(name)
    return function()
      hl.config({
        general = {
          layout = name,
        },
      })

      os.execute(
        string.format('notify-send "Hyprland" "Layout: %s"', name)
      )
    end
  end

  hl.bind(mainMod .. " + Y", set_layout("master"))
  hl.bind(mainMod .. " + U", set_layout("dwindle"))
  hl.bind(mainMod .. " + I", set_layout("monocle"))
  hl.bind(mainMod .. " + O", set_layout("scrolling"))

  ----------------
  -- FULLSCREEN
  ----------------

  -- Normal fullscreen
  hl.bind(
    mainMod .. " + F",
    hl.dsp.window.fullscreen({ state = 0 })
  )

  -- Fake fullscreen: keeps the bar visible
  hl.bind(
    mainMod .. " + CTRL + F",
    hl.dsp.window.fullscreen_state({
      internal = 0,
      client = 2,
      action = "toggle",
    })
  )

  ----------------
  -- RESIZING
  ----------------

  hl.bind(
    mainMod .. " + CTRL + H",
    hl.dsp.window.resize({
      x = -50,
      y = 0,
      relative = true,
    }),
    { repeating = true }
  )

  hl.bind(
    mainMod .. " + CTRL + J",
    hl.dsp.window.resize({
      x = 0,
      y = 50,
      relative = true,
    }),
    { repeating = true }
  )

  hl.bind(
    mainMod .. " + CTRL + K",
    hl.dsp.window.resize({
      x = 0,
      y = -50,
      relative = true,
    }),
    { repeating = true }
  )

  hl.bind(
    mainMod .. " + CTRL + L",
    hl.dsp.window.resize({
      x = 50,
      y = 0,
      relative = true,
    }),
    { repeating = true }
  )

  ----------------
  -- MOUSE ACTIONS
  ----------------

  -- Move and resize windows using Mod + mouse
  hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
  )

  hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
  )

  ----------------
  -- TEXT FILES
  ----------------

  hl.bind(
    mainMod .. " + SHIFT + B",
    hl.dsp.exec_cmd(
      'emacsclient -c -a "emacs" ~/stack/Command_line/urls'
    )
  )
end

return M
