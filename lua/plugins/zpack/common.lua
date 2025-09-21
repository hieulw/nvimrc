return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "hyprlang",
        "hurl",
        "just",
        "json",
        "jsonc",
        "yaml",
        "html",
        "css",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettierd",
        "yaml-language-server",
        "json-lsp",
        "css-lsp",
        "html-lsp",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.prettierd.with({
          extra_filetypes = { "blade" },
          disabled_filetypes = { "yaml" },
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {},
        jsonls = {},
        cssls = {},
        html = {},
      },
    },
  },
  {
    "manzanit0/k8s-whisper.nvim",
    config = function()
      require("k8s-whisper").setup({
        -- This is a GitHub repository
        schemas_catalog = "datreeio/CRDs-catalog",
        -- This is a git ref, branch, tag, sha, etc.
        schema_catalog_ref = "main",
      })
    end,
  },
}
