local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)
  local format = require("plugins.lsp.format").format

  self:map("gd", vim.lsp.buf.definition, { desc = "Go to definition", has = "definition" })
  self:map("grt", vim.lsp.buf.type_definition, { desc = "Go to type definition", has = "typeDefinition" })
  self:map("grd", vim.lsp.buf.declaration, { desc = "Go to declaration", has = "declaration" })
  self:map("gri", vim.lsp.buf.implementation, { desc = "Go to implementation", has = "implementation" })
  self:map("grr", vim.lsp.buf.references, { desc = "Show references", has = "references" })
  self:map("grn", vim.lsp.buf.rename, { desc = "Rename", has = "rename" })
  self:map("gra", vim.lsp.buf.code_action, { desc = "Code actions", has = "codeAction", mode = { "n", "x" } })
  self:map("<C-S>", vim.lsp.buf.signature_help, { desc = "Signature help", has = "signatureHelp", mode = { "i", "s" } })

  self:map("<leader>lf", format, { desc = "Format", has = "documentFormatting" })
  self:map("<leader>lf", format, { mode = "v", desc = "Format", has = "documentRangeFormatting" })
  self:map("<leader>li", M.toggle_inlayhint, { desc = "Toggle Inlayhint", has = "textDocument/inlayHint" })
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

function M.toggle_inlayhint()
  ---@diagnostic disable-next-line: missing-parameter
  local enabled = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(enabled)
  vim.notify(enabled and "Inlay Hint Enabled" or "Inlay Hint Disabled", vim.log.levels.INFO)
end

return M
