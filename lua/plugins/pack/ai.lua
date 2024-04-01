return {
  {
    "exafunction/codeium.vim",
    event = "InsertEnter",
    init = function()
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_manual = true
      vim.g.codeium_enabled = false
      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        ["dap-repl"] = false,
      }
    end,
    config = function()
      local cmp = require("cmp")
      local lualine = require("lualine")
      local icons = require("hieulw.icons")

      vim.keymap.set("i", "<C-]>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-]>", function()
        if cmp.visible() then
          cmp.abort()
        end
        return vim.fn["codeium#CycleOrComplete"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("n", "<leader>lta", "<cmd>CodeiumToggle<cr>", { desc = "Toggle Codeium" })
      vim.keymap.set("n", "<leader>ltA", function()
        if not vim.g.codeium_enabled then
          return
        end
        if vim.g.codeium_manual then
          vim.cmd("CodeiumAuto")
        else
          vim.cmd("CodeiumManual")
        end
      end, { desc = "Toggle Codeium Automatic" })

      lualine.setup({
        sections = {
          lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, {
            function()
              local status = vim.trim(vim.fn["codeium#GetStatusString"]())
              if not status then
                return
              end
              if vim.g.codeium_manual == false then
                status = "AUTO:" .. status
              end
              return icons.kind.Codeium .. " " .. status
            end,
          }),
        },
      })
    end,
  },
}
