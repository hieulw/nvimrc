return {
  {
    "monkoose/neocodeium",
    event = "InsertEnter",
    enabled = false,
    opts = {
      manual = true,
      show_label = true,
      debounce = true,
      filetypes = {
        TelescopePrompt = false,
        ["dap-repl"] = false,
      },
    },
    config = function(_, opts)
      local codeium = require("neocodeium")
      local cmp = require("cmp")
      local icons = require("hieulw.icons")
      local lualine = require("lualine")

      codeium.setup(opts)

      -- completion
      cmp.event:on("menu_opened", function()
        vim.cmd.NeoCodeium("disable")
        codeium.clear()
      end)
      cmp.event:on("menu_closed", function()
        vim.cmd.NeoCodeium("enable")
      end)

      -- keymaps
      vim.keymap.set("i", "<M-l>", function()
        if codeium.visible() then
          codeium.accept()
        else
          return "<Right>"
        end
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-n>", function()
        if cmp.visible() then
          cmp.abort()
        end
        codeium.cycle_or_complete()
      end, { silent = true })
      vim.keymap.set("i", "<M-p>", function()
        codeium.cycle_or_complete(-1)
      end, { silent = true })

      -- statusbar
      lualine.setup({
        sections = {
          lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, {
            function()
              local status, _ = require("neocodeium").get_status()
              local status_symbols = {
                [0] = "󱜙 ", -- Enabled
                [1] = "󱚧 ", -- Disabled Globally
                [2] = "󱚧 ", -- Disabled for Buffer (catch-all)
                [3] = "󱚧 ", -- Disabled for Buffer filetype
                [4] = "󱚧 ", -- Disabled Callback
                [5] = "󱚧 ", -- Disabled for Buffer encoding
              }

              return status_symbols[status]
            end,
          }),
        },
      })
    end,
  },
  {
    "supermaven-inc/supermaven-nvim",
    -- event = "InsertEnter",
    opts = {
      condition = function()
        if vim.fn.expand("%:p"):match(".*/gopass.*$") ~= nil then
          return true
        end
        if vim.fn.expand("%:p"):match(".*/.ssh/.*$") ~= nil then
          return true
        end
        return false
      end,
    },
    config = function(_, opts)
      local supermaven = require("supermaven-nvim")
      local lualine = require("lualine")
      supermaven.setup(opts)

      lualine.setup({
        sections = {
          lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, {
            function()
              return require("supermaven-nvim.api").is_running() and "󱜙 " or "󱚧 "
            end,
          }),
        },
      })
    end,
  },
  "olimorris/codecompanion.nvim",
}
