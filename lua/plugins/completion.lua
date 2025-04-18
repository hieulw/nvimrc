return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      { "saghen/blink.compat", lazy = true },
      "rafamadriz/friendly-snippets",
      "rcarriga/cmp-dap",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      enabled = function()
        return (vim.bo.buftype ~= "prompt" and vim.b.completion ~= false) or vim.bo.filetype == "dap-repl"
      end,
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-j>"] = { "accept", "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          draw = {
            components = {
              label = {
                text = function(ctx)
                  return ctx.label:match("[^(]+") .. ctx.label_detail
                end,
              },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { "lazydev", "lsp", "path", "buffer" },
          ["dap-repl"] = { "dap" },
          gitcommit = { "snippets", "buffer" },
          AvanteInput = { "avante_commands", "avante_files", "avante_mentions" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
          dap = { name = "dap", module = "blink.compat.source" },
          avante_commands = { name = "avante_commands", module = "blink.compat.source" },
          avante_files = { name = "avante_files", module = "blink.compat.source" },
          avante_mentions = { name = "avante_mentions", module = "blink.compat.source" },
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-scissors",
    keys = function()
      local scissors = require("scissors")
      return {
        { "<leader>se", scissors.editSnippet, mode = "n", desc = "Edit Snippet" },
        { "<leader>sa", scissors.addNewSnippet, mode = { "n", "x" }, desc = "Add Snippet" },
      }
    end,
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
      editSnippetPopup = {
        height = 0.4, -- relative to the window, number between 0 and 1
        width = 0.6,
        border = "rounded",
        keymaps = {
          cancel = "q",
          saveChanges = "<CR>", -- alternatively, can also use `:w`
          goBackToSearch = "<BS>",
          deleteSnippet = "<C-x>",
          duplicateSnippet = "<C-d>",
          openInFile = "<C-o>",
          insertNextPlaceholder = "<C-t>", -- insert & normal mode
        },
      },
      jsonFormatter = "jq", -- "yq"|"jq"|"none"
    },
  },
}
