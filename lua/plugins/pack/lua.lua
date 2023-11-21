return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "stylua" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, _)
      local nls = require("null-ls")
      return { sources = { nls.builtins.formatting.stylua } }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { { "folke/neodev.nvim", opts = {} } },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = "Disable",
              },
              runtime = { version = "LuaJIT" },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim" } },
              hint = { enable = false },
            },
          },
        },
      },
      setup = {
        lua_ls = function(_, _)
          local lsp_utils = require("plugins.lsp.utils")
          lsp_utils.on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "lua_ls" then
              vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end,
                { buffer = buffer, desc = "OSV Run" })
              vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end,
                { buffer = buffer, desc = "OSV Launch" })
            end
          end)
        end,
      },
    },
  },
}
