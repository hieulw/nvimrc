let g:db_ui_auto_execute_table_helpers = 1
let g:db_ui_use_nerd_fonts = 1
let g:db_ui_win_position = 'right'
autocmd FileType dbout nmap <buffer> gd <Plug>(DBUI_JumpToForeignKey)
