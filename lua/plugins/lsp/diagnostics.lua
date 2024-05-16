local M = {}

function M.setup()
  local icon = require("hieulw.icons")
  local signs = {
    { name = "DiagnosticSignError", text = icon.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icon.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icon.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icon.diagnostics.Info },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  -- Diagnostic configuration
  vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "if_many",
    },
  })
end

return M
