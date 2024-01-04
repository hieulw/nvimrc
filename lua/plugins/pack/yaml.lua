return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "yaml-language-server" })
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
