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
      enable_get_fold_virt_text = true,
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
        local ufo = require("ufo")
        local function fallback_provider(bufnr, err, provider)
          if type(err) == "string" and err:match("UfoFallbackException") then
            return ufo.getFolds(bufnr, provider)
          else
            return require("promise").reject(err)
          end
        end
        local function treesitter_folds(bufnr)
          local res = ufo.getFolds(bufnr, "treesitter")
          if res == nil then
            return nil
          end
          local folds = {} ---@type table<integer,UfoFoldingRange>
          for _, fold in ipairs(res) do
            if not folds[fold.startLine] then
              folds[fold.startLine] = fold
            end
          end
          return folds
        end
        -- only use indent until a file is opened
        return (filetype == "" or buftype == "nofile") and "indent"
          or function(bufnr)
            return ufo
              .getFolds(bufnr, "lsp")
              :thenCall(function(res) ---@param res UfoFoldingRange[]
                if res == nil then
                  return nil
                end
                local ts_folds = treesitter_folds(bufnr)
                if ts_folds then
                  for _, fold in ipairs(res) do
                    if ts_folds[fold.startLine] then
                      fold.endLine = ts_folds[fold.startLine].endLine
                      fold.endCharacter = nil
                    end
                  end
                end
                return res
              end)
              :catch(function(err)
                return fallback_provider(bufnr, err, "treesitter")
              end)
              :catch(function(err)
                return fallback_provider(bufnr, err, "indent")
              end)
          end
      end,
      fold_virt_text_handler = function(vtext, slnum, elnum, width, truncate, ctx)
        ---@see https://github.com/kevinhwang91/nvim-ufo/issues/26
        local end_patterns = { "end[,)]*", "[%])}]+[,;]?", "</[%w.]*>" }
        local endline = vim.trim(vim.fn.getline(elnum))
        local end_vtext = {}
        for _, pattern in ipairs(end_patterns) do
          if endline:find(pattern) == 1 then
            end_vtext = ctx.get_fold_virt_text(elnum)
            end_vtext[1][1] = end_vtext[1][1]:gsub("^%s+", "")
            break
          end
        end
        table.insert(vtext, {
          (" %s %d "):format(require("hieulw.icons").misc.Fold, elnum - slnum),
          "UfoFoldedEllipsis",
        })
        vim.list_extend(vtext, end_vtext)
        return vtext
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
