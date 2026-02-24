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
    version = "^18.0.0",
    dependencies = {
      "ravitemer/mcphub.nvim",
    },
    event = "VeryLazy",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionAction" },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionAction<cr>", mode = { "n", "v" }, desc = "CodeCompanionAction" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanionChat" },
      { "<leader>av", "<cmd>CodeCompanion Add<cr>", mode = "v", desc = "CodeCompanion" },
    },
    opts = {
      display = {
        action_palette = {
          prompt = "Prompt ",
          provider = "fzf_lua",
          opts = {
            show_preset_actions = true,
            show_preset_prompts = true,
            title = "Prompt actions> ",
          },
        },
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
          adapter = {
            name = "opencode",
          },
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
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = false,
    event = "InsertEnter",
    dependencies = {
      -- "copilotlsp-nvim/copilot-lsp",
      -- "andrem222/copilot-lualine",
    },
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
        trigger_on_accept = true,
        keymap = {
          accept = "<C-j>",
          accept_word = "<C-y>",
          next = "<M-n>",
          prev = "<M-p>",
          dismiss = "<C-e>",
          toggle_auto_trigger = false,
        },
      },
      filetypes = {
        yaml = true,
      },
    },
  },
}
