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
  jsonls = {},
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
  -- nmap("gd", require("definition-or-references").definition_or_references, "Declaration or Usages")
  nmap("gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Declaration or Usages")
  nmap("<leader>lr", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>la", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("<leader>lds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
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
      local augroup = vim.api.nvim_create_augroup("LspFormat", {})
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

      require("null-ls").setup({
        sources = {},
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  name = "null-ls",
                  -- filter = function(_client)
                  --   return _client.name == "null-ls"
                  -- end,
                  bufnr = bufnr,
                })
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "KostkaBrukowa/definition-or-references.nvim",
    opts = {
      on_references_result = function(result)
        require("telescope.pickers")
          .new({}, {
            prompt_title = "LSP References",
            finder = require("telescope.finders").new_table({
              results = vim.lsp.util.locations_to_items(result, "utf-16"),
              entry_maker = require("telescope.make_entry").gen_from_quickfix(),
            }),
            previewer = require("telescope.config").values.qflist_previewer({}),
          })
          :find()
      end,
    },
  },
}
