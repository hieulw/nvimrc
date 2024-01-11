-- General
vim.opt.undofile = true     -- Enable persistent undo (see also `:h undodir`)
vim.opt.backup = false      -- This is recommended by coc
vim.opt.writebackup = false -- This is recommended by coc
vim.opt.swapfile = false    -- This is recommented by coc
vim.opt.viewoptions = { "cursor", "folds" }

vim.opt.mouse = "a"               -- Enable your mouse
vim.opt.clipboard = "unnamedplus" -- System clipboard
vim.opt.termguicolors = true      -- use 24-bit (true-color)
vim.opt.guifont = "CaskaydiaCove NFM:h15"
vim.opt.colorcolumn = "100"

-- Appearance
vim.opt.breakindent = true    -- Indent wrapped lines to match line start
vim.opt.cursorline = true     -- Enable highlighting of the current line
vim.opt.linebreak = true      -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number = true         -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.splitbelow = true     -- Horizontal splits will automatically be below
vim.opt.splitright = true     -- Vertical splits will automatically be to the right
vim.opt.splitkeep = "cursor"  -- Reduce scroll during window split

vim.opt.ruler = false         -- Don't show cursor position in command line
vim.opt.showmode = false      -- We don't need to see things like -- INSERT -- anymore
vim.opt.wrap = false          -- Display long lines as just one line

vim.opt.foldenable = true     -- No folding by default
vim.opt.foldcolumn = "0"      -- No folding by default
vim.opt.foldlevel = 99        -- No folding by default
vim.opt.foldlevelstart = 99   -- No folding by default
vim.opt.conceallevel = 0      -- So that I can see `` in markdown files

vim.opt.signcolumn = "number" -- Always show the signcolumn
vim.opt.fillchars:append({
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
})

vim.opt.winblend = 0 -- Make floating windows no transparent
vim.opt.pumblend = 0 -- Make builtin completion menus no transparent
vim.opt.pumheight = 10 -- Makes popup menu smaller

vim.opt.list = true -- Show some helper symbols
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "·", extends = "❯", precedes = "❮" } -- Define which helper symbols to show

-- Editting
vim.opt.ignorecase = true                                   -- Ignore case when searching (use `\C` to force not doing that)
vim.opt.incsearch = true                                    -- Show search results while typing
vim.opt.infercase = true                                    -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase = true                                    -- Don't ignore case when searching if pattern has upper case

vim.opt.tabstop = 2                                         -- Insert 2 spaces for a tab
vim.opt.shiftwidth = 2                                      -- Change the number of space characters inserted for indentation set smarttab
vim.opt.expandtab = true                                    -- Converts tabs to spaces
vim.opt.autoindent = true                                   -- Good auto indent
vim.opt.smartindent = false                                 -- Makes indenting smart

vim.opt.completeopt = { "menuone", "noinsert", "noselect" } -- no autofilling and no auto select first item in autocompletion menu
vim.opt.virtualedit = "block"                               -- Allow going past the end of line in visual block mode
vim.opt.formatoptions = "qjl1"                              -- Don't autoformat comments
vim.opt.iskeyword:append("-")                               -- treat dash separated words as a word text object--

vim.opt.scrolloff = 8                                       -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8                                   -- Number of columns to keep at the sides of the cursor
vim.opt.fixendofline = false                                -- Stop adding end of line character, annoying git diff
vim.opt.startofline = false                                 -- Move  more freedom

vim.opt.updatetime = 100                                    -- Faster completion
vim.opt.timeoutlen = 300                                    -- By default timeoutlen is 1000 ms

vim.opt.path = vim.fn.getcwd() .. "/**"

vim.g.mapleader = " "
vim.g.localleader = " "
