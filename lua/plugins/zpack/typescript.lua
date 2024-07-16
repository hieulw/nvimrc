return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "javascript",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "typescript-language-server",
        "eslint-lsp",
        -- "biome",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        -- nls.builtins.formatting.biome,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "pmizio/typescript-tools.nvim" },
    opts = {
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
        -- biome = {},
        ["typescript-tools"] = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
              if result.diagnostics == nil then
                return
              end

              -- ignore some tsserver diagnostics
              local idx = 1
              while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]

                local formatter = require("format-ts-errors")[entry.code]
                entry.message = formatter and formatter(entry.message) or entry.message

                -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                if entry.code == 80001 then
                  -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end

              vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
            end,
          },
        },
      },
      setup = {
        eslint = function()
          require("plugins.lsp.utils").on_attach("eslint", function(client, _)
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function(e)
                local diag = vim.diagnostic.get(e.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end,
            })
          end)
        end,
        tsserver = function()
          -- skip mason-lspconfig auto setup
          return true
        end,
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "davidosomething/format-ts-errors.nvim" },
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    opts = {
      tsserver_file_preferences = {
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
    config = function(_, opts)
      require("plugins.lsp.utils").on_attach("typescript-tools", function(_, bufnr)
        vim.keymap.set(
          "n",
          "<leader>lo",
          "<cmd>TSToolsOrganizeImports<cr>",
          { buffer = bufnr, desc = "Organize Imports" }
        )
        vim.keymap.set("n", "<leader>lO", "<cmd>TSToolsSortImports<cr>", { buffer = bufnr, desc = "Sort Imports" })
        vim.keymap.set("n", "<leader>lu", "<cmd>TSToolsRemoveUnused<cr>", { buffer = bufnr, desc = "Removed Unused" })
        vim.keymap.set(
          "n",
          "<leader>ld",
          "<cmd>TSToolsGoToSourceDefinition<cr>",
          { buffer = bufnr, desc = "Go To Source Definition" }
        )
        vim.keymap.set(
          "n",
          "<leader>lR",
          "<cmd>TSToolsRemoveUnusedImports<cr>",
          { buffer = bufnr, desc = "Removed Unused Imports" }
        )
        vim.keymap.set("n", "<leader>lF", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr, desc = "Fix All" })
        vim.keymap.set(
          "n",
          "<leader>lA",
          "<cmd>TSToolsAddMissingImports<cr>",
          { buffer = bufnr, desc = "Add Missing Imports" }
        )
      end)
      require("typescript-tools").setup(opts)
    end,
  },
}
