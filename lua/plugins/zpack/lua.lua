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
          -- plugins = { "nvim-lspconfig" },
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
        },
      },
      setup = {
        lua_ls = function()
          require("plugins.lsp.utils").on_attach("lua_ls", function(_, buffer)
            vim.keymap.set("n", "<leader>lx", function()
              vim.cmd("noautocmd write")
              vim.cmd.luafile("%")
            end, { buffer = buffer, desc = "Save and execute" })
          end)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
          {
            "<leader>dx",
            function()
              require("osv").launch({ port = 8086 })
            end,
            desc = "Launch Lua adapter",
          },
        },
      },
    },
    opts = {
      configurations = {
        lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Run this file",
            start_neovim = true,
          },
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
            port = 8086,
          },
        },
      },
      adapters = {
        nlua = function(callback, config)
          local dap, osv = require("dap"), require("osv")
          local adapter = {
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or 8086,
          }
          if config.start_neovim then
            local dap_run = dap.run
            dap.run = function(c)
              adapter.port = c.port
              adapter.host = c.host
            end
            osv.run_this()
            dap.run = dap_run
          end
          callback(adapter)
        end,
      },
    },
  },
}
