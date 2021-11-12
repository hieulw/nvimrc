" https://stackoverflow.com/questions/26069278/hightlight-copied-area-on-vim
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=100}
augroup END

au TermOpen term://* setlocal nonumber norelativenumber | setfiletype terminal
