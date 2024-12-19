return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline", "mermaid" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "marksman",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    event = "LazyFile",
    opts = {
      auto_load = true,
      close_on_bdelete = true,
      syntax = true,
      theme = "light",
      update_on_change = true,
      app = "webview",
      filetype = { "markdown" },
      throttle_at = 200000,
      throttle_time = "auto",
    },
    config = function(_, opts)
      -- install: pacman -S webkit2gtk
      require("peek").setup(opts)
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
