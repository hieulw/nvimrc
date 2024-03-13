return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "terraform-ls",
        "powershell-editor-services",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bicep = {
          cmd = {
            "dotnet",
            vim.fn.stdpath("data") .. "/mason/packages/bicep-lsp/extension/bicepLanguageServer/Bicep.LangServer.dll",
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
