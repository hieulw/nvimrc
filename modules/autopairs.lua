require('nvim-autopairs').setup({
    disable_filetype = {"TelescopePrompt", "vim"},
    enable_moveright = true,
    enable_afterquote = true, -- add bracket pairs after quote
    enable_check_bracket_line = true, --- check bracket in same line
    check_ts = false, -- check treesitter
    map_c_w = true, -- map <c-w> to delete an pair if possible
    map_cr = true,
    map_bs = true -- map the <BS> key
})
-- you need setup cmp first put this after cmp.setup()
-- require("nvim-autopairs.completion.cmp").setup({
--     map_cr = true, --  map <CR> on insert mode
--     map_complete = true, -- it will auto insert `(` after select function or method item
--     auto_select = true -- automatically select the first item
-- })
