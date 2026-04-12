return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.parsers, {
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
      vim.list_extend(opts.ensure_installed, { "roslyn" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        roslyn_ls = {
          cmd = {
            vim.fn.stdpath("data") .. "/mason/packages/roslyn/roslyn",
            "--logLevel", -- this property is required by the server
            "Information",
            "--extensionLogDirectory", -- this property is required by the server
            vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls/logs"),
            "--stdio",
          },
        },
      },
    },
  },
  -- {
  --   ---@see https://github.com/seblyng/roslyn.nvim#-installation
  --   "seblyng/roslyn.nvim",
  --   ---@module 'roslyn.config'
  --   ---@type RoslynNvimConfig
  --   opts = {},
  -- },
}
