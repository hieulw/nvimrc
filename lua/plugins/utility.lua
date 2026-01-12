return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", mode = "n", desc = "File Explorer" },
    },
    opts = {
      hijack_cursor = true,
      filters = {
        custom = { "^.git$" },
        dotfiles = false,
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
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
      view = {
        adaptive_size = true,
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local mappings = {
          { "<2-LeftMouse>", api.node.open.edit, "Open" },
          { "<2-RightMouse>", api.tree.change_root_to_node, "CD" },
          { "<C-]>", api.tree.change_root_to_node, "CD" },
          { "<C-r>", api.tree.reload, "Refresh" },
          { "<C-v>", api.node.open.vertical, "Open: Vertical Split" },
          { "<C-x>", api.node.open.horizontal, "Open: Horizontal Split" },
          { "h", api.node.navigate.parent_close, "Close Directory" },
          { "l", api.node.open.edit, "Open" },
          { "H", api.node.navigate.parent, "Parent Directory" },
          { "J", api.node.navigate.sibling.next, "Next Sibling" },
          { "K", api.node.navigate.sibling.prev, "Previous Sibling" },
          { "L", api.node.open.no_window_picker, "Open: No Window Picker" },
          { "-", api.tree.change_root_to_parent, "Up" },
          { "a", api.fs.create, "Create File Or Directory" },
          { "x", api.fs.cut, "Cut" },
          { "c", api.fs.copy.node, "Copy" },
          { "p", api.fs.paste, "Paste" },
          { "d", api.fs.remove, "Delete" },
          { "D", api.fs.trash, "Trash" },
          { "r", api.fs.rename, "Rename" },
          { "R", api.fs.rename_full, "Rename: Full Path" },
          { "e", api.fs.rename_basename, "Rename: Basename" },
          { "yy", api.fs.copy.absolute_path, "Copy Absolute Path" },
          { "y$", api.fs.copy.filename, "Copy Name" },
          { "ye", api.fs.copy.basename, "Copy Basename" },
          { "Y", api.fs.copy.relative_path, "Copy Relative Path" },
          { "gx", api.node.run.system, "Run System" },
          { "g?", api.tree.toggle_help, "Help" },
          { ".", api.node.run.cmd, "Run Command" },
          { "q", api.tree.close, "Close" },
          { "<leader>tb", api.tree.toggle_no_buffer_filter, "Toggle Filter: No Buffer" },
          { "<leader>tg", api.tree.toggle_git_clean_filter, "Toggle Filter: Git Clean" },
          { "<leader>td", api.tree.toggle_hidden_filter, "Toggle Filter: Dotfiles" },
          { "<leader>ti", api.tree.toggle_gitignore_filter, "Toggle Filter: Git Ignore" },
          { "<leader>tc", api.tree.toggle_custom_filter, "Toggle Filter: Hidden" },
        }
        for _, mapping in ipairs(mappings) do
          vim.keymap.set("n", mapping[1], mapping[2], {
            desc = mapping[3],
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          })
        end
      end,
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      ignored_filetypes = { "NvimTree" },
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      resize_mode = { silent = true },
    },
    keys = function()
      local split = require("smart-splits")
      return {
        { "<C-h>", split.move_cursor_left, mode = { "n" }, desc = "Move cursor to left pane" },
        { "<C-j>", split.move_cursor_down, mode = { "n" }, desc = "Move cursor to bottom pane" },
        { "<C-k>", split.move_cursor_up, mode = { "n" }, desc = "Move cursor to top pane" },
        { "<C-l>", split.move_cursor_right, mode = { "n" }, desc = "Move cursor to right pane" },
        { "<M-Left>", split.resize_left, mode = { "n" }, desc = "Resize pane to the left" },
        { "<M-Down>", split.resize_down, mode = { "n" }, desc = "Resize pane to the bottom" },
        { "<M-Up>", split.resize_up, mode = { "n" }, desc = "Resize pane to the top" },
        { "<M-Right>", split.resize_right, mode = { "n" }, desc = "Resize pane to the right" },
        { "<leader>wh", split.swap_buf_left, mode = { "n" }, desc = "Swap with left pane" },
        { "<leader>wj", split.swap_buf_down, mode = { "n" }, desc = "Swap with bottom pane" },
        { "<leader>wk", split.swap_buf_up, mode = { "n" }, desc = "Swap with top pane" },
        { "<leader>wl", split.swap_buf_right, mode = { "n" }, desc = "Swap with right pane" },
      }
    end,
  },
  {
    "hieulw/im-select.nvim",
    event = "InsertCharPre",
    enabled = false,
    config = function()
      require("im_select").setup()
    end,
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
    "magicduck/grug-far.nvim",
    opts = {
      -- options, see Configuration section below
      -- there are no required options atm
      -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
      -- be specified
    },
    cmd = { "GrugFar" },
  },
}
