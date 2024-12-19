return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "tailwindcss-language-server", "rustywind" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.rustywind.with({
          extra_filetypes = { "blade" },
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          root_dir = require("lspconfig.util").root_pattern(
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts"
          ),
        },
      },
      setup = {},
    },
  },
  -- {
  --   "luckasranarison/tailwind-tools.nvim",
  --   opts = {
  --     document_color = {
  --       enabled = false, -- can be toggled by commands
  --     },
  --   }, -- your configuration
  -- },
}
