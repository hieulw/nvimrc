return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline',
            {'hrsh7th/cmp-nvim-lsp', dependencies = 'neovim/nvim-lspconfig'}, {
                'saadparwaiz1/cmp_luasnip',
                dependencies = {
                    'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets'
                }
            }
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            luasnip.config.setup()
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {'i', 's'})
                }),
                sources = cmp.config.sources({
                    {name = 'nvim_lsp'}, {name = 'luasnip'}, {name = 'buffer'},
                    {name = 'path'}
                }),
                experimental = {native_menu = false, ghost_text = true}
            })
            cmp.setup.cmdline({'/', '?'}, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {{name = 'buffer'}}
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({{name = 'path'}},
                                             {{name = 'cmdline'}})
            })
        end
    }
}
