return {
  {
    "nvchad/nvim-colorizer.lua",
    event = "LazyFile",
    names = "colorizer",
    opts = {
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = false,
        css_fn = false,
        mode = "virtualtext",
        tailwind = "lsp",
        sass = { enable = false, parsers = { "css" } },
        virtualtext = ("%s "):format(require("hieulw.icons").ui.Round),
        always_update = false,
      },
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
    end,
  },
}
