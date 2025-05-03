local M = require("lualine.component"):extend()

-- Initializer
function M:init(options)
  M.super.init(self, options)
end

-- Function that runs every time statusline is updated
function M:update_status()
  return require("supermaven-nvim.api").is_running() and "󱜙 " or "󱚧 "
end

return M
