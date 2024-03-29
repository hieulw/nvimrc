local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)
  local format = require("plugins.lsp.format").format

  self:map("gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  self:map("gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
  self:map("gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  self:map("gI", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  self:map("gr", vim.lsp.buf.references, { desc = "Show references" })
  self:map("K", vim.lsp.buf.hover, { desc = "Show hover document" })
  self:map("gK", vim.lsp.buf.signature_help, { desc = "Show signatures" })

  self:map("gl", vim.diagnostic.open_float, { desc = "Show diagnostics" })
  self:map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  self:map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
  self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
  self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })

  self:map("<leader>la", vim.lsp.buf.code_action, { desc = "Code actions" })
  self:map("<leader>lf", format, { has = "documentFormatting", desc = "Format" })
  self:map("<leader>lf", format, { mode = "v", has = "documentRangeFormatting", desc = "Format" })
  self:map("<leader>lr", M.rename, { has = "rename", desc = "LSP Rename" })
  self:map("<leader>ls", require("telescope.builtin").lsp_document_symbols)
  self:map("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols)
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand("<cword>")
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
