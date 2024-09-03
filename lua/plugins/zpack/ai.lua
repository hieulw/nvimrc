return {
  {
    "monkoose/neocodeium",
    event = "InsertEnter",
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
      vim.keymap.set("i", "<M-;>", function()
        if codeium.visible() then
          codeium.accept()
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
              local status = vim.trim(codeium.get_status()):lower()
              if not status then
                return
              end
              if opts.manual == false then
                status = "AUTO:" .. status
              end
              return icons.ui.Robot .. " " .. status
            end,
          }),
        },
      })
    end,
  },
}
