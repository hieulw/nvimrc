return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "williamboman/mason.nvim",
      "antosha417/nvim-lsp-file-operations",
    },
    opts = {},
    config = require("plugins.lsp.config").setup,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {},
      ui = { border = "rounded", width = 0.6, height = 0.7 },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    opts = { sources = {} },
  },
  {
    "linrongbin16/lsp-progress.nvim",
    event = "LspAttach",
    opts = function()
      local icons = require("hieulw.icons")
      return {
        spinner = icons.spinner,
        client_format = function(client_name, spinner, series_messages)
          if #series_messages > 0 then
            return ("%s %s %s"):format(client_name, spinner, table.concat(series_messages, ", "))
          end
          return nil
        end,
        format = function(messages)
          if #messages > 0 then
            return ("%s %s"):format(icons.ui.LSP, table.concat(messages, " "))
          end

          local clients = vim.lsp.get_clients()
          local client_names = {}

          for _, client in ipairs(clients) do
            if client.name == "yamlls" then
              local schema = require("yaml-companion").get_buf_schema(0)
              if schema.result[1].name == "none" then
                table.insert(client_names, client.name)
              else
                table.insert(client_names, ("%s(%s)"):format(client.name, schema.result[1].name))
              end
            elseif client.name == "null-ls" then
            else
              table.insert(client_names, client.name)
            end
          end
          return ("%s %s"):format(icons.kind.Event, table.concat(client_names, " "))
        end,
      }
    end,
    config = function(_, opts)
      local lualine = require("lualine")
      local lsp_progress = require("lsp-progress")
      lsp_progress.setup(opts)
      lualine.setup({
        sections = {
          lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, { lsp_progress.progress }),
        },
      })
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = lualine.refresh,
      })
    end,
  },
}
