return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "joosepalviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
      {
        "andymass/vim-matchup",
        config = function()
          vim.g.matchup_matchparen_hi_surround_always = 1
          vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
      },
      { "nmac427/guess-indent.nvim", opts = {} },
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
    },
    enable = false,
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make
      -- available during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
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
      matchup = {
        enable = true,
      },
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
    end,
  },
}
