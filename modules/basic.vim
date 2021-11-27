" Basic configurations
set hidden                                " Required to keep multiple buffers open multiple buffers set autoread
set autoread                              " auto update buffer
set autowrite                             " auto update buffer
set gdefault                              " global search by default
set ignorecase                            " ignore case search
set smartcase                             " override ignorecase if search uppercase pattern
set noautochdir                           " do not change cwd when open new buffer
set encoding=utf-8                        " the encoding displayed
set fileencoding=utf-8                    " the encoding written to file
set ruler                                 " show the cursor position all the time
set cmdheight=1                           " More space for displaying messages
set iskeyword+=-                          " treat dash separated words as a word text object"
set mouse=a                               " Enable your mouse
set splitbelow                            " Horizontal splits will automatically be below
set splitright                            " Vertical splits will automatically be to the right
set t_Co=256                              " Support 256 colors
set conceallevel=0                        " So that I can see `` in markdown files
set tabstop=2                             " Insert 2 spaces for a tab
set shiftwidth=2                          " Change the number of space characters inserted for indentation set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                             " Converts tabs to spaces
set smartindent                           " Makes indenting smart
set autoindent                            " Good auto indent
set number                                " Line numbers
set relativenumber                        " Relative line numbers
set cursorline                            " Enable highlighting of the current line
set laststatus=2                          " Let lightline handle status line
set showtabline=1                         " Always show tabs
set nofixendofline                        " Stop adding end of line character, annoying git diff
set nofoldenable                          " No folding by default
set noshowmode                            " We don't need to see things like -- INSERT -- anymore
set nobackup                              " This is recommended by coc
set nowritebackup                         " This is recommended by coc
set noswapfile                            " This is recommented by coc
set nostartofline                         " Move cursor more freedom
set nowrap                                " Display long lines as just one line
set pumheight=10                          " Makes popup menu smaller
set updatetime=300                        " Faster completion
set timeoutlen=500                        " By default timeoutlen is 1000 ms
set shortmess+=c                          " Shut off completion messages
set signcolumn=auto                       " Always show the signcolumn
set clipboard=unnamedplus                 " Copy paste between vim and everything else
set fillchars+=vert:\ ,stl:\ ,stlnc:\     " Oldshcool style
set completeopt=menu,noinsert,noselect    " no autofilling and no auto select first item in autocompletion menu
set showmatch                             " Highlight matching parenthesis
set incsearch                             " Incremental Search Highlight
set inccommand=nosplit                    " Incremental Replace Highlight
" set includeexpr=substitute(v:fname,'\\.','/','g')
" set suffixesadd=.py,.lua,.vim
set path=$PWD/**
set list
set listchars=tab:→\ ,trail:·,nbsp:·
" set guicursor=i-ci-ve:Cursor,r-cr-o:DiffDelete
" set guicursor+=i-ci-ve:blinkwait700-blinkoff400-blinkon250
" set guicursor+=a:block
set guifont=CaskaydiaCove\ Nerd\ Font\ Mono:h15
set colorcolumn=100
set shell=/bin/zsh " https://github.com/kyazdani42/nvim-tree.lua/issues/518

let g:loaded_python_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
" let g:loaded_matchparen = 1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
