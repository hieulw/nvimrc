local M = {}

function M.foldlevel(lnum)
  local indent = vim.fn.indent(lnum)
  if indent >= 0 then
    return math.ceil(indent / vim.o.shiftwidth)
  else
    return 0
  end
end

function M.foldexpr()
  local lnum = vim.v.lnum
  local level = M.foldlevel(lnum)
  local next_level = M.foldlevel(lnum + 1)
  if vim.fn.getline(lnum) == "" then
    return "=" -- empty line have same indent as previous line
  end
  if next_level > level then
    return ">" .. next_level
  end
  return level
end

function M.virtualtext(lnum, trim)
  trim = trim or false
  local result = {}
  local text = vim.fn.getline(lnum)
  local offset
  local hl
  local str = ""
  if trim then
    offset = #(text:match("^(%s+)") or "")
    text = vim.trim(text)
  else
    offset = 0
  end
  for i = 1, #text do
    local char = text:sub(i, i)
    local hls = vim.treesitter.get_captures_at_pos(0, lnum - 1, offset + i - 1)
    local _hl = hls[#hls]
    if _hl then
      local new_hl = "@" .. _hl.capture
      if new_hl ~= hl then
        table.insert(result, { str, hl })
        str = ""
        hl = nil
      end
      str = str .. char
      hl = new_hl
    else
      str = str .. char
    end
  end
  table.insert(result, { str, hl })
  return result
end

function M.foldtext()
  local patterns = { "end[,)]*", "[%])}]+[,;]?", "['\"`]", "</[%w.]*>" }
  local endline = vim.trim(vim.fn.getline(vim.v.foldend))
  local vtext = {}
  vim.list_extend(vtext, M.virtualtext(vim.v.foldstart))
  table.insert(vtext, {
    (" %s %d "):format(require("hieulw.icons").ui.Fold, vim.v.foldend - vim.v.foldstart),
    "Comment",
  })
  for _, pattern in ipairs(patterns) do
    if endline:find(pattern) == 1 then
      vim.list_extend(vtext, M.virtualtext(vim.v.foldend, true))
      break
    end
  end
  return vtext
end

function M.setup()
  local lsp_utils = require("plugins.lsp.utils")
  local treesitter = require("nvim-treesitter")

  vim.opt.foldenable = true
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99 -- No folding by default
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.require'plugins.ui.folding'.foldexpr()"
  vim.opt.foldtext = "v:lua.require'plugins.ui.folding'.foldtext()"
  vim.opt.foldcolumn = "0"
  vim.opt.fillchars:append({
    fold = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
  })

  -- Using Treesitter folding if available
  ---@see https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/ui.lua#L10-L25
  treesitter.define_modules({
    fold = {
      enable = true,
      attach = function(bufnr, ft)
        if vim.b[bufnr].ts_folds == nil then
          vim.b[bufnr].ts_folds = pcall(vim.treesitter.get_parser, bufnr)
        end
        if vim.b[bufnr].ts_folds then
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
      detach = function(bufnr)
        vim.opt_local.foldexpr = vim.go.foldexpr
      end,
    },
  })

  -- Using LSP folding if available
  lsp_utils.on_attach(nil, function(client, bufnr)
    if vim.b[bufnr].ts_folds then
      return
    end
    if client.supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end)
end

return M
