return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.parsers, {
        "bicep",
        "terraform",
        "helm",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bicep-lsp",
        "terraform-ls",
        "helm-ls",
        "powershell-editor-services",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        groovy = { "npm_groovy_lint" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        groovy = { "npm_groovy_lint" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bicep = {
          cmd = {
            vim.fn.stdpath("data") .. "/mason/packages/bicep-lsp/bicep-lsp",
          },
        },
        helm_ls = {
          settings = {
            ["helm-ls"] = {
              yamlls = {
                path = "yaml-language-server",
              },
            },
          },
        },
        powershell_es = {
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        },
        terraformls = {
          filetypes = { "tf", "terraform", "terraform-vars" },
        },
      },
    },
  },
}
