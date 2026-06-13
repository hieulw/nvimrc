return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.parsers, { "go", "gomod", "gosum", "gowork", "gotmpl" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gopls",
        "goimports",
        -- "golines",
        "delve",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = {
          "goimports",
          -- "golines",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          require("plugins.lsp.utils").on_attach("gopls", function(client, buffer)
            -- workaround for gopls not supporting semanticTokensProvider
            ---@see https://github.com/golang/go/issues/54531#issuecomment-1464982242
            if not client.server_capabilities.semanticTokensProvider then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = {
                    "namespace",
                    "type",
                    "typeParameter",
                    "parameter",
                    "property",
                    "variable",
                    "function",
                    "method",
                    "macro",
                    "keyword",
                    "comment",
                    "string",
                    "number",
                    "operator",
                    "label",
                  },
                  tokenModifiers = {
                    "definition",
                    "readonly",
                    "defaultLibrary",
                    "static",
                    "array",
                    "bool",
                    "chan",
                    "format",
                    "interface",
                    "map",
                    "number",
                    "pointer",
                    "signature",
                    "slice",
                    "string",
                    "struct",
                    "shadowing",
                  },
                },
                range = true,
              }
            end

            -- workaround for the lack of a DAP strategy in neotest-go
            ---@see https://github.com/nvim-neotest/neotest-go/issues/12
            vim.keymap.set("n", "<leader>td", function()
              require("dap-go").debug_test()
            end, { buf = buffer, desc = "Debug Nearest (Go)" })
          end)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "leoluz/nvim-dap-go", config = true },
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-go" },
    opts = {
      adapters = {
        ["neotest-go"] = {
          args = { "-coverprofile=coverage.out" },
          recursive_run = true,
        },
      },
    },
  },
}
