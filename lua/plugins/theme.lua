return {
  {
    "nvchad/nvim-colorizer.lua",
    event = "LazyFile",
    config = function()
      require("colorizer").setup({
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
      })
    end,
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
        TelescopeResultsDiffChange = { link = "GitSignsChange" },
        TelescopeResultsDiffAdd = { link = "GitSignsAdd" },
        TelescopeResultsDiffDelete = { link = "GitSignsDelete" },
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
    opts = function()
      local icon = require("hieulw.icons")
      local custom_gruvbox = require("hieulw.colors").lualine

      local mode = {
        "mode",
      }

      local filetype = {
        "filetype",
        icon_only = true,
      }

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = icon.diagnostics.BoldError .. " ",
          hint = icon.diagnostics.BoldHint .. " ",
          info = icon.diagnostics.BoldInformation .. " ",
          warn = icon.diagnostics.BoldWarning .. " ",
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }

      local diff = {
        "diff",
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
        symbols = {
          added = icon.git.LineAdded .. " ",
          modified = icon.git.LineModified .. " ",
          removed = icon.git.LineRemoved .. " ",
        },
        colored = true,
        always_visible = false,
      }

      return {
        options = {
          theme = vim.g.colors_name == "gruvbox" and custom_gruvbox or "auto",
          globalstatus = true,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
        },
        sections = {
          lualine_a = { mode },
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { diff, diagnostics, filetype },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
  { "nvim-tree/nvim-web-devicons", event = "LazyFile" },
  { "muniftanjim/nui.nvim", event = "LazyFile" },
}
