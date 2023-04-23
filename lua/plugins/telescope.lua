return {
    'nvim-telescope/telescope.nvim',
    -- tag = '0.1.1',
    -- branch = '0.1.1',
    keys = {
        {
            '<C-p>',
            '<cmd>Telescope builtin include_extensions=true<CR>',
            mode = 'n',
            desc = 'Command Palette'
        }, {
            '<leader>f',
            '<cmd>Telescope find_files find_command=fd,-t,f,-HL<CR>',
            mode = 'n',
            desc = 'Find File'
        },
        {
            '<leader>g',
            '<cmd>Telescope live_grep<CR>',
            mode = 'n',
            desc = 'Grep String'
        },
        {
            '<leader><tab>',
            '<cmd>Telescope buffers<CR>',
            mode = 'n',
            desc = 'Buffers'
        }
    },
    dependencies = {
        'nvim-lua/plenary.nvim', {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function() return vim.fn.executable 'make' == 1 end,
            config = function()
                pcall(require('telescope').load_extension, 'fzf')
            end
        }
    }
}
