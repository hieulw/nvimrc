return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", mode = "n", desc = "Find File" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", mode = "n", desc = "Grep String" },
      { "<leader><tab>", "<cmd>Telescope buffers<CR>", mode = "n", desc = "Buffers" },
      { "<leader>fe", "<cmd>Telescope file_browser<CR>", mode = "n", desc = "File Explorer" },
      { "<leader>f?", "<cmd>Telescope builtin<CR>", mode = "n", desc = "Builtin" },
      { "<leader><leader>", "<cmd>Telescope resume<CR>", mode = "n", desc = "Resume Telescope" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      local icon = require("hieulw.icons")
      local theme = "dropdown" -- ivy | dropdown | cursor
      local file_name_display = function(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        end
        return string.format("%s\t\t%s", tail, parent)
      end

      telescope.setup({
        defaults = {
          prompt_prefix = string.format("%s ", icon.prompt.Search),
          selection_caret = string.format("%s ", icon.prompt.Selected),
          multi_icon = string.format("%s", icon.ui.Plus),
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_strategy = "flex",
          preview = false,
          layout_config = {
            prompt_position = "top",
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
            },
            n = { ["q"] = actions.close },
          },
        },
        pickers = {
          builtin = { include_extensions = true },
          buffers = {
            preview = true,
            theme = theme,
            ignore_current_buffer = true,
            sort_lastused = true,
            sort_mru = true,
            path_display = file_name_display,
          },
          find_files = {
            theme = theme,
            follow = true,
            hidden = true,
            path_display = file_name_display,
          },
          live_grep = {
            theme = theme,
            preview = true,
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_ivy() },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            theme = theme,
            hijack_netrw = true,
            preview = true,
            path = "%:p:h",
            mappings = {
              ["i"] = {
                ["<bs>"] = false,
              },
              ["n"] = {
                ["<bs>"] = fb_actions.goto_parent_dir,
              },
            },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("file_browser")
      telescope.load_extension("yaml_schema")
    end,
  },
}
