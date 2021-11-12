let g:coc_global_extensions = [
    \   'coc-html',
    \   'coc-css',
    \   'coc-json',
    \   'coc-java',
    \   'coc-pyright',
    \   'coc-sumneko-lua',
    \   'coc-sqlfluff',
    \   'coc-diagnostic',
    \   'coc-tsserver',
    \   'coc-prettier',
    \   'coc-snippets',
    \ ]

autocmd FileType python let b:coc_root_patterns = ['.git', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" \ pumvisible() ? coc#_select_confirm() :
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

let g:coc_snippet_next = "<tab>"
imap <C-j> <Plug>(coc-snippets-expand-jump)
vmap <C-j> <Plug>(coc-snippets-select)

" " Multi-cursors like VSCode and SublimeText
" nmap <expr> <silent> vv <SID>select_current_word()
" xmap <silent> <C-d> <Plug>(coc-cursors-range)
" function! s:select_current_word()
"   if !get(g:, 'coc_cursors_activated', 0)
"     return "\<Plug>(coc-cursors-word)"
"   endif
"   return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
" endfunc

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
if exists('*complete_info')
  inoremap <silent><expr> <cr> complete_info(['selected'])['selected'] != -1 ? "\<C-y>" : "\<C-g>u\<CR>"
endif

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

nnoremap <silent><expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><expr><C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><expr><C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><expr><C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><expr><C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references-used)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  <Plug>(coc-format-selected)

" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <leader>so  :CocOutline<CR>
nmap <leader>gl  <Plug>(coc-openlink)


" Use ,sd to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocAction('doHover')
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup Format
  autocmd!
  " Correct json comment highlighting
  autocmd FileType json syntax match Comment +\/\/.\+$+
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Automatically Formatting on save
  " autocmd BufWritePre * call CocAction('format')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
