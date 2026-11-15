-- ~/.config/hypr/lua/system.lua

local M = {}

M.hostname = io.popen("uname -n"):read("*l") or "unknown"
M.layout = M.hostname == "thinkpad" and "dwindle" or "master"

function M.setup()
  if M.hostname == "thinkpad" then
    hl.exec_cmd("kanata")
  end
end

return M
