return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",
      "rcarriga/cmp-dap",
    },
    enabled = false,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function()
      local cmp = require("cmp")
      local kind_icons = require("hieulw.icons").kind
      local feedkey = require("hieulw.helper").feedkey
      local border_opts = {
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        scrolloff = 2,
      }
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      return {
        enabled = function()
          return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          format = function(entry, item)
            local ok, twtools = pcall(require, "tailwind-tools.cmp")
            if ok then
              twtools.lspkind_format(entry, item)
            end
            item.kind = string.format("%s %s", kind_icons[item.kind], item.kind)
            item.abbr = item.abbr:match("[^(]+") -- fn(...args) -> fn
            return item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(border_opts),
          documentation = cmp.config.window.bordered(border_opts),
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end,
            c = function()
              if cmp.visible() then
                cmp.select_prev_item()
              else
                cmp.complete()
              end
            end,
          }),
          ["<C-n>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end,
            c = function()
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
            end,
          }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_selected_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
              end
            elseif vim.fn["vsnip#jumpable"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
              fallback()
            end
          end, { "i", "s", "c" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "nvim_lsp_signature_help" },
          { name = "vsnip", priority = 750 },
        }, {
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.kind,
            cmp.config.compare.recently_used,
            cmp.config.compare.scopes,
          },
        },
        view = { entries = { name = "custom", selection_order = "near_cursor" } },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      local cmp_config = require("cmp.config")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local autopairs = require("nvim-autopairs")

      vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
      autopairs.setup({ fast_wrap = {} })
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup(opts)
      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        mapping = cmp_config.get().mapping,
        sources = cmp.config.sources({ name = "dap" }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp_config.get().mapping,
        sources = cmp.config.sources({ { name = "nvim_lsp_document_symbol" } }, { { name = "buffer" } }),
      })
      cmp.setup.cmdline(":", {
        mapping = cmp_config.get().mapping,
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
        sorting = { comparators = { cmp.config.compare.recently_used } },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      { "saghen/blink.compat", lazy = true },
      "rafamadriz/friendly-snippets",
      "rcarriga/cmp-dap",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      enabled = function()
        return (vim.bo.buftype ~= "prompt" and vim.b.completion ~= false) or vim.bo.filetype == "dap-repl"
      end,
      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-j>"] = { "accept", "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          draw = {
            components = {
              label = {
                text = function(ctx)
                  return ctx.label:match("[^(]+") .. ctx.label_detail
                end,
              },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          lua = { "lazydev", "lsp", "path", "buffer" },
          ["dap-repl"] = { "dap" },
        },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
          dap = { name = "dap", module = "blink.compat.source" },
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-scissors",
    keys = function()
      local scissors = require("scissors")
      return {
        { "<leader>se", scissors.editSnippet, mode = "n", desc = "Edit Snippet" },
        { "<leader>sa", scissors.addNewSnippet, mode = { "n", "x" }, desc = "Add Snippet" },
      }
    end,
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
      editSnippetPopup = {
        height = 0.4, -- relative to the window, number between 0 and 1
        width = 0.6,
        border = "rounded",
        keymaps = {
          cancel = "q",
          saveChanges = "<CR>", -- alternatively, can also use `:w`
          goBackToSearch = "<BS>",
          deleteSnippet = "<C-x>",
          duplicateSnippet = "<C-d>",
          openInFile = "<C-o>",
          insertNextPlaceholder = "<C-t>", -- insert & normal mode
        },
      },
      telescope = {
        alsoSearchSnippetBody = false,
      },
      jsonFormatter = "jq", -- "yq"|"jq"|"none"
    },
  },
}
