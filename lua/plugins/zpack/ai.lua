return {
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<C-j>",
        clear_suggestion = "<C-e>",
        accept_word = "<C-y>",
      },
      condition = function()
        local path = vim.fn.expand("%:p")
        return path:match(".*/gopass.*$") ~= nil or path:match(".*/.ssh/.*$") ~= nil
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
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionAction" },
    keys = {
      { "<leader>af", "<cmd>CodeCompanionAction<cr>", mode = "n", desc = "CodeCompanionAction" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "CodeCompanionChat" },
      { "<leader>aa", "<cmd>CodeCompanion<cr>", mode = "x", desc = "CodeCompanion" },
    },
    opts = {
      display = {
        chat = {
          window = {
            opts = { colorcolumn = "0", number = false, relativenumber = false },
          },
        },
        diff = {
          enabled = true,
        },
      },
      strategies = {
        chat = {
          adapter = "gemini",
        },
        inline = {
          adapter = "gemini",
        },
      },
    },
  },
}
