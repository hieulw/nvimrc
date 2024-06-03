return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "folke/ts-comments.nvim",
    },
    init = function(plugin)
      ---@see https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = false }))
    end,
    opts = {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
      matchup = { enable = true },
      indent = { enable = false },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          if vim.list_contains({ "bash" }, lang) then
            return true
          end
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = { "markdown" },
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
    config = require("plugins.treesitter.config").setup,
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
  {
    "wansmer/treesj",
    keys = function()
      local treejs = require("treesj")
      return {
        { "gJ", treejs.toggle, mode = "n", desc = "Toggle Split Join" },
      }
    end,
    opts = { use_default_keymaps = false, max_join_length = 1000 },
  },
}
