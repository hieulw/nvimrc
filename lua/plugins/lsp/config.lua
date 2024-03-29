local M = {}

local handlers = {
  -- HACK: do not print the label
  ["workspace/applyEdit"] = function(_, workspace_edit, ctx)
    assert(
      workspace_edit,
      "workspace/applyEdit must be called with `ApplyWorkspaceEditParams`. Server is violating the specification"
    )
    local client_id = ctx.client_id
    local client = assert(vim.lsp.get_client_by_id(client_id))
    local status, result = pcall(vim.lsp.util.apply_workspace_edit, workspace_edit.edit, client.offset_encoding)
    return {
      applied = status,
      failureReason = result,
    }
  end,
}

function M.setup(_, opts)
  local lsp_utils = require("plugins.lsp.utils")
  lsp_utils.on_attach(nil, function(client, bufnr)
    require("plugins.lsp.format").on_attach(client, bufnr)
    require("plugins.lsp.keymaps").on_attach(client, bufnr)
  end)

  require("lsp-file-operations").setup()
  require("plugins.lsp.diagnostics").setup()

  local servers = opts.servers
  local capabilities = lsp_utils.capabilities()

  local function _setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      handlers = handlers,
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
