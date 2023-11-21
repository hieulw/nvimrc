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
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Go line comment" },
      { "gbc", mode = "n", desc = "Go block comment" },
      { "gc", mode = { "n", "v", "o" }, desc = "Go comment with motion" },
      { "gb", mode = { "n", "v", "o" }, desc = "Go comment with motion" },
    },
    opts = {
      pre_hook = function()
        return vim.bo.commentstring
      end,
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      require("nvim-autopairs").setup({ fast_wrap = {} })
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  { "windwp/nvim-ts-autotag" },
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
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "Wansmer/treesj",
    keys = function()
      local ok, treejs = pcall(require, "treesj")
      if not ok then
        return {}
      end
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
      local ok, treecl = pcall(require, "tree-climber")
      if not ok then
        return {}
      end
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
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete", "Bwipeout" },
    keys = {
      { "<leader>bd", "<cmd>Bdelete<cr>", mode = "n", desc = "Buffer delete" },
    },
  },
  {
    "axkirillov/hbac.nvim",
    opts = { threshold = 7 },
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
  { "NMAC427/guess-indent.nvim", event = "User File", opts = {} },
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
    event = { "User File", "InsertEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    keys = function()
      local ok, ufo = pcall(require, "ufo")
      if not ok then
        return {}
      end
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
      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return require("ufo").getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or function(bufnr)
            return require("ufo")
              .getFolds(bufnr, "lsp")
              :catch(function(err)
                return handleFallbackException(bufnr, err, "treesitter")
              end)
              :catch(function(err)
                return handleFallbackException(bufnr, err, "indent")
              end)
          end
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
      require("mini.bracketed").setup()
      require("mini.indentscope").setup({ symbol = "▏" })
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
