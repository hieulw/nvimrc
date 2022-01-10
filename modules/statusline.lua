local utils = require('lualine.utils.utils')

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox',
        always_divide_middle = true,
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
        disabled_filetypes = {'fugitive_blame'}
    },
    sections = {
        lualine_a = {{'mode', fmt = function(str) return str:sub(1, 1) end}},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {
            {
                'diff',
                colored = true, -- displays diff status in color if set to true
                -- all colors are in format #rrggbb
                diff_color = {
                    added = {
                        fg = utils.extract_highlight_colors('GitSignsAdd', 'fg')
                    },
                    modified = {
                        fg = utils.extract_highlight_colors('GitSignsChange',
                                                            'fg')
                    },
                    removed = {
                        fg = utils.extract_highlight_colors('GitSignsDelete',
                                                            'fg')
                    }
                },
                symbols = {added = ' ', modified = '柳', removed = ' '}, -- changes diff symbols
                source = nil -- A function that works as a data source for diff.
                -- it must return a table like
                -- {added = add_count, modified = modified_count, removed = removed_count }
                -- Or nil on failure. Count <= 0 won't be displayed.
            }, {
                'diagnostics',
                -- table of diagnostic sources, available sources:
                -- nvim_lsp, coc, ale, vim_lsp
                sources = {'nvim_diagnostic', 'coc'},
                -- displays diagnostics from defined severity
                sections = {'error', 'warn', 'info', 'hint'},
                -- all colors are in format #rrggbb
                diagnostics_color = {
                    error = {
                        fg = utils.extract_highlight_colors('CocErrorSign', 'fg')
                    },
                    warn = {
                        fg = utils.extract_highlight_colors('CocWarningSign',
                                                            'fg')
                    },
                    info = {
                        fg = utils.extract_highlight_colors('CocInfoSign', 'fg')
                    },
                    hint = {
                        fg = utils.extract_highlight_colors('CocHintSign', 'fg')
                    }

                }
            }, 'filetype'
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}
