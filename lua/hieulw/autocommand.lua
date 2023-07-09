local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require("hieulw.helper")

-- Highlight on yank
-- https://stackoverflow.com/questions/26069278/hightlight-copied-area-on-vim
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup("YankHighlight", { clear = true }),
  pattern = "*",
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("Unlist Quickfist", { clear = true }),
  pattern = { "qf", "dap-repl" },
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Open terminal in vim feel like home
-- start insert right away
autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.filetype = "terminal"
    vim.cmd("startinsert")
  end,
  group = augroup("OpenTerminal", { clear = true }),
  pattern = "term://*",
})

autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("File User Events", { clear = true }),
  callback = function(args)
    if not (vim.fn.expand("%") == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      utils.event("File")
      if utils.cmd('git -C "' .. vim.fn.expand("%:p:h") .. '" rev-parse', false) then
        utils.event("GitFile")
      end
    end
  end,
})
