local lsp_config = require('lspconfig')
local lsp_install = require('lspinstall')
local completion = require('cmp')
local cmp_lsp = require('cmp_nvim_lsp')
local lsp_signature = require('lsp_signature')
local lsp_kind = require('lspkind')
local lsp_status = require('lsp-status')
local lsp_util = require('lspconfig/util')

local kind_symbols = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)

    -- Mappings.
    local function bufkey(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    bufkey('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    bufkey('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    bufkey('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    bufkey('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    bufkey('n', '<leader>so',
           '<cmd>lua require"symbols-outline".toggle_outline()<CR>', opts)
    bufkey('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    bufkey('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    -- Change diagnostic symbols in the sign column (gutter)
    local signs = {
        Error = "",
        Information = "",
        Hint = "",
        Warning = ""
    }
    for type, icon in pairs(signs) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
    end

    -- Signature help on function call
    lsp_signature.on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
        -- doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you DO NOT want any API comments be shown
        -- This setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default
        floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
        floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
        -- will set to true when fully tested, set to false will use whichever side has more space
        -- this setting will be helpful if you do not want the PUM and floating win overlap
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = false, -- virtual hint enable
        hint_prefix = " ", -- Panda for parameter
        hint_scheme = "String",
        use_lspsaga = false, -- set to true if you want to use lspsaga popup
        hi_parameter = "Search", -- how your parameter will be highlight
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        transpancy = 10, -- set this value if you want the floating windows to be transpant (100 fully transpant), nil to disable(default)
        handler_opts = {border = "none"}, -- double, single, shadow, none
        trigger_on_newline = false, -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
        extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
        debug = false, -- set to true to enable debug logging
        log_path = "debug_log_file_path", -- debug log path
        padding = '  ', -- character to pad on left and right of signature can be ' ', or '|'  etc
        timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
        toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    }, bufnr)

    -- Statusline
    lsp_status.on_attach(client)

    -- You will likely want to reduce updatetime which affects CursorHold
    -- vim.cmd [[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]
    vim.lsp.handlers['textDocument/publishDiagnostics'] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = false,
            underline = true,
            update_in_insert = false
        })

    -- Highlight symbols under cursor
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
    end

    -- Format on save
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[
    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    command! -nargs=0 Format :lua vim.lsp.buf.formatting()
    ]]
    end

end

local function make_config(server)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_lsp.update_capabilities(capabilities)
    capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
    local config = {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {debounce_text_changes = 500}
    }

    if server == "lua" then
        config.settings = {
            Lua = {
                runtime = {
                    -- LuaJIT in the case of Neovim
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';')
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                    }
                }
            }
        }
    end

    if server == "efm" then
        config.filetypes = {"lua", "python"}
        config.init_options = {documentFormatting = true}
        config.settings = {
            rootMarkers = {".git/"},
            languages = {
                lua = {{formatCommand = "lua-format -i", formatStdin = true}},
                python = {
                    {formatCommand = "black --quiet -", formatStdin = true}, {
                        formatCommand = "isort --quiet --stdout --profile black -",
                        formatStdin = true
                    }
                },
                javascript = {
                    {formatCommand = "prettier"}, {
                        lintCommand = 'eslint -f unix --stdin',
                        lintIgnoreExitCode = true,
                        lintStdin = true
                    }
                }
            }
        }
    end

    if server == "python" then
        local python_path = {
            "/Site/api.master/lib/arq-mqtt/src", "/Site/api.master/lib/fii/src",
            "/Site/api.master/lib/fii-cqrs/src",
            "/Site/api.master/lib/fii-datamap/src",
            "/Site/api.master/lib/fii-datapack/src",
            "/Site/api.master/lib/fii-datastruct/src",
            "/Site/api.master/lib/fii-kengine/src",
            "/Site/api.master/lib/fii-s3media/src",
            "/Site/api.master/lib/fii-workflow/src",
            "/Site/api.master/lib/fii-x12/src",
            "/Site/api.master/lib/pdf-generator/src",
            "/Site/api.master/lib/raw2tabular/src",
            "/Site/api.master/lib/redis-cqrs/src",
            "/Site/api.master/lib/sanic-connector/src",
            "/Site/api.master/lib/sanic-cqrs/src",
            "/Site/api.master/lib/sanic-kcauth/src",
            "/Site/api.master/lib/sanic-monitor/src",
            "/Site/api.master/lib/sanic-mqtt/src",
            "/Site/api.master/lib/sanic-oauth",
            "/Site/api.master/lib/fii-pdfgen/src",
            "/Site/api.master/lib/sanic-query/src",
            "/Site/api.master/lib/sanic-session/src",
            "/Site/api.master/lib/sanic-swagger/src",
            "/Site/api.master/lib/sanic-toolbox/src",
            "/Site/api.master/lib/sanic-validator/src",
            "/Site/api.master/lib/tecq-base/src",
            "/Site/api.master/lib/tecq-client/src",
            "/Site/api.master/app/contact-center-api/src",
            "/Site/api.master/app/contract-administration-api/src",
            "/Site/api.master/app/contract-management-api/src",
            "/Site/api.master/app/data-foundation-api/src",
            "/Site/api.master/app/ehr-management-api/src",
            "/Site/api.master/app/landing-page-api/src",
            "/Site/api.master/app/link-transformer-api/src",
            "/Site/api.master/app/member-engagement-api/src",
            "/Site/api.master/app/member-management-api/src",
            "/Site/api.master/app/notification-center-api/src",
            "/Site/api.master/app/provider-management-api/src",
            "/Site/api.master/app/provider-roster-api/src",
            "/Site/api.master/app/quality-management-api/src",
            "/Site/api.master/app/renderer-api/src",
            "/Site/api.master/app/tecq-platform-api/src",
            "/Site/api.master/app/user-management-api/src",
            "/Site/api.master/app/work-administration-api/src",
            "/Site/api.master/app/work-management-api/src"
        }

        for i, path in ipairs(python_path) do
            python_path[i] = vim.env['HOME'] .. path
        end

        config.settings = {
            python = {
                analysis = {extraPaths = python_path},
                venvPath = '~/.pyenv/versions',
                formatting = {provider = "black"}
            }
        }
        config.root_dir = function(fname)
            local root_files = {
                'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt',
                'Pipfile', 'pyrightconfig.json'
            }
            return lsp_util.root_pattern(unpack(root_files))(fname) or
                       lsp_util.find_git_ancestor(fname)
        end
    end

    return config
