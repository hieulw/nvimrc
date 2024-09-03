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
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, { name = "lazydev", group_index = 0 })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "bilal2453/luvit-meta", lazy = true },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            "~/.config/wezterm",
          },
        },
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
            ---@diagnostic disable-next-line: duplicate-set-field
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
