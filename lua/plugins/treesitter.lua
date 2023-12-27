return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "joosepalviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    init = function(plugin)
      -- REF: https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      vim.cmd.syntax("off")
    end,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    opts = {
      ensure_installed = "all",
      autotag = {
        enable = true,
        enable_close_on_slash = false,
      },
      matchup = { enable = true },
      indent = { enable = false },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      -- PERF: https://github.com/nvim-treesitter/nvim-treesitter/issues/3581
      -- commenting out the comment queries in injections.scm seem to fix performance issues
      require("nvim-treesitter.configs").setup(opts)
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
      vim.g.skip_ts_context_commentstring_module = true
      vim.treesitter.language.register("bash", { "tmux", "zsh", "sh" })
      vim.filetype.add({
        extension = {
          html = function(path, bufnr)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) or { "" }
            local content = table.concat(lines, "\n")
            if vim.regex([[{{\|{#\|{%\s.+\s%}\|#}\|}}]]):match_str(content) ~= nil then
              return "htmldjango"
            end
            return "html"
          end,
        },
      })
    end,
  },
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "rrethy/vim-illuminate",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      local illuminate = require("illuminate")
      illuminate.configure(opts)
      vim.keymap.set("n", "]r", function()
        illuminate.goto_next_reference(false)
      end, { desc = "Go to next reference" })
      vim.keymap.set("n", "[r", function()
        illuminate.goto_prev_reference(false)
      end, { desc = "Go to previous reference" })
    end,
  },
  { "nmac427/guess-indent.nvim", opts = {} },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
    end,
  },
  {
    "wansmer/treesj",
    keys = function()
      local treejs = require("treesj")
      return {
        { "<leader>tj", treejs.join, mode = "n", desc = "Join node" },
        { "<leader>ts", treejs.split, mode = "n", desc = "Split node" },
        { "<leader>tm", treejs.toggle, mode = "n", desc = "Toggle node" },
      }
    end,
    opts = { use_default_keymaps = false, max_join_length = 1000 },
  },
  {
    "drybalka/tree-climber.nvim",
    keys = function()
      local treecl = require("tree-climber")
      return {
        { "<M-n>", treecl.goto_next, mode = { "n", "v", "o" }, desc = "Go to next node" },
        { "<M-p>", treecl.goto_prev, mode = { "n", "v", "o" }, desc = "Go to previous node" },
        { "<M-i>", treecl.goto_child, mode = { "n", "v", "o" }, desc = "Go to child node" },
        { "<M-o>", treecl.goto_parent, mode = { "n", "v", "o" }, desc = "Go to parent node" },
        { "in", treecl.select_node, mode = { "v", "o" }, desc = "Select inside node" },
        { "<leader>tn", treecl.swap_next, mode = { "n" }, desc = "Swap next node" },
        { "<leader>tp", treecl.swap_prev, mode = { "n" }, desc = "Swap previous node" },
      }
    end,
  },
}
