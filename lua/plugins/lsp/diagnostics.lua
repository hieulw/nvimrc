local M = {}

function M.setup()
  -- Diagnostic configuration
  vim.diagnostic.config({
    virtual_text = { current_line = true },
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
