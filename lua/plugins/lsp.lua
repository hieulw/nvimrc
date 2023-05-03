local servers = {
    lua_ls = {
        Lua = {
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
        },
    },
  jsonls = {}
}

local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, {
            buffer = bufnr,
            -- nnoremap = true,
            -- silent = true,
            desc = desc,
        })
    end
    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, {
        desc = "Format current buffer with LSP",
    })

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    vim.diagnostic.config({
        virtual_text = false,
        signs = false,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
    })
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "williamboman/mason.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "jay-babu/mason-null-ls.nvim",
            -- Useful status updates for LSP
            { "j-hui/fidget.nvim", opts = {} },
            -- Additional lua configuration, makes nvim stuff amazing!
            "folke/neoconf.nvim",
            "folke/neodev.nvim",
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if ok then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end

            require("neoconf").setup()
            require("neodev").setup()

            require("mason").setup({
                ui = { border = "rounded", width = 0.6, height = 0.7 },
            })
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
            })
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                    })
                end,
            })
            require("mason-null-ls").setup({
                ensure_installed = { "stylua", "jq" },
                automatic_installation = false,
                handlers = {},
            })
            require("null-ls").setup({ sources = {} })
        end,
    },
}
