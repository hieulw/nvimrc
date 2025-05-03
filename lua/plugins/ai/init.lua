return {
  {
    "supermaven-inc/supermaven-nvim",
    keys = {
      { "<leader>ac", "<cmd>SupermavenToggle<cr>", mode = "n", desc = "SupermavenToggle" },
    },
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
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionAction" },
    keys = {
      { "<leader>fa", "<cmd>CodeCompanionAction<cr>", mode = "n", desc = "CodeCompanionAction" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "CodeCompanionChat" },
      { "<leader>aa", ":CodeCompanion<cr>", mode = "x", desc = "CodeCompanion" },
    },
    opts = {
      display = {
        chat = {
          window = {
            opts = { colorcolumn = "0", number = false, relativenumber = false },
          },
        },
        diff = {
          provider = "mini_diff",
        },
      },
      strategies = {
        chat = {
          adapter = "gemini",
          roles = {
            llm = function(adapter)
              return ("%s (%s)"):format(adapter.formatted_name, adapter.parameters.model)
            end,
            user = "hieulw",
          },
          keymaps = {
            send = {
              modes = { n = "<C-s>", i = "<C-s>" },
            },
            close = {
              modes = { n = "<Nop>", i = "<C-q>" },
            },
          },
        },
        inline = {
          adapter = "gemini",
        },
      },
    },
  },
}
