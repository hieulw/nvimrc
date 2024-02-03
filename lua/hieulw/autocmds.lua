local augroup = function(name)
  vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "highlight on yank",
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup("YankHighlight"),
  pattern = "*",
})

autocmd("TermOpen", {
  desc = "open terminal in vim start insert right away",
  callback = vim.schedule_wrap(function(e)
    -- Try to start terminal mode only if target terminal is current
    if not (vim.api.nvim_get_current_buf() == e.buf and vim.bo.buftype == "terminal") then
      return
    end
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.filetype = "terminal"
    vim.cmd("startinsert")
  end),
  group = augroup("OpenTerminal"),
  pattern = "term://*",
})

autocmd("VimResized", {
  desc = "resize splits if window got resized",
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

autocmd("FileType", {
  desc = "close some filetypes with <q>",
  group = augroup("close_with_q"),
  pattern = {
    "OverseerForm",
    "OverseerList",
    "PlenaryTestPopup",
    "checkhealth",
    "floggraph",
    "fugitive",
    "git",
    "help",
    "lspinfo",
    "man",
    "neoai-input",
    "neoai-output",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "netrw",
    "notify",
    "oil",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "toggleterm",
    "tsplayground",
    "vim",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Check if we need to reload the file when it changed",
  group = augroup("checktime"),
  command = "checktime",
})

autocmd("FileType", {
  desc = "wrap and check for spell in text filetypes",
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("BufWinEnter", {
  desc = "avoid auto insert comment on newline",
  group = augroup("auto_format_options"),
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
})

autocmd("BufWritePre", {
  desc = "auto create dir when saving a file, in case some intermediate directory does not exist",
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "remember cursor position, folds of current buffer",
  pattern = "?*",
  group = augroup("remember_folds"),
  callback = function(e)
    if vim.b[e.buf].view_activated then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})
autocmd("BufWinEnter", {
  desc = "load cursor position, folds of current buffer",
  pattern = "?*",
  group = augroup("remember_folds"),
  callback = function(e)
    if not vim.b[e.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = e.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = e.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[e.buf].view_activated = true
        vim.cmd.loadview({ mods = { emsg_silent = true } })
      end
    end
  end,
})

autocmd("CmdlineEnter", {
  desc = "enable hlsearch when entering cmdline",
  pattern = "/,?",
  group = augroup("auto_hlsearch"),
  command = "set hlsearch",
})
autocmd("CmdlineLeave", {
  desc = "disable hlsearch when leaving cmdline",
  pattern = "/,?",
  group = augroup("auto_hlsearch"),
  command = "set nohlsearch",
})

-- https://github.com/nvim-telescope/telescope.nvim/issues/2014
autocmd("FileType", {
  desc = "Add telescope result highlight",
  pattern = { "TelescopeResults" },
  group = augroup("telescope_parent_highlight"),
  callback = function(e)
    vim.api.nvim_buf_call(e.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "GruvBoxBg2" })
    end)
  end,
})