end

local function setup_servers()
    lsp_install.setup()
    lsp_status.config({
        kind_labels = kind_symbols,
        status_symbol = '',
        current_function = true,
        show_filename = false,
        diagnostics = true
    })
    lsp_status.register_progress()

    local servers = lsp_install.installed_servers()

    for _, server in pairs(servers) do
        lsp_config[server].setup(make_config(server))
    end

end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lsp_install.post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

--[[
Autocompletion
--]]

-- Show icon kind
lsp_kind.init({
    with_text = true, -- enables text annotations
    symbol_map = kind_symbols
})

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

completion.setup({
    completion = {
        completeopt = 'menuone,noinsert,noselect',
        autocomplete = false -- showing completion menu
    },
    formatting = {
        format = function(_, vim_item)
            vim_item.kind = lsp_kind.presets.default[vim_item.kind] .. ' [' ..
                                vim_item.kind .. ']'
            return vim_item
        end
    },
    snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
    mapping = {
        ['<C-p>'] = completion.mapping.select_prev_item(),
        ['<C-n>'] = completion.mapping.select_next_item(),
        ['<C-d>'] = completion.mapping.scroll_docs(-4),
        ['<C-f>'] = completion.mapping.scroll_docs(4),
        ['<C-Space>'] = completion.mapping.complete(),
        ['<C-e>'] = completion.mapping.close(),
        ['<CR>'] = completion.mapping.confirm {
            behavior = completion.ConfirmBehavior.Replace
            -- select = true, -- auto-fill on enter
        },
        ['<Tab>'] = completion.mapping(function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true,
                                                               true, true), 'n')
            elseif vim.fn["vsnip#available"]() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                    '<Plug>(vsnip-expand-or-jump)', true, true,
                                    true), '')
            elseif has_words_before() then
                completion.complete()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = completion.mapping(function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true,
                                                               true, true), 'n')
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                    '<Plug>(vsnip-jump-prev)', true, true, true),
                                '')
            else
                fallback()
            end
        end, {'i', 's'})
    },
    sources = {{name = 'nvim_lsp'}, {name = 'vsnip'}, {name = 'buffer'}}
})

--[[
Symbol Outline
--]]
vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = false,
    auto_preview = false,
    position = 'right',
    width = 20,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a"
    },
    lsp_blacklist = {},
    symbol_blacklist = {"Variable"}
}
