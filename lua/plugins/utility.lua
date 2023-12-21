return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", mode = "n", desc = "Toggle File Explorer" },
    },
    opts = {
      respect_buf_cwd = true,
      filters = {
        custom = { ".git" },
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
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
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    config = function()
      require("tabout").setup({
        tabkey = "<C-j>",
        backwards_tabkey = "<C-k>",
        act_as_tab = false,
        act_as_shift_tab = false,
      })
    end,
  },
  { "kylechui/nvim-surround", opts = {} },
  {
    "famiu/bufdelete.nvim",
    enable = false,
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      { "<leader>bd", "<cmd>Bdelete<cr>", mode = "n", desc = "Buffer delete" },
      { "<leader>bw", "<cmd>Bwipeout<cr>", mode = "n", desc = "Buffer wipeout" },
    },
  },
  {
    "axkirillov/hbac.nvim",
    opts = { threshold = 10 },
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      timeout = tonumber(vim.opt.timeoutlen),
      mapping = { "kj" },
      -- keys = function()
      --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
      -- end,
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
    keys = function()
      local ok, split = pcall(require, "smart-splits")
      if not ok then
        return {}
      end
      return {
        { "<C-h>", split.move_cursor_left, mode = { "n" }, desc = "Move cursor to left pane" },
        { "<C-j>", split.move_cursor_down, mode = { "n" }, desc = "Move cursor to bottom pane" },
        { "<C-k>", split.move_cursor_up, mode = { "n" }, desc = "Move cursor to top pane" },
        { "<C-l>", split.move_cursor_right, mode = { "n" }, desc = "Move cursor to right pane" },
        { "<leader>wr", split.start_resize_mode, mode = { "n" }, desc = "Enter resize mode" },
        { "<leader>wh", split.swap_buf_left, mode = { "n" }, desc = "Swap with left pane" },
        { "<leader>wj", split.swap_buf_down, mode = { "n" }, desc = "Swap with bottom pane" },
        { "<leader>wk", split.swap_buf_up, mode = { "n" }, desc = "Swap with top pane" },
        { "<leader>wl", split.swap_buf_right, mode = { "n" }, desc = "Swap with right pane" },
      }
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = { "InsertEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    keys = function()
      local ufo = require("ufo")
      return {
        { "zR", ufo.openAllFolds, mode = "n", desc = "Open all folds" },
        { "zM", ufo.closeAllFolds, mode = "n", desc = "Close all folds" },
        { "zr", ufo.openFoldsExceptKinds, mode = "n", desc = "Fold less" },
        { "zm", ufo.closeFoldsWith, mode = "n", desc = "Fold more" },
        { "zp", ufo.peekFoldedLinesUnderCursor, mode = "n", desc = "Peek fold" },
      }
    end,
    opts = {
      preview = {
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "hieulw/im-select.nvim",
    config = function()
      require("im_select").setup()
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({
        search_method = "cover_or_next",
        mappings = {
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
        },
      })
      require("mini.align").setup()
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      })
      require("mini.jump").setup()
      require("mini.move").setup({
        mappings = {
          left = "H",
          right = "L",
          down = "J",
          up = "K",
          line_left = "",
          line_right = "",
          line_down = "",
          line_up = "",
        },
      })
      require("mini.sessions").setup()
    end,
  },
}
