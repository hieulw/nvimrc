-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
vim.opt.termguicolors = true      -- use 24-bit (true-color)
vim.opt.hidden = true             -- Required to keep multiple buffers open multiple buffers set autoread
vim.opt.autoread = true           -- auto update buffer
vim.opt.autowrite = true          -- auto update buffer
vim.opt.gdefault = true           -- global search by default
vim.opt.ignorecase = true         -- ignore case search
vim.opt.smartcase = true          -- override ignorecase if search uppercase pattern
vim.opt.autochdir = false         -- do not change cwd when open new buffer
vim.opt.encoding = "utf-8"        -- the encoding displayed
vim.opt.fileencoding = "utf-8"    -- the encoding written to file
vim.opt.ruler = true              -- show the cursor position all the time
vim.opt.iskeyword:append("-")     -- treat dash separated words as a word text object--
vim.opt.mouse = "a"               -- Enable your mouse
vim.opt.splitbelow = true         -- Horizontal splits will automatically be below
vim.opt.splitright = true         -- Vertical splits will automatically be to the right
vim.opt.splitkeep = "cursor"      -- Reduce scroll during window split
vim.opt.conceallevel = 0          -- So that I can see `` in markdown files
vim.opt.tabstop = 2               -- Insert 2 spaces for a tab
vim.opt.shiftwidth = 2            -- Change the number of space characters inserted for indentation set smarttab
vim.opt.smarttab = true           -- Makes tabbing smarter will realize you have 2 vs 4
vim.opt.expandtab = true          -- Converts tabs to spaces
vim.opt.smartindent = true        -- Makes indenting smart
vim.opt.autoindent = true         -- Good auto indent
vim.opt.number = true             -- Line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.cursorline = true         -- Enable highlighting of the current line
vim.opt.cmdheight = 1             -- More space for displaying messages
vim.opt.laststatus = 3            -- Global statusline
vim.opt.showtabline = 1           -- Always show tabs
vim.opt.fixendofline = false      -- Stop adding end of line character, annoying git diff
vim.opt.scrolloff = 8             -- Number of lines to keep above and below the cursor
vim.opt.sidescrolloff = 8         -- Number of columns to keep at the sides of the cursor
vim.opt.foldenable = true         -- No folding by default
vim.opt.foldcolumn = "0"          -- No folding by default
vim.opt.foldlevel = 99            -- No folding by default
vim.opt.foldlevelstart = 99       -- No folding by default
vim.opt.showmode = false          -- We don't need to see things like -- INSERT -- anymore
vim.opt.backup = false            -- This is recommended by coc
vim.opt.writebackup = false       -- This is recommended by coc
vim.opt.swapfile = false          -- This is recommented by coc
vim.opt.startofline = false       -- Move  more freedom
vim.opt.breakindent = true        -- Indent wrapped lines to match line start
vim.opt.wrap = false              -- Display long lines as just one line
vim.opt.winblend = 0              -- Make floating windows slightly transparent
vim.opt.pumblend = 0              -- Make builtin completion menus slightly transparent
vim.opt.pumheight = 10            -- Makes popup menu smaller
vim.opt.updatetime = 250          -- Faster completion
vim.opt.timeoutlen = 300          -- By default timeoutlen is 1000 ms
vim.opt.shortmess:append("c")     -- Shut off completion messages
vim.opt.signcolumn = "number"     -- Always show the signcolumn
vim.opt.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.opt.showmatch = true          -- Highlight matching parenthesis
vim.opt.incsearch = true          -- Incremental Search Highlight
vim.opt.inccommand = "nosplit"    -- Incremental Replace Highlight, no preview window
-- Remove border between split windows
vim.opt.fillchars:append({
  vert = " ",
  vertleft = " ",
  vertright = " ",
  verthoriz = " ",
  horiz = " ",
  horizup = " ",
  horizdown = " ",
  stl = " ",
  stlnc = " ",
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
})
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "·" }
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" } -- no autofilling and no auto select first item in autocompletion menu

-- set includeexpr=substitute(v:fname,'\\.','/','g')
-- set suffixesadd={'.py','.lua','.vim'}
vim.opt.path = vim.fn.getcwd() .. "/**"
vim.opt.list = true
vim.opt.guicursor = "i-ci-ve:Cursor,r-cr-o:DiffDelete,i-ci-ve:blinkwait700-blinkoff400-blinkon250,a:block"
vim.opt.guifont = "CaskaydiaCove Nerd Font Mono:h15"
vim.opt.colorcolumn = "100"
vim.opt.shell = "/bin/zsh" -- https://github.com/kyazdani42/nvim-tree.lua/issues/518

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0

vim.opt.more = true
