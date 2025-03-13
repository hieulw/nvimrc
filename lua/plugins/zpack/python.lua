return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "basedpyright",
        "pyright",
        "ruff",
        "djlint",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.djlint,
        nls.builtins.diagnostics.djlint,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "microsoft/python-type-stubs" },
    opts = {
      servers = {
        ruff = {},
        -- basedpyright = {
        --   ---@see https://docs.basedpyright.com/latest/configuration/language-server-settings/
        --   settings = {
        --     basedpyright = {
        --       disableLanguageServices = false,
        --       disableOrganizeImports = false,
        --       disableTaggedHints = false,
        --       analysis = {
        --         autoImportCompletions = true,
        --         autoSearchPaths = true,
        --         diagnosticMode = "openFilesOnly",
        --         typeCheckingMode = "standard",
        --         stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
        --       },
        --     },
        --     python = {
        --       pythonPath = vim.fn.expand("${workspaceFolder}/.venv/bin/python"),
        --     },
        --   },
        -- },
        pyright = {
          ---@see https://github.com/microsoft/pyright/blob/main/docs/settings.md
          settings = {
            pyright = {
              disableLanguageServices = false,
              disableOrganizeImports = true,
              disableTaggedHints = false,
            },
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
                useLibraryCodeForTypes = true,
                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
                extraPaths = {},
              },
              pythonPath = vim.fn.expand("${workspaceFolder}/.venv/bin/python"),
            },
          },
        },
      },
      setup = {
        ruff = function()
          require("plugins.lsp.utils").on_attach("ruff", function(client, _)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
            -- Auto organize imports on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              callback = function(e)
                if vim.bo[e.buf].filetype ~= "python" then
                  return
                end
                ---@class lsp.Client
                client.request_sync("workspace/executeCommand", {
                  command = "ruff.applyOrganizeImports",
                  arguments = {
                    {
                      uri = vim.uri_from_bufnr(e.buf),
                      version = vim.lsp.util.buf_versions[e.buf],
                    },
                  },
                }, nil, e.buf)
              end,
            })
          end)
        end,
        basedpyright = function(_, _)
          require("plugins.lsp.utils").on_attach("basedpyright", function(_, bufnr)
            vim.keymap.set(
              "n",
              "<leader>lo",
              "<cmd>PyrightOrganizeImports<cr>",
              { desc = "Organize Imports", buffer = bufnr }
            )
          end)
        end,
        pyright = function(_, _)
          require("plugins.lsp.utils").on_attach("pyright", function(_, bufnr)
            vim.keymap.set(
              "n",
              "<leader>lo",
              "<cmd>PyrightOrganizeImports<cr>",
              { desc = "Organize Imports", buffer = bufnr }
            )
          end)
        end,
      },
    },
  },
}
