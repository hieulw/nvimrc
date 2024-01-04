return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua-language-server", "stylua" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, { nls.builtins.formatting.stylua })
    end,
  },
  {
    "neovim/nvim-lspconfig",
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
          lsp_utils.on_attach("lua_ls", function(_, buffer)
            vim.keymap.set("n", "<leader>dX", function()
              require("osv").run_this()
            end, { buffer = buffer, desc = "OSV Run" })
            vim.keymap.set("n", "<leader>dL", function()
              require("osv").launch({ port = 8086 })
            end, { buffer = buffer, desc = "OSV Launch" })
          end)
        end,
      },
    },
  },
}
