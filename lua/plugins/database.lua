return {
  "tpope/vim-dadbod",
  dependencies = {
    "kristijanhusak/vim-dadbod-ui",
  },
  keys = {
    { "<leader>dd", "<cmd>DBUIToggle<cr>", desc = "Toggle Database" },
  },
  init = function()
    vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_disable_mappings = 1
    vim.g.db_ui_use_nvim_notify = 1
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_table_helpers = {
      -- postgresql = {
      --   -- TODO: add useful queries
      -- },
    }
    vim.g.db_ui_hide_schemas = {
      -- "pg_catalog",
      -- "information_schema",
      -- "mysql",
      -- "performance_schema",
    }
  end,
  config = function()
    local function map(mode, l, r, desc)
      local opts = {
        silent = true,
        nowait = true,
        buffer = 0,
      }
      opts.desc = desc or nil
      vim.keymap.set(mode, l, r, opts)
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function(e)
        require("lspconfig").sqls.launch()
        require("cmp").setup.buffer({
          mapping = require("cmp.config").get().mapping,
          sources = {
            { name = "nvim_lsp", priority = 1000 },
            { name = "vsnip", priority = 750 },
          },
        })
        map({ "n", "v" }, "gx", "<Plug>(DBUI_ExecuteQuery)")
        map("n", "<leader>W", "<Plug>(DBUI_SaveQuery)")
        map("n", "<leader>E", "<Plug>(DBUI_EditBindParameters)")
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dbui",
      callback = function()
        map("n", "<C-R>", "<Plug>(DBUI_Redraw)")
        map("n", "o", "<Plug>(DBUI_SelectLine)")
        map("n", "d", "<Plug>(DBUI_DeleteLine)")
        map("n", "a", "<Plug>(DBUI_AddConnection)")
        map("n", "r", "<Plug>(DBUI_RenameLine)")
        map("n", "q", "<Plug>(DBUI_Quit)")
        map("n", "H", "<Plug>(DBUI_GotoParentNode)")
        map("n", "L", "<Plug>(DBUI_GotoChildNode)")
        map("n", "K", "<Plug>(DBUI_GotoPrevSibling)")
        map("n", "J", "<Plug>(DBUI_GotoNextSibling)")
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dbout",
      callback = function()
        map("n", "gd", "<Plug>(DBUI_JumpToForeignKey)", "Jump to Foreign Key")
        map("n", "vic", "<Plug>(DBUI_YankCellValue)", "Visual Cell Value")
        map("n", "yh", "<Plug>(DBUI_YankHeader)", "Yank Header")
        map("n", "R", "<Plug>(DBUI_ToggleResultLayout)", "Toggle Result Layout")
      end,
    })
  end,
}
