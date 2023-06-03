local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require("hieulw.helper")

-- Highlight on yank
-- https://stackoverflow.com/questions/26069278/hightlight-copied-area-on-vim
autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
  group = augroup('YankHighlight', { clear = true }),
  pattern = '*'
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("Unlist Quickfist", { clear = true }),
  pattern = { "qf", "dap-repl" },
  callback = function() vim.opt_local.buflisted = false end,
})

autocmd("FileType", {
  group = augroup("Better Goto File in Lua", { clear = true }),
  pattern = { "lua" },
  desc = "fix gf functionality inside .lua files",
  callback = function()
    ---@diagnostic disable: assign-type-mismatch
    -- credit: https://github.com/sam4llis/nvim-lua-gf
    vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
    vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
    vim.opt_local.suffixesadd:prepend ".lua"
    vim.opt_local.suffixesadd:prepend "init.lua"
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
      vim.opt_local.path:append(path .. "/lua")
    end
  end,
})

-- Open terminal in vim feel like home
-- start insert right away
autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.filetype = 'terminal'
    vim.cmd('startinsert')
  end,
  group = augroup('OpenTerminal', { clear = true }),
  pattern = 'term://*'
})

autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("File User Events", { clear = true }),
  callback = function(args)
    if not (vim.fn.expand "%" == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      utils.event "File"
      if utils.cmd('git -C "' .. vim.fn.expand "%:p:h" .. '" rev-parse', false) then utils.event "GitFile" end
    end
  end,
})

