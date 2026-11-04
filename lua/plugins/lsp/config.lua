local M = {}
local utils = require("plugins.lsp.utils")

function M.setup(_, opts)
  utils.on_attach(nil, function(client, bufnr)
    require("plugins.lsp.keymaps").on_attach(client, bufnr)
  end)

  require("lsp-file-operations").setup()
  require("plugins.lsp.diagnostics").setup()

  local servers = opts.servers or {}
  local setup = opts.setup or {}
  local capabilities = utils.capabilities()

  local function _setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, servers[server] or {})

    if setup[server] then
      if setup[server](server, server_opts) then
        return
      end
    elseif setup["*"] then
      if setup["*"](server, server_opts) then
        return
      end
    end
    vim.lsp.config(server, server_opts)
    vim.lsp.enable(server)
  end

  for server, server_opts in pairs(servers) do
    if server_opts then
      _setup(server)
    end
  end
end

return M
