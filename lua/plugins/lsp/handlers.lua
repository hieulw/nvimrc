local M = {}
local utils = require("plugins.lsp.utils")

function M.setup()
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
    ["textDocument/hover"] = utils.float_handler(vim.lsp.handlers.hover),
    ["textDocument/signatureHelp"] = utils.float_handler(vim.lsp.handlers.signature_help),
  }

  for method, handler in pairs(handlers) do
    vim.lsp.handlers[method] = handler
  end
end

return M
