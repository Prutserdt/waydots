-- ~/.config/hypr/lua/autostart.lua

local M = {}

function M.setup()
  hl.on("hyprland.start", function()
    hl.exec_cmd("xrdb ~/.Xresources")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("syncthing")
    hl.exec_cmd("emacs --daemon")

    -- Store text clipboard history in the background.
    hl.exec_cmd(
      "sh -c 'wl-paste --type text --watch cliphist store >/dev/null 2>&1 &'"
    )

    -- Store image clipboard history in the background.
    hl.exec_cmd(
      "sh -c 'wl-paste --type image --watch cliphist store >/dev/null 2>&1 &'"
    )
  end)
end

return M
