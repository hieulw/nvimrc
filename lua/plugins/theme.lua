return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      })

      vim.opt.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icon = require("hieulw.util").icon

      local mode = {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      }

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = icon.diagnostics.Error .. "",
          hint = icon.diagnostics.Hint .. "",
          info = icon.diagnostics.Info .. "",
          warn = icon.diagnostics.Warn .. "",
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }

      local diff = {
        "diff",
        symbols = {
          added = icon.git.added .. " ",
          untracked = icon.git.added .. " ",
          modified = icon.git.changed .. " ",
          removed = icon.git.deleted .. " ",
        },
        colored = true,
        always_visible = false,
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
        },
        sections = {
          lualine_a = { mode },
          lualine_b = {},
          lualine_c = {},
          lualine_x = { diff, diagnostics },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
}
