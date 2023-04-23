return {
    -- Work with several variants of a word at once
    -- :%S instead of :%s for smartcase
    {
        'tpope/vim-abolish',
        keys = {
            {'crs', mode = 'n', desc = 'Change to snake_case'},
            {'crm', mode = 'n', desc = 'Change to MixedCase'},
            {'crc', mode = 'n', desc = 'Change to camelCase'},
            {'cru', mode = 'n', desc = 'Change to UPPER_CASE'},
            {'cr-', mode = 'n', desc = 'Change to dash-case'},
            {'cr.', mode = 'n', desc = 'Change to dot.case'},
            {'cr<space>', mode = 'n', desc = 'Change to space case'}
        },
        cmd = {'Abolish', 'Subvert'}
    }, -- {
    --     'tpope/vim-commentary',
    --     keys = {
    --         {'gcc', mode = 'n', desc = 'Go comment'},
    --         {'gcu', mode = 'n', desc = 'Go uncomment'},
    --         {'gc', mode = {'n', 'v', 'o'}, desc = 'Go comment with motion'}
    --     }
    -- }
--[[     {
        'tpope/vim-surround',
        keys = {
            {'ds', mode = 'n', desc = 'Delete surround'},
            {'cs', mode = 'n', desc = 'Change surround'},
            {'cS', mode = 'n', desc = 'Change surround-blockwise'},
            {'ys', mode = 'n', desc = 'Insert surround'},
            {'yS', mode = 'n', desc = 'Insert surround-blockwise with motion'},
            {'yss', mode = 'n', desc = 'Insert surround line'},
            {'ySs', mode = 'n', desc = 'Insert surround-blockwise'},
            {'ySS', mode = 'n', desc = 'Insert surround-blockwise'},
            {'<C-S>', mode = 'i', desc = 'Insert surround [insert mode]'},
            {'<C-G>s', mode = 'i', desc = 'Insert surround [insert mode]'},
            {'<C-G>S', mode = 'i', desc = 'Insert surround [insert mode]'}
        }
    } ]]
  -- 'tpope/vim-fugitive' -- 'tpope/vim-sleuth'

}
