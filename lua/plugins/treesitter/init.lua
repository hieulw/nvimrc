return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "folke/ts-comments.nvim",
    },
    build = function()
      require("nvim-treesitter").update({ summary = true })
    end,
    opts = {
      parsers = { "vim", "vimdoc", "query" },
    },
    config = require("plugins.treesitter.config").setup,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = {
      max_lines = 3,
      trim_scope = "outer",
      mode = "cursor",
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {
      opts = {
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
      },
      aliases = {
        blade = "html",
      },
    },
  },
  {
    "andymass/vim-matchup",
    event = "LazyFile",
    config = function()
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_motion_enabled = 0
      vim.g.matchup_text_obj_enabled = 0
      vim.g.matchup_surround_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.api.nvim_set_hl(0, "MatchParen", { link = "Match" })
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = "LazyFile",
    opts = {},
  },
  {
    "johmsalas/text-case.nvim",
    event = "LazyFile",
    enabled = true,
    name = "textcase",
    opts = {
      default_keymappings_enabled = true,
      substitude_command_name = "Subvert",
      prefix = "cr",
    },
  },
}
