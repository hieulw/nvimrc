local augroup = function(name)
  vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd
local utils = require("hieulw.helper")

-- Highlight on yank
-- https://stackoverflow.com/questions/26069278/hightlight-copied-area-on-vim
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup("YankHighlight"),
  pattern = "*",
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
  group = augroup("OpenTerminal"),
  pattern = "term://*",
})

autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("File User Events"),
  callback = function(args)
    if not (vim.fn.expand("%") == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      utils.event("File")
      if utils.cmd('git -C "' .. vim.fn.expand("%:p:h") .. '" rev-parse', false) then
        utils.event("GitFile")
      end
    end
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- avoid auto insert comment on newline
autocmd({ "BufWinEnter" }, {
  group = augroup "auto_format_options",
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
