local M = {}

M.autoformat = true
M.format_notify = false
M._is_initialized = false

function M.toggle()
  M.autoformat = not M.autoformat
  vim.notify(M.autoformat and "Enabled format on save" or "Disabled format on save")
end

function M.format(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local has_conform, conform = pcall(require, "conform")
  if has_conform then
    conform.format({ bufnr = buf, lsp_format = "fallback", timeout_ms = 3000 })
    return
  end

  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  if M.format_notify then
    M.notify(formatters)
  end

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  })
end

function M.setup()
  if M._is_initialized then
    return
  end

  M._is_initialized = true
  local group = vim.api.nvim_create_augroup("LspFormat", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(args)
      if not M.autoformat then
        return
      end
      if vim.bo[args.buf].buftype ~= "" then
        return
      end
      M.format(args.buf)
    end,
  })
end

function M.notify(formatters)
  local lines = { "# Active:" }

  for _, client in ipairs(formatters.active) do
    table.insert(lines, "- **" .. client.name .. "**")
  end

  if #formatters.available > 0 then
    table.insert(lines, "")
    table.insert(lines, "# Disabled:")
    for _, client in ipairs(formatters.available) do
      table.insert(lines, "- **" .. client.name .. "**")
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "Formatting",
    on_open = function(win)
      vim.api.nvim_set_option_value("conceallevel", 3, { win = win })
      vim.api.nvim_set_option_value("spell", false, { win = win })
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "markdown")
    end,
  })
end

function M.supports_format(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client:supports_method("textDocument/formatting") or client:supports_method("textDocument/rangeFormatting")
end

function M.get_formatters(bufnr)
  local ret = {
    active = {},
    available = {},
  }

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      table.insert(ret.active, client)
    end
  end

  return ret
end

return M
