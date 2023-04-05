-- Basic configurations
vim.opt.hidden = true                                           -- Required to keep multiple buffers open multiple buffers set autoread
vim.opt.autoread = true                                         -- auto update buffer
vim.opt.autowrite = true                                        -- auto update buffer
vim.opt.gdefault = true                                         -- global search by default
vim.opt.ignorecase = true                                       -- ignore case search
vim.opt.smartcase = true                                        -- override ignorecase if search uppercase pattern
vim.opt.autochdir = false                                       -- do not change cwd when open new buffer
vim.opt.encoding = 'utf-8'                                      -- the encoding displayed
vim.opt.fileencoding = 'utf-8'                                  -- the encoding written to file
vim.opt.ruler = true                                            -- show the cursor position all the time
vim.opt.cmdheight = 1                                           -- More space for displaying messages
vim.opt.iskeyword:append('-')                                   -- treat dash separated words as a word text object--
vim.opt.mouse = 'a'                                             -- Enable your mouse
vim.opt.splitbelow = true                                       -- Horizontal splits will automatically be below
vim.opt.splitright = true                                       -- Vertical splits will automatically be to the right
-- vim.opt.t_Co = 256 -- Support 256 colors
vim.opt.conceallevel = 0                                        -- So that I can see `` in markdown files
vim.opt.tabstop = 2                                             -- Insert 2 spaces for a tab
vim.opt.shiftwidth = 2                                          -- Change the number of space characters inserted for indentation set smarttab                            -- Makes tabbing smarter will realize you have 2 vs 4
vim.opt.expandtab = true                                        -- Converts tabs to spaces
vim.opt.smartindent = true                                      -- Makes indenting smart
vim.opt.autoindent = true                                       -- Good auto indent
vim.opt.number = true                                           -- Line numbers
vim.opt.relativenumber = true                                   -- Relative line numbers
vim.opt.cursorline = true                                       -- Enable highlighting of the current line
vim.opt.laststatus = 2                                          -- Let lightline handle status line
vim.opt.showtabline = 1                                         -- Always show tabs
vim.opt.fixendofline = false                                    -- Stop adding end of line character, annoying git diff
vim.opt.foldenable = false                                      -- No folding by default
vim.opt.showmode = false                                        -- We don't need to see things like -- INSERT -- anymore
vim.opt.backup = false                                          -- This is recommended by coc
vim.opt.writebackup = false                                     -- This is recommended by coc
vim.opt.swapfile = false                                        -- This is recommented by coc
vim.opt.startofline = false                                     -- Move cursor more freedom
vim.opt.wrap = false                                            -- Display long lines as just one line
vim.opt.pumheight = 10                                          -- Makes popup menu smaller
vim.opt.updatetime = 300                                        -- Faster completion
vim.opt.timeoutlen = 500                                        -- By default timeoutlen is 1000 ms
vim.opt.shortmess:append('c')                                   -- Shut off completion messages
vim.opt.signcolumn = 'auto'                                     -- Always show the signcolumn
vim.opt.clipboard = 'unnamedplus'                               -- Copy paste between vim and everything else
vim.opt.fillchars:append { vert = ' ', stl = ' ', stlnc = ' ' } -- Oldshcool style
vim.opt.listchars = { tab = '→ ', trail = '·', nbsp = '·' }
vim.opt.completeopt = { 'menu', 'noinsert', 'noselect' }        -- no autofilling and no auto select first item in autocompletion menu
vim.opt.showmatch = true                                        -- Highlight matching parenthesis
vim.opt.incsearch = true                                        -- Incremental Search Highlight
vim.opt.inccommand = 'nosplit'                                  -- Incremental Replace Highlight

-- set includeexpr=substitute(v:fname,'\\.','/','g')
-- set suffixesadd={'.py','.lua','.vim'}
vim.opt.path = vim.fn.getcwd() .. '/**'
vim.opt.list = true
-- set guicursor=i-ci-ve:Cursor,r-cr-o:DiffDelete
-- set guicursor+=i-ci-ve:blinkwait700-blinkoff400-blinkon250
-- set guicursor+=a:block
vim.opt.guifont = 'CaskaydiaCove Nerd Font Mono:h15'
vim.opt.colorcolumn = "100"
vim.opt.shell = '/bin/zsh' -- https://github.com/kyazdani42/nvim-tree.lua/issues/518

vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
-- vim.g.loaded_matchparen = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zipPlugin = 1
