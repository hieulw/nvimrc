local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)

  self:map("gd", vim.lsp.buf.definition, { desc = "Go to definition", has = "definition" })
  self:map("gy", vim.lsp.buf.type_definition, { desc = "Go to type definition", has = "typeDefinition" })
  self:map("gD", vim.lsp.buf.declaration, { desc = "Go to declaration", has = "declaration" })
  self:map("gI", vim.lsp.buf.implementation, { desc = "Go to implementation", has = "implementation" })
  self:map("gl", vim.diagnostic.open_float, { desc = "Show diagnostics" })
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

return M
