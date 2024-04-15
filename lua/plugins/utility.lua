return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", mode = "n", desc = "Toggle File Explorer" },
    },
    opts = {
      filters = {
        custom = { ".git" },
        dotfiles = false,
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      git = {
        enable = true,
        show_on_dirs = false,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = false,
      },
    },
  },
  {
    "kylechui/nvim-surround",
    event = "LazyFile",
    opts = {},
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = {
      timeout = tonumber(vim.opt.timeoutlen),
      mapping = { "kj" },
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
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async" },
    keys = function()
      local ufo = require("ufo")
      return {
        { "]z", ufo.goNextClosedFold, mode = "n", desc = "Next Fold" },
        { "[z", ufo.goPreviousClosedFold, mode = "n", desc = "Prev Fold" },
        { "zp", ufo.peekFoldedLinesUnderCursor, mode = "n", desc = "Peek fold" },
      }
    end,
    opts = {
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
      },
      preview = {
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          switch = "zp",
        },
        win_config = {
          winblend = 0,
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
    event = "InsertCharPre",
    config = function()
      require("im_select").setup()
    end,
  },
}
