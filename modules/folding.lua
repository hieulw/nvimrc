local parsers = require 'nvim-treesitter.parsers'
local configs = parsers.get_parser_configs()
_FOLDING = require 'custom.folding'

-- TreeSitter Powered Folding
local filetypes = table.concat(vim.tbl_map(function(ft)
    return configs[ft].filetype or ft
end, parsers.available_parsers()), ',')

vim.cmd(string.format(
            'autocmd Filetype %s setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()',
            filetypes))

vim.wo.foldtext = "v:lua._FOLDING.foldtext()"
