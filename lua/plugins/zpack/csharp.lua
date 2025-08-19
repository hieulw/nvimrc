return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "c_sharp",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.registries, {
        "github:Crashdummyy/mason-registry",
      })
      vim.list_extend(opts.ensure_installed, {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        roslyn = {},
      },
    },
  },
  {
    ---@see https://github.com/seblyng/roslyn.nvim#-installation
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },
}
