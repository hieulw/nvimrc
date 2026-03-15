local M = {}

function M.list_formatters(ft)
  local opts = M.opts("conform.nvim")
  local by_ft = opts.formatters_by_ft or {}
  local ret = {}
  for _, key in ipairs({ "_", ft, "*" }) do
    local formatters = by_ft[key] or {}
    for _, formatter in ipairs(formatters) do
      if type(formatter) == "string" and not vim.tbl_contains(ret, formatter) then
        table.insert(ret, formatter)
      end
    end
  end
  return ret
end

function M.list_linters(ft)
  local opts = M.opts("nvim-lint")
  local by_ft = opts.linters_by_ft or {}
  local ret = {}
  for _, key in ipairs({ "_", ft, "*" }) do
    local linters = by_ft[key] or {}
    for _, linter in ipairs(linters) do
      if type(linter) == "string" and not vim.tbl_contains(ret, linter) then
        table.insert(ret, linter)
      end
    end
  end
  return ret
end

function M.list_completions(ft)
  return {}
end

function M.list_code_actions(ft)
  return {}
end

function M.list_hovers(ft)
  return {}
end

function M.capabilities()
  return require("blink.cmp").get_lsp_capabilities()
end

function M.on_attach(client_name, on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end
      if not client_name then
        on_attach(client, bufnr)
        return
      end
      if client.name == client_name then
        on_attach(client, bufnr)
      end
    end,
  })
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
