return {
  { "nvim-neotest/nvim-nio", event = "LazyFile" },
  { "nvim-lua/plenary.nvim", event = "LazyFile" },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "thehamsta/nvim-dap-virtual-text",
      "liadoz/nvim-dap-repl-highlights",
    },
    keys = require("plugins.dap.keymaps").dap,
    opts = {
      configurations = {},
      adapters = {},
    },
    config = require("plugins.dap.config").setup,
  },
  {
    "nvim-neotest/neotest",
    keys = require("plugins.dap.keymaps").neotest,
    opts = {
      adapters = {},
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    config = function(_, opts)
      if not opts.adapters then
        return
      end

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, vim.api.nvim_create_namespace("neotest"))

      local adapters = {}
      for name, config in pairs(opts.adapters or {}) do
        if type(name) == "number" then
          if type(config) == "string" then
            config = require(config)
          end
          adapters[#adapters + 1] = config
        elseif config ~= false then
          local adapter = require(name)
          if type(config) == "table" and not vim.tbl_isempty(config) then
            local meta = getmetatable(adapter)
            if adapter.setup then
              adapter.setup(config)
            elseif meta and meta.__call then
              adapter(config)
            else
              error("Adapter " .. name .. " does not support setup")
            end
          end
          adapters[#adapters + 1] = adapter
        end
      end
      opts.adapters = adapters

      require("neotest").setup(opts)
    end,
  },
  {
    "stevearc/overseer.nvim",
    keys = require("plugins.dap.keymaps").overseer,
    opts = {
      dap = false,
      task_list = {
        direction = "right",
        max_width = { 80, 0.5 },
        bindings = {
          ["g?"] = "ShowHelp",
          ["<C-v>"] = "OpenVsplit",
          ["<C-x>"] = "OpenSplit",
          ["<C-q>"] = "OpenQuickFix",
          ["a"] = "RunAction",
          ["O"] = "OpenFloat",
          ["o"] = "Open",
          ["e"] = "Edit",
          ["q"] = "Close",
          ["p"] = "TogglePreview",
          ["L"] = "IncreaseDetail",
          ["H"] = "DecreaseDetail",
          ["K"] = "PrevTask",
          ["J"] = "NextTask",
          ["<C-u>"] = "ScrollOutputUp",
          ["<C-d>"] = "ScrollOutputDown",
        },
      },
      form = {
        win_opts = { winblend = 0 },
      },
      confirm = {
        win_opts = { winblend = 0 },
      },
      task_win = {
        win_opts = { winblend = 0 },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      local lualine = require("lualine")
      local icon = require("hieulw.icons")

      overseer.setup(opts)
      lualine.setup({
        sections = {
          lualine_x = vim.list_extend({
            {
              "overseer",
              symbols = {
                [overseer.STATUS.FAILURE] = icon.task.Failure,
                [overseer.STATUS.CANCELED] = icon.task.Canceled,
                [overseer.STATUS.SUCCESS] = icon.task.Success,
                [overseer.STATUS.RUNNING] = icon.task.Running,
              },
            },
          }, lualine.get_config().sections.lualine_x),
        },
      })
    end,
  },
  {
    "danymat/neogen",
    opts = { snippet_engine = "vsnip", languages = {} },
    cmd = "Neogen",
    keys = {
      { "cd", "<cmd>Neogen<cr>", mode = "n", desc = "Generate Annotation" },
    },
  },
}
