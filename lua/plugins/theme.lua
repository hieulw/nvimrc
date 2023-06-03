return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colors = require("gruvbox.palette").get_base_colors(vim.o.background)
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
        overrides = {
          Normal = { fg = colors.fg1, bg = colors.bg0 },
          TelescopeResultsDiffChange = { link = "GitSignsChange" },
          TelescopeResultsDiffAdd = { link = "GitSignsAdd" },
          TelescopeResultsDiffDelete = { link = "GitSignsDelete" },
        },
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
      local icon = require("hieulw.helper").icon
      local custom_gruvbox = require("lualine.themes.gruvbox")
      custom_gruvbox.normal.c.bg = "#282828"
      custom_gruvbox.insert.c.bg = "#282828"

      local mode = {
        "mode",
      }

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = icon.diagnostics.Error .. " ",
          hint = icon.diagnostics.Hint .. " ",
          info = icon.diagnostics.Info .. " ",
          warn = icon.diagnostics.Warn .. " ",
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      }

      local diff = {
        "diff",
        symbols = {
          added = icon.git.Added .. " ",
          untracked = icon.git.Added .. " ",
          modified = icon.git.Changed .. " ",
          removed = icon.git.Deleted .. " ",
        },
        colored = true,
        always_visible = false,
      }

      local lsp = {
        function()
          local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
          if #buf_clients == 0 then
            return "LSP Inactive"
          end

          local buf_ft = vim.bo.filetype
          local buf_client_names = {}
          local copilot_active = false

          -- add client
          for _, client in pairs(buf_clients) do
            if client.name ~= "null-ls" and client.name ~= "copilot" then
              table.insert(buf_client_names, client.name)
            end

            if client.name == "copilot" then
              copilot_active = true
            end
          end

          -- -- add formatter
          -- local formatters = require("lvim.lsp.null-ls.formatters")
          -- local supported_formatters = formatters.list_registered(buf_ft)
          -- vim.list_extend(buf_client_names, supported_formatters)
          --
          -- -- add linter
          -- local linters = require("lvim.lsp.null-ls.linters")
          -- local supported_linters = linters.list_registered(buf_ft)
          -- vim.list_extend(buf_client_names, supported_linters)

          local unique_client_names = table.concat(buf_client_names, ", ")
          local language_servers = string.format("[%s]", unique_client_names)

          if copilot_active then
            language_servers = language_servers .. "%#SLCopilot#" .. " " .. icon.git.Octoface .. "%*"
          end

          return language_servers
        end,
        colored = true,
      }

      return {
        options = {
          theme = custom_gruvbox,
          globalstatus = true,
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { mode, "filename", lsp },
          lualine_x = { diff, diagnostics },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
  "nvim-tree/nvim-web-devicons",
}
