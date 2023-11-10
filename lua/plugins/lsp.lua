local attach = function(client, bufnr)
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
  nmap("gd", vim.lsp.buf.definition, "Go to Definition")
  nmap("gy", vim.lsp.buf.type_definition, "Go to Type Definition")
  nmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
  nmap("gI", vim.lsp.buf.implementation, "Go to Implementation")
  nmap("gr", vim.lsp.buf.references, "Go to References")
  nmap("<leader>lr", vim.lsp.buf.rename, "Rename")
  nmap("<leader>la", vim.lsp.buf.code_action, "Code Action")
  nmap("<leader>lds", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
  nmap("<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, {
    desc = "Format current buffer with LSP",
  })

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  vim.api.nvim_clear_autocmds({ group = "LspFormat", buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "LspFormat",
    buffer = bufnr,
    callback = function()
      if client.name == "typescript-tools" then
        vim.cmd("silent! TSToolsAddMissingImports")
      end
      if client.name == "eslint" then
        vim.cmd("silent! EslintFixAll")
      end
    end,
  })

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
      "nvimtools/none-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neoconf.nvim",
      "folke/neodev.nvim",
      "b0o/schemastore.nvim",
      "antosha417/nvim-lsp-file-operations",
    },
    config = function()
      local servers = {
        lua_ls = {
          Lua = {
            workspace = {
              -- Make the server aware of Neovim runtime files
              -- library = vim.api.nvim_get_runtime_file("", true),
              -- library = {
              --   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              --   [vim.fn.stdpath("config") .. "/lua"] = true,
              -- },
              checkThirdParty = "Disable",
            },
            runtime = { version = "LuaJIT" },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
            hint = { enable = true },
          },
        },
        gopls = {
          completeUnimported = true,
          usePlaceHolders = true,
          analyses = { unusedparams = true, shadow = true },
          staticcheck = true,
          experimentalPostfixCompletions = true,
        },
        jsonls = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
        cssls = {},
        eslint = {},
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local augroup = vim.api.nvim_create_augroup("LspFormat", { clear = true })
      if ok then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end
      local null_ls = require("null-ls")

      require("lsp-file-operations").setup()

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
          if vim.tbl_contains({ "tsserver" }, server_name) then
            return
          end
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = attach,
            settings = servers[server_name],
            handlers = {
              ["textDocument/definition"] = function(err, result, ...)
                -- always go to the first definition
                if vim.tbl_islist(result) or type(result) == "table" then
                  result = result[1]
                end
                vim.lsp.handlers["textDocument/definition"](err, result, ...)
              end,
            },
          })
        end,
      })
      require("mason-null-ls").setup({
        ensure_installed = { "gofumpt", "goimports" },
        automatic_installation = false,
        handlers = {},
      })
      null_ls.setup({
        sources = {},
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- Only format if buffer is unloaded or has been modified
                if vim.api.nvim_buf_get_option(bufnr, "modified") then
                  vim.lsp.buf.format({ name = "null-ls", bufnr = bufnr })
                end
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = attach,
      tsserver_file_preferences = {
        -- Inlay Hints
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      expose_as_code_action = "all",
      complete_function_calls = true,
    },
  },
}
