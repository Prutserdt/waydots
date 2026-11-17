local M = {}

local mainMod = "SUPER"

function M.setup()
  for i = 1, 5 do
    -- Switch workspace
    hl.bind(
      mainMod .. " + " .. i,
      hl.dsp.focus({ workspace = i })
    )

    -- Move active window to workspace
    hl.bind(
      mainMod .. " + SHIFT + " .. i,
      hl.dsp.window.move({ workspace = i })
    )
  end -- for

end -- M.setup

return M
