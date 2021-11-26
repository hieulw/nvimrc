" Key Bindings

" My hand too lazy to reach Esc
inoremap <silent> kj <Esc>

" nano feel here
nnoremap <silent><C-q> :q<cr>
nnoremap <silent><C-s> :w<cr>

" Better tabbing
vnoremap L >gv
vnoremap H <gv
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" Better window navigation
nnoremap <silent><C-h> :wincmd h<cr>
nnoremap <silent><C-j> :wincmd j<cr>
nnoremap <silent><C-k> :wincmd k<cr>
nnoremap <silent><C-l> :wincmd l<cr>
" Use alt + hjkl to resize windows
nnoremap <silent><M-k> :resize -2<CR>
nnoremap <silent><M-j> :resize +2<CR>
nnoremap <silent><M-l> :vertical resize -2<CR>
nnoremap <silent><M-h> :vertical resize +2<CR>
if (has("macunix"))
  nnoremap <silent>˚ :resize -2<CR>
  nnoremap <silent>∆ :resize +2<CR>
  nnoremap <silent>¬ :vertical resize -2<CR>
  nnoremap <silent>˙ :vertical resize +2<CR>
endif
" Switch between vertical and horizontal
nnoremap <leader>sh <C-w>t<C-w>K
nnoremap <leader>sv <C-w>t<C-w>H

" Better scroll
nnoremap <C-y> 5<C-y>
nnoremap <C-e> 5<C-e>

tnoremap <Esc> <C-\><C-n>
nnoremap <leader><bs> :nohlsearch<cr>

" Fugitive Conflict Resolution
nnoremap <leader>gd :Gvdiff!<CR>
nnoremap <leader>gdh :diffget //2<CR>
nnoremap <leader>gdl :diffget //3<CR>

" Functions
nnoremap <leader>e :FloatermNew vifm<cr>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>d :DBUIToggle<CR>
nnoremap <leader>n :NvimTreeFindFileToggle<CR>

" Debug Adapter Protocol
nnoremap <silent> gsc :lua require'dap'.continue()<CR>
nnoremap <silent> gs :lua require'dap'.step_over()<CR>
nnoremap <silent> gsi :lua require'dap'.step_into()<CR>
nnoremap <silent> gso :lua require'dap'.step_out()<CR>
nnoremap <silent> gb :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> gB :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> gBL :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
nnoremap <silent> <leader>b :lua require'dapui'.toggle()<CR>

augroup TestPython
  autocmd!
  autocmd FileType python nnoremap <silent> <buffer> <leader>dn :lua require('dap-python').test_method()<CR>
  autocmd FileType python nnoremap <silent> <buffer> <leader>df :lua require('dap-python').test_class()<CR>
  autocmd FileType python vnoremap <silent> <buffer> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>
augroup end

" Easy Align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Apply @record to multiple lines
" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Better Yank
nnoremap Y y$
" https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
function! RestoreRegister() 
  let @" = s:restore_reg
  if &clipboard == "unnamedplus"
    let @+ = s:restore_reg
  endif
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  if &clipboard == "unnamedplus"
    let s:restore_reg = @+
  endif
  return "p@=RestoreRegister()\<cr>"
endfunction
" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()

" Keep cursor center
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Visual text process
vnoremap gs :sort<cr>
vnoremap gj :join<cr>

" Undo breakpoint
inoremap , ,<c-g>u
inoremap . .<c-g>u

" Jumplist mutations
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
