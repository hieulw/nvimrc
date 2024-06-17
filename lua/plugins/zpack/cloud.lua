return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bicep",
        "terraform",
        "helm",
        "groovy",
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
        "npm-groovy-lint",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.npm_groovy_lint,
        nls.builtins.diagnostics.npm_groovy_lint,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bicep = {
          cmd = {
            "dotnet",
            vim.fn.stdpath("data")
              .. "/mason/packages/bicep-lsp"
              .. "/extension/bicepLanguageServer/Bicep.LangServer.dll",
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
