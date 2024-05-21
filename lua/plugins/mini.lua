-- Thanks to Evgeni Chasnovski for amazing plugins
--@see https://github.com/echasnovski/mini.nvim
return {
  {
    "echasnovski/mini.ai",
    event = "LazyFile",
    opts = function()
      local ai = require("mini.ai")
      return {
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }),
          c = ai.gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          }),
        },
        search_method = "cover_or_next",
        mappings = {
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
          goto_left = "",
          goto_right = "",
        },
      }
    end,
  },
  {
    "echasnovski/mini.align",
    keys = { "ga", "gA" },
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      { "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", mode = "n", desc = "Delete Buffer" },
      { "<leader>bw", "<cmd>lua MiniBufremove.wipeout()<cr>", mode = "n", desc = "Wipeout Buffer" },
    },
    opts = {},
  },
  {
    "echasnovski/mini.clue",
    event = "LazyFile",
    opts = function()
      local clue = require("mini.clue")
      local function gen_leaders()
        return {
          { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
          { mode = "n", keys = "<Leader>d", desc = "+Debug" },
          { mode = "n", keys = "<Leader>dh", postkeys = "<Leader>d" },
          { mode = "n", keys = "<Leader>dj", postkeys = "<Leader>d" },
          { mode = "n", keys = "<Leader>dk", postkeys = "<Leader>d" },
          { mode = "n", keys = "<Leader>dl", postkeys = "<Leader>d" },
          { mode = "n", keys = "<Leader>f", desc = "+Finders" },
          { mode = "n", keys = "<Leader>h", desc = "+Git" },
          { mode = "n", keys = "<Leader>l", desc = "+LSP" },
          { mode = "n", keys = "<Leader>p", desc = "+Popups" },
          { mode = "n", keys = "<Leader>s", desc = "+Snippets" },
          { mode = "n", keys = "<Leader>t", desc = "+Test/Task" },
          { mode = "n", keys = "<Leader>w", desc = "+Windows" },
        }
      end
      return {
        triggers = {
          { mode = "n", keys = "c" },
          { mode = "n", keys = "d" },
          { mode = "n", keys = "y" },
          { mode = "n", keys = "<Leader>" }, -- Leader triggers
          { mode = "x", keys = "<Leader>" },
          { mode = "n", keys = "g" }, -- `g` key
          { mode = "x", keys = "g" },
          { mode = "n", keys = "'" }, -- Marks
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },
          { mode = "n", keys = "]" }, -- Brackets
          { mode = "n", keys = "[" },
          { mode = "n", keys = '"' }, -- Registers
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },
          { mode = "n", keys = "<C-w>" }, -- Window commands
          { mode = "n", keys = "z" }, -- `z` key
          { mode = "x", keys = "z" },
        },
        clues = {
          clue.gen_clues.g(),
          clue.gen_clues.marks(),
          clue.gen_clues.registers(),
          clue.gen_clues.windows({
            submode_move = true,
            submode_navigate = true,
            submode_resize = true,
          }),
          clue.gen_clues.z(),
          gen_leaders(),
        },
      }
    end,
  },
  {
    "echasnovski/mini.files",
    keys = { { "-", "<cmd>=MiniFiles.open()<cr>", mode = "n", desc = "File Explorer" } },
    opts = {
      mappings = { synchronize = "<cr>" },
    },
  },
  {
    "echasnovski/mini.jump",
    keys = { "f", "t", "F", "T" },
    opts = {
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = ";",
      },
    },
  },
  {
    "echasnovski/mini.move",
    keys = {
      { "H", mode = "v" },
      { "L", mode = "v" },
      { "K", mode = "v" },
      { "J", mode = "v" },
    },
    opts = {
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
    },
  },
  {
    "echasnovski/mini.surround",
    keys = { { "gs", mode = { "n", "x" } }, "gss", "ds", "cs" },
    opts = function()
      local ts_input = require("mini.surround").gen_spec.input.treesitter
      return {
        custom_surroundings = {
          f = {
            input = ts_input({ outer = "@call.outer", inner = "@call.inner" }),
          },
        },
        mappings = {
          add = "gs",
          delete = "ds",
          replace = "cs",
          find = "",
          find_left = "",
          highlight = "",
          update_n_lines = "",
          suffix_last = "",
          suffix_next = "",
        },
        search_method = "cover_or_next",
      }
    end,
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.set("n", "gss", "gs_", { remap = true })
    end,
  },
}
