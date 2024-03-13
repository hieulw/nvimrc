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
    dependencies = {
      "folke/neodev.nvim",
      opts = {
        library = {
          enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
          runtime = true, -- runtime path
          types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
          -- plugins = false, -- installed opt or start plugins in packpath
          plugins = { "nvim-lspconfig" },
        },
        lspconfig = true,
        pathStrict = true, -- lsp will load even though the file still not open yet
      },
    },
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
          handlers = {
            -- HACK: always go to the first definition
            ["textDocument/definition"] = function(err, result, ...)
              if vim.tbl_islist(result) or type(result) == "table" then
                if #result > 1 then
                  result = result[2]
                else
                  result = result[1]
                end
              end
              vim.lsp.handlers["textDocument/definition"](err, result, ...)
            end,
          },
        },
      },
      setup = {
        lua_ls = function()
          require("plugins.lsp.utils").on_attach("lua_ls", function(_, buffer)
            vim.keymap.set("n", "<leader>lx", function()
              vim.cmd("noautocmd write")
              vim.cmd.luafile("%")
            end, { buffer = buffer, desc = "Save and execute lua file" })
          end)
        end,
      },
    },
  },
}
