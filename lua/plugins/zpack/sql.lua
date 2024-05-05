return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "sql" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "sqls" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sqls = {},
      },
      setup = {
        sqls = function()
          local filepath = vim.fs.joinpath(vim.g.db_ui_save_location, "connections.json")
          local file = io.open(filepath, "r")
          local connections = {}
          if file then
            connections = vim.json.decode(file:read("*a"))
            file:close()
          end
          if #connections == 0 then
            return true
          end

          for _, conn in ipairs(connections) do
            conn.alias = conn.name
            conn.driver = conn.url:sub(0, conn.url:find(":") - 1)
            conn.dataSourceName = conn.url
            conn.name = nil
            conn.url = nil
          end

          require("lspconfig").sqls.setup({
            autostart = false,
            settings = {
              sqls = {
                connections = connections,
              },
            },
          })
          return true
        end,
      },
    },
  },
  -- {
  --   "nanotee/sqls.nvim",
  --   config = function()
  --     require("plugins.lsp.utils").on_attach("sqls", function(client, buffer)
  --       require("sqls").on_attach(client, buffer)
  --     end)
  --   end,
  -- },
}
