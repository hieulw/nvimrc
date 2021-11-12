let g:mapleader=' '
let plugin_dir=stdpath('data') . '/plugged'
let config_dir=stdpath('config') . '/modules'
let g:python3_host_prog='~/.pyenv/versions/py3nvim/bin/python'
let g:polyglot_disabled=['autoindent', 'ftdetect'] " Increase Performance

" Plugins
call plug#begin(plugin_dir)


"" Probably gonna leave them here, it's not stable experience yet for my use case

" Plug 'neovim/nvim-lspconfig' " LSP server config
" Plug 'kabouzeid/nvim-lspinstall' " LSP Install
" Plug 'hrsh7th/nvim-cmp' " Autocompletion plugin
" Plug 'hrsh7th/cmp-nvim-lsp' " LSP source for nvim-cmp
" Plug 'hrsh7th/cmp-buffer' " Buffer source for nvim-cmp
" Plug 'hrsh7th/cmp-vsnip' " Snippets source for nvim-cmp
" Plug 'hrsh7th/vim-vsnip' " Snippets plugin
" Plug 'rafamadriz/friendly-snippets' " Available snippets
" Plug 'onsails/lspkind-nvim' " Icons
" Plug 'ray-x/lsp_signature.nvim' " Help Signature
" Plug 'nvim-lua/lsp-status.nvim' " LSP progress in statusline
" Plug 'simrat39/symbols-outline.nvim'

Plug 'sainnhe/gruvbox-material'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'lewis6991/gitsigns.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'junegunn/vim-easy-align'
Plug 'voldikss/vim-floaterm'
Plug 'akinsho/toggleterm.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
Plug 'qpkorr/vim-bufkill'
Plug 'ahmedkhalf/project.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-dap-python'

call plug#end()

" Utilities
source $HOME/.config/nvim/modules/basic.vim
source $HOME/.config/nvim/modules/autocommand.vim

" Plugins Configuration
" source $HOME/.config/nvim/modules/lsp.lua
source $HOME/.config/nvim/modules/autopairs.lua
source $HOME/.config/nvim/modules/bufdel.lua
source $HOME/.config/nvim/modules/coc.vim
source $HOME/.config/nvim/modules/comment.lua
source $HOME/.config/nvim/modules/dadbod.vim
source $HOME/.config/nvim/modules/dap.lua
source $HOME/.config/nvim/modules/git.lua
source $HOME/.config/nvim/modules/mapping.vim
source $HOME/.config/nvim/modules/neoscroll.lua
source $HOME/.config/nvim/modules/neovide.vim
source $HOME/.config/nvim/modules/project.lua
source $HOME/.config/nvim/modules/sniprun.lua
source $HOME/.config/nvim/modules/telescope.lua
source $HOME/.config/nvim/modules/terminal.lua
source $HOME/.config/nvim/modules/theme.vim
source $HOME/.config/nvim/modules/tree.lua
source $HOME/.config/nvim/modules/treesitter.lua
source $HOME/.config/nvim/modules/statusline.lua
