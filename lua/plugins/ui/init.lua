return {
  {
    "nvchad/nvim-colorizer.lua",
    event = "LazyFile",
    names = "colorizer",
    opts = {
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "virtualtext", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = "lsp", -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
        virtualtext = require("hieulw.icons").ui.Round,
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        comments = true,
        operators = false,
        folds = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" },
        CmpItemAbbrDeprecated = { link = "DiagnosticDeprecated" },
        DapStoppedLine = { default = true, link = "Visual" },
        DapUIPlayPause = { link = "GruvboxGreen" },
        DapUIRestart = { link = "GruvboxGreen" },
        DapUIStepInto = { link = "GruvboxAqua" },
        DapUIStepOver = { link = "GruvboxAqua" },
        DapUIStepOut = { link = "GruvboxAqua" },
        DapUIStepBack = { link = "GruvboxAqua" },
        DapUIStop = { link = "GruvboxRed" },
        Delimiter = { link = "GruvboxFg1" },
        FzfLuaDirPart = { link = "GruvboxBg2" },
        PmenuSel = { link = "TabLineSel" },
        WinBarNC = { link = "WinBar" },
        NormalSB = { link = "Normal" },
        Folded = { bg = "None" },
        UfoFoldedBg = { link = "MatchBackground" },
      },
      dim_inactive = false,
      transparent_mode = true,
    },
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
