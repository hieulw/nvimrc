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
    "neovim/nvim-lspconfig",
    dependencies = {
      "jmederosalvarado/roslyn.nvim",
      "iabdelkareem/csharp.nvim",
    },
    opts = {
      servers = {
        roslyn = {
          on_attach = function() end,
        },
      },
      setup = {
        roslyn = function(_, opts)
          local ok, roslyn = pcall(require, "roslyn")
          if ok then
            roslyn.setup(opts)
          end
          return true
        end,
      },
    },
  },
  -- {
  --   "iabdelkareem/csharp.nvim",
  --   dependencies = {
  --     "williamboman/mason.nvim", -- Required, automatically installs omnisharp
  --     "mfussenegger/nvim-dap",
  --     "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
  --   },
  --   config = function()
  --     require("csharp").setup()
  --   end,
  -- },
}
