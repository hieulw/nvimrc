return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettierd",
        "yaml-language-server",
        "json-lsp",
        -- "css-lsp",
        -- "emmet-language-server",
        -- "html-lsp",
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.prettierd,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "someone-stole-my-name/yaml-companion.nvim" },
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {},
          },
        },
        terraformls = {},
        jsonls = {},
        -- cssls = {},
        -- emmet_language_server = {},
        -- html = {},
      },
      setup = {
        yamlls = function(_, opts)
          local config = require("yaml-companion").setup({ lspconfig = opts })
          require("lspconfig").yamlls.setup(config)
          return true
        end,
      },
    },
  },
}
