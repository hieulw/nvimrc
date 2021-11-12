" Just use the terminal's background color
" if (has("autocmd") && !has("gui_running"))
"   augroup colorset
"     autocmd!
"     let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
"     autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
"   augroup END
" endif

" Support True Color
if (has("termguicolors"))
    set termguicolors   " Use 24-bit (true-color)
    hi LineNr ctermbg=NONE guibg=NONE 
    " set t_ZH=^[[3m
    " set t_ZR=^[[23m
    let g:onedark_hide_endofbuffer=1
    " let g:onedark_terminal_italics=1
    let g:onedark_termcolors=256
    let g:gruvbox_italic=1
    let g:gruvbox_flat_style='dark'
    let g:gruvbox_hide_inactive_statusline=1
    let g:gruvbox_material_background='medium' " soft, medium, hard
    let g:gruvbox_material_ui_contrast='low' " low, high
    let g:gruvbox_material_enable_italic=1
    let g:gruvbox_material_sign_column_background='none' " none, default
    let g:gruvbox_material_menu_selection_background='grey' " grey, red, orange, yellow, green, aqua, blue, purple
    let g:gruvbox_material_show_eob=0
    let g:gruvbox_material_statusline_style='original' " default, mix, original
    let g:gruvbox_material_better_performance=1
    let g:gruvbox_material_diagnostic_text_highlight=0
    let g:gruvbox_material_palette='original' " material, mix, original
    let g:gruvbox_material_diagnostic_virtual_text='grey' " grey, colored
endif

" Set colorscheme
set background=dark
colorscheme gruvbox-material

" Overwrite Highlight
" highlight ColorColumn ctermbg=0 guibg=lightgre
highlight SignColumn ctermbg=0 guibg=lightgre
highlight link CocCursorRange IncSearch
highlight link CocHighlightText PmenuSBar

" Starter page
let g:startify_files_number = 6
let g:startify_center = 55
let g:startify_fortune_use_unicode = 1
let g:startify_custom_header = "startify#center(startify#fortune#boxed())"

" Status line
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox_material'
let g:lightline.component = {
  \   'lineinfo': '%3l:%-2v%<',
  \ }
let g:lightline.mode_map = {
        \ 'n' : 'N',
        \ 'i' : 'I',
        \ 'R' : 'R',
        \ 'v' : 'V',
        \ 'V' : 'VL',
        \ "\<C-v>": 'VB',
        \ 'c' : 'C',
        \ 's' : 'S',
        \ 'S' : 'SL',
        \ "\<C-s>": 'SB',
        \ 't': 'T',
        \ }
let g:lightline.component_function = {
    \   'cocstatus': 'coc#status',
    \   'currentfunction': 'CocCurrentFunction',
    \   'lspstatus': 'LspStatus',
    \   'fugitive': 'GitHead',
    \   'method': 'NearestMethodOrFunction'
    \ }
let g:lightline.active = {
    \   'left': [[ 'mode', 'paste' ],
    \            [ 'fugitive', 'filename', 'lspstatus', 'cocstatus', 'method']]
    \ }
let g:lightline.separator = { 'left': "\ue0c0", 'right': "\ue0c2" }
let g:lightline.subseparator = { 'left': "\ue0b5", 'right': "\ue0b7" }

function! GitHead()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ''.branch : ''
  endif
  if exists('b:gitsigns_head')
    let branch = b:gitsigns_head
    return branch !=# '' ? ''.branch : ''
  endif
  return ''
endfunction

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" Syntax highlight
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

" Floaterm
let g:floaterm_width = 0.88
let g:floaterm_height = 0.88
let g:floaterm_wintitle = 0
let g:floaterm_autoclose = 1

highlight link FloatermBorder Floaterm

" Smoothie
let g:smoothie_no_default_mappings = v:true

" Git Gutter
highlight GruvboxGreenSign ctermbg=0 guibg=lightgre
highlight GruvboxAquaSign ctermbg=0 guibg=lightgre
highlight GruvboxRedSign ctermbg=0 guibg=lightgre
" autocmd ColorScheme * highlight NormalFloat guibg=#1f2335
" autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335

highlight MatchParen cterm=underline gui=underline
highlight MatchParenCur cterm=underline gui=underline
