local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)
  local format = require("plugins.lsp.format").format

  self:map("gd", vim.lsp.buf.definition, { desc = "Go to definition", has = "definition" })
  self:map("gy", vim.lsp.buf.type_definition, { desc = "Go to type definition", has = "typeDefinition" })
  self:map("gD", vim.lsp.buf.declaration, { desc = "Go to declaration", has = "declaration" })
  self:map("gI", vim.lsp.buf.implementation, { desc = "Go to implementation", has = "implementation" })
  self:map("gr", vim.lsp.buf.references, { desc = "Show references", has = "references" })
  self:map("<C-k>", vim.lsp.buf.signature_help, { mode = "i", has = "signatureHelp" })

  self:map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  self:map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })

  self:map("<leader>ld", vim.diagnostic.open_float, { desc = "Show diagnostics" })
  self:map("<leader>la", vim.lsp.buf.code_action, { desc = "Code Actions", has = "codeAction" })
  self:map("<leader>lf", format, { desc = "Format", has = "documentFormatting" })
  self:map("<leader>lf", format, { mode = "v", desc = "Format", has = "documentRangeFormatting" })
  self:map("<leader>lr", M.rename, { desc = "Rename", has = "rename" })
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(method)
  method = method:find("/") and method or "textDocument/" .. method
  return self.client.supports_method(method)
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
