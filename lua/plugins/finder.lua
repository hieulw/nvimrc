return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<CR>", mode = "n", desc = "Find Files" },
    { "<leader>fo", "<cmd>FzfLua files<CR>", mode = "n", desc = "Old Files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<CR>", mode = "n", desc = "Grep String" },
    { "<leader>fg", "<cmd>FzfLua grep_visual<cr>", mode = "x", desc = "Grep String" },
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", mode = "n", desc = "Buffers" },
    { "<leader>f?", "<cmd>FzfLua builtin<CR>", mode = "n", desc = "Builtins" },
    { "<leader><leader>", "<cmd>FzfLua resume<CR>", mode = "n", desc = "Resume Finder" },
  },
  opts = function()
    local action = require("fzf-lua.actions")
    local icon = require("hieulw.icons")

    return {
      fzf_colors = { ["gutter"] = "-1" },
      winopts = {
        width = math.min(vim.o.columns, 80),
        height = math.min(vim.o.lines, 30),
        row = 0.1,
        col = 0.5,
        preview = {
          layout = "vertical",
          vertical = "up:60%",
          scrollbar = "border",
          winopts = { number = false },
        },
      },
      keymap = {
        builtin = {
          ["<C-/>"] = "toggle-help",
          ["<C-Space>"] = "toggle-fullscreen",
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["alt-a"] = "toggle-all",
        },
      },
      actions = {
        files = {
          ["default"] = action.file_edit_or_qf,
          ["ctrl-x"] = action.file_split,
          ["ctrl-v"] = action.file_vsplit,
          ["ctrl-t"] = action.file_tabedit,
          ["ctrl-q"] = action.file_sel_to_qf,
        },
        buffers = {
          ["default"] = action.buf_edit,
          ["ctrl-x"] = action.buf_split,
          ["ctrl-v"] = action.buf_vsplit,
          ["ctrl-t"] = action.buf_tabedit,
        },
      },
      fzf_opts = {
        ["--cycle"] = true,
        ["--no-hscroll"] = true,
        ["--pointer"] = icon.ui.Pointer,
        ["--marker"] = icon.ui.Selected,
      },
      defaults = {
        git_icons = false,
        prompt = ("%s "):format(icon.ui.Search),
      },
      files = {
        cwd_prompt = false,
        previewer = false,
        formatter = "path.filename_first",
        winopts = { height = math.min(vim.o.lines, 15) },
      },
      grep = {
        path_shorten = 1,
      },
    }
  end,
  config = function(_, opts)
    local fzflua = require("fzf-lua")
    fzflua.setup(opts)
    fzflua.register_ui_select(function(o, items)
      local min_h, max_h = 0.24, 0.6
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      if o.kind == "codeaction" then
        h = max_h
      end
      return { winopts = { height = h, row = 0.10 } }
    end)
  end,
}
