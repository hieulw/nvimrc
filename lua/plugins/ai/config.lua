local M = {}

function M.setup(_, opts)
  local codecompanion = require("codecompanion")

  opts.strategies.chat.tools = {
    ["code_developer"] = {
      description = "Act as developer by utilizing LSP methods and code modification capabilities.",
      opts = {
        user_approval = false,
      },
      callback = "plugins.ai.tools.code_developer",
    },
  }

  codecompanion.setup(opts)
end

return M
