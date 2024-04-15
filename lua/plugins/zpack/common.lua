return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "hyprlang",
        "bash",
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
        nls.builtins.formatting.prettierd,
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
      setup = {
        yamlls = function(_, opts)
          local config = require("yaml-companion").setup({
            builtin_matchers = {
              kubernetes = { enabled = true },
              cloud_init = { enabled = true },
            },
            lspconfig = opts,
          })
          require("lspconfig").yamlls.setup(config)
          require("telescope").load_extension("yaml_schema")
          return true
        end,
      },
    },
  },
  { "hieulw/yaml-companion.nvim", ft = "yaml" },
}
