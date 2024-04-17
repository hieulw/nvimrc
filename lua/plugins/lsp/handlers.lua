local M = {}

---@see https://github.com/MariaSolOs/dotfiles/blob/fedora/.config/nvim/lua/lsp.lua#L171-L273
local function add_inline_highlights(buf)
  local md_namespace = vim.api.nvim_create_namespace("mariasolos/lsp_float")
  for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs({
      ["@%S+"] = "@parameter",
      ["^%s*(Parameters:)"] = "@text.title",
      ["^%s*(Return:)"] = "@text.title",
      ["^%s*(See also:)"] = "@text.title",
      ["{%S-}"] = "@parameter",
      ["|%S-|"] = "@text.reference",
    }) do
      ---@type integer?
      local from = 1
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

local function float_handler(handler)
  return function(err, result, ctx, config)
    local bufnr, winnr = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend("force", config or {}, {
        style = "minimal",
        border = "rounded",
        focusable = true,
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.5),
      })
    )

    if not bufnr or not winnr then
      return
    end

    -- Conceal everything.
    vim.wo[winnr].conceallevel = 1
    vim.wo[winnr].concealcursor = "n"

    -- Extra highlights.
    add_inline_highlights(bufnr)
  end
end

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
    ["textDocument/hover"] = float_handler(vim.lsp.handlers.hover),
    ["textDocument/signatureHelp"] = float_handler(vim.lsp.handlers.signature_help),
  }

  for method, handler in pairs(handlers) do
    vim.lsp.handlers[method] = handler
  end

  --- HACK: Override `vim.lsp.util.stylize_markdown` to use Treesitter.
  ---@param bufnr integer
  ---@param contents string[]
  ---@param opts table
  ---@return string[]
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    contents = vim.lsp.util._normalize_markdown(contents, {
      width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    vim.bo[bufnr].filetype = "markdown"
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    add_inline_highlights(bufnr)

    return contents
  end
end

return M
