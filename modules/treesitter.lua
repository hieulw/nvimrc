require('nvim-treesitter.configs').setup({
    -- ensure_installed = "maintained",
    ignore_install = {},
    highlight = {enable = true, use_languagetree = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm'
        }
    },
    context_commentstring = {enable = true, enable_autocmd = false},
    indent = {enable = false}, -- experimental feature, not reliable
    autopairs = {enable = false}
})
