-- ~/.config/hypr/bindings/rofi.lua

local M = {}

function M.setup()
  local rofiMod = "SUPER + CTRL"

  -- Rofi bindings
  hl.bind(
    rofiMod .. " + DELETE",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_delete_process.sh")
  )

  hl.bind(
    rofiMod .. " + B",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_internet_bookmarks.sh")
  )

  hl.bind(
    rofiMod .. " + D",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_app_launcher.sh")
  )

  hl.bind(
    rofiMod .. " + M",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_drive_mounter.sh")
  )

  hl.bind(
    rofiMod .. " + S",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_monitor_selector.sh")
  )

  hl.bind(
    rofiMod .. " + N",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_notification_list.sh")
  )

  hl.bind(
    rofiMod .. " + V",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_clipboard_manager.sh")
  )

  hl.bind(
    rofiMod .. " + W",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_wallpaper_selector.sh")
  )

  hl.bind(
    rofiMod .. " + Q",
    hl.dsp.exec_cmd("~/.config/rofi/rofi_exit_hyprland.sh")
  )

  -- Update the application list used by the launcher
  hl.bind(
    "SUPER + SHIFT + D",
    hl.dsp.exec_cmd("~/stack/rofi/rofi_app_list_update.sh")
  )
end

return M
