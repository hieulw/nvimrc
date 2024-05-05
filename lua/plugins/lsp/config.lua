local M = {}
local utils = require("plugins.lsp.utils")

function M.setup(_, opts)
  utils.on_attach(nil, function(client, bufnr)
    require("plugins.lsp.format").on_attach(client, bufnr)
    require("plugins.lsp.keymaps").on_attach(client, bufnr)
  end)

  require("lsp-file-operations").setup()
  require("plugins.lsp.diagnostics").setup()
  require("plugins.lsp.handlers").setup()

  local servers = opts.servers
  local capabilities = utils.capabilities()

  local function _setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, servers[server] or {})

    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup["*"] then
      if opts.setup["*"](server, server_opts) then
        return
      end
    end
    require("lspconfig")[server].setup(server_opts)
  end

  -- get all the servers that are available thourgh mason-lspconfig
  local has_mason, mlsp = pcall(require, "mason-lspconfig")
  local all_mslp_servers = {}
  if has_mason then
    all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  end

  local ensure_installed = {} ---@type string[]
  if servers == nil then
    return
  end
  for server, server_opts in pairs(servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
        _setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end

  if not has_mason then
    return
  end

  mlsp.setup({ ensure_installed = ensure_installed })
  mlsp.setup_handlers({ _setup })
end

return M
