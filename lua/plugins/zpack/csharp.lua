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
    ---@see https://github.com/seblyng/roslyn.nvim#-installation
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      config = {
        settings = {},
      },
    },
  },
}
