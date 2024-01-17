return {
  {
    "NvChad/nvim-colorizer.lua",
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
        overrides = {
          TelescopeResultsDiffChange = { link = "GitSignsChange" },
          TelescopeResultsDiffAdd = { link = "GitSignsAdd" },
          TelescopeResultsDiffDelete = { link = "GitSignsDelete" },
          CmpItemAbbrMatchFuzzy = { link = "CmpIntemAbbrMatch" },
          CmpItemAbbrDeprecated = { link = "DiagnosticDeprecated" },
          PmenuSel = { link = "TabLineSel" },
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
    opts = function()
      local icon = require("hieulw.icons")
      local custom_gruvbox = require("hieulw.colors").lualine

      local mode = {
        "mode",
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
        symbols = {
          added = icon.git.LineAdded .. " ",
          modified = icon.git.LineModified .. " ",
          removed = icon.git.LineRemoved .. " ",
        },
        colored = true,
        always_visible = false,
      }

      local lsp = {
        function()
          local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
          if #buf_clients == 0 then
            return ""
          end

          local buf_ft = vim.bo.filetype
          local buf_client_names = {}
          local copilot_active = false

          -- add client
          for _, client in pairs(buf_clients) do
            if not vim.list_contains({ "null-ls", "copilot", "yamlls" }, client.name) then
              table.insert(buf_client_names, client.name)
            end

            if client.name == "yamlls" then
              local schema = require("yaml-companion").get_buf_schema(0)
              if schema.result[1].name == "none" then
                table.insert(buf_client_names, client.name)
              else
                table.insert(buf_client_names, string.format("%s(%s)", client.name, schema.result[1].name))
              end
            end

            if client.name == "copilot" then
              copilot_active = true
            end
          end

          local unique_client_names = table.concat(buf_client_names, " ")
          local language_servers = string.format("%s", unique_client_names)

          if copilot_active then
            language_servers = language_servers .. "%#SLCopilot#" .. " " .. icon.git.Octoface .. "%*"
          end

          return language_servers
        end,
        colored = true,
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
          lualine_c = { "filename", lsp },
          lualine_x = { diff, diagnostics },
          lualine_y = {},
          lualine_z = {},
        },
      }
    end,
  },
  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },
  { "muniftanjim/nui.nvim" },
  {
    "linrongbin16/lsp-progress.nvim",
    event = "LspAttach",
    config = function()
      local lualine = require("lualine")
      local lsp_progress = require("lsp-progress")
      lsp_progress.setup({})
      lualine.setup({
        sections = {
          lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, { lsp_progress.progress }),
        },
      })
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = lualine.refresh,
      })
    end,
  },
}
