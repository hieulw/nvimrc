return {
  {
    "brenoprata10/nvim-highlight-colors",
    event = "LazyFile",
    opts = {
      render = "foreground",
      virtual_symbol = require("hieulw.icons").ui.Round,
      enable_named_colors = false,
      enable_tailwind = true,
      custom_colors = {},
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = require("plugins.ui.theme").config,
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.opt.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = require("plugins.ui.statusline").setup,
  },
  { "nvim-tree/nvim-web-devicons", event = "LazyFile" },
  {
    "muniftanjim/nui.nvim",
    event = "LazyFile",
    config = function()
      require("plugins.ui.input").setup()
      require("plugins.ui.quickfix").setup()
      require("plugins.ui.folding").setup()
    end,
  },
}
