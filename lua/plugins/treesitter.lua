return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "LazyFile",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "joosepalviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    init = function(plugin)
      -- Ref: https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = false }))
    end,
    opts = {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
      autotag = {
        enable = true,
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
      },
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
    config = function(_, opts)
      -- PERF: https://github.com/nvim-treesitter/nvim-treesitter/issues/3581
      -- commenting out the comment queries in injections.scm seem to fix performance issues
      require("nvim-treesitter.configs").setup(opts)
      require("ts_context_commentstring").setup({ enable_autocmd = false })
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
          tfstate = "json",
        },
        pattern = {
          [".*/hypr/.*%.conf"] = "hyprlang",
        },
      })
    end,
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
    opts = { default_keymappings_enabled = true, prefix = "ga" },
    config = function(_, opts)
      require("textcase").setup(opts)
    end,
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
  {
    "drybalka/tree-climber.nvim",
    keys = function()
      local treecl = require("tree-climber")
      local opts = { skip_comments = true, highlight = true, higroup = "Visual" }
      return {
        {
          "<M-n>",
          function()
            treecl.goto_next(opts)
          end,
          mode = { "n", "v" },
          desc = "Go to next node",
        },
        {
          "<M-p>",
          function()
            treecl.goto_prev(opts)
          end,
          mode = { "n", "v" },
          desc = "Go to previous node",
        },
        {
          "<M-i>",
          function()
            treecl.goto_child(opts)
          end,
          mode = { "n", "v" },
          desc = "Go to child node",
        },
        {
          "<M-o>",
          function()
            treecl.goto_parent(opts)
          end,
          mode = { "n", "v" },
          desc = "Go to parent node",
        },
        {
          "<M-S-n>",
          function()
            treecl.swap_next(opts)
          end,
          mode = { "n" },
          desc = "Swap next node",
        },
        {
          "<M-S-p>",
          function()
            treecl.swap_prev(opts)
          end,
          mode = { "n" },
          desc = "Swap previous node",
        },
        { "in", treecl.select_node, mode = { "v", "o" }, desc = "Select inside node" },
      }
    end,
  },
}
