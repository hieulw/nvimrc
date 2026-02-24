local M = require("lualine.component"):extend()

-- Initializer
function M:init(options)
  M.super.init(self, options)
end

-- Function that runs every time statusline is updated
function M:update_status()
  local ok, supermaven = pcall(require, "supermaven-nvim.api")
  if not ok then
    return ""
  end
  return supermaven.is_running() and "󱜙 " or "󱚧 "
end

return M
