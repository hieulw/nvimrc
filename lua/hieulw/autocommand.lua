-- Highlight on yank
-- https://stackoverflow.com/questions/26069278/hightlight-copied-area-on-vim
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*'
})

-- Open terminal in vim feel like home
-- start insert right away
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.filetype = 'terminal'
    vim.cmd('startinsert')
  end,
  group = vim.api.nvim_create_augroup('OpenTerminal', { clear = true }),
  pattern = 'term://*'
})

-- TreeSitter Powered Folding
local ok, parsers = pcall(require, 'nvim-treesitter.parsers')
if ok then
  local configs = parsers.get_parser_configs()
  _FOLDING = require 'hieulw.folding'

  local filetypes = table.concat(vim.tbl_map(function(ft)
    return configs[ft].filetype or ft
  end, parsers.available_parsers()), ',')

  vim.api.nvim_create_autocmd('Filetype', {
    callback = function()
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
    group = vim.api.nvim_create_augroup('FoldText', { clear = true }),
    pattern = filetypes
  })
  vim.wo.foldtext = "v:lua._FOLDING.foldtext()"
end
