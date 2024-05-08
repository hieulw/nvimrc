local M = {}

M.dap = {
  {
    "<leader>dC",
    function()
      require("dap").continue({
        before = function(config)
          local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
          config = vim.deepcopy(config)
          ---@cast args string[]
          config.args = function()
            local new_args = vim.fn.input("Arguments: ", table.concat(args, " ")) --[[@as string]]
            return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
          end
          return config
        end,
      })
    end,
    desc = "Run with Args",
  },
  {
    "<leader>dc",
    function()
      require("dap").continue()
    end,
    desc = "Continue",
  },
  {
    "<leader>dB",
    function()
      vim.ui.input({ prompt = "Condition" }, function(value)
        require("dap").set_breakpoint(value)
      end)
    end,
    desc = "Breakpoint Condition",
  },
  {
    "<leader>db",
    function()
      require("dap").toggle_breakpoint()
    end,
    desc = "Toggle Breakpoint",
  },
  {
    "<leader>dh",
    function()
      require("dap").step_back()
    end,
    desc = "Step Back",
  },
  {
    "<leader>dj",
    function()
      require("dap").step_into()
    end,
    desc = "Step Into",
  },
  {
    "<leader>dk",
    function()
      require("dap").step_out()
    end,
    desc = "Step Out",
  },
  {
    "<leader>dl",
    function()
      require("dap").step_over()
    end,
    desc = "Step Over",
  },
  {
    "<leader>dr",
    function()
      require("dap").repl.toggle()
    end,
    desc = "Toggle REPL",
  },
  {
    "<leader>du",
    function()
      require("dapui").toggle({ reset = true })
    end,
    desc = "Toggle Dap UI",
  },
  {
    "<leader>dw",
    function()
      require("dap.ui.widgets").hover()
    end,
    desc = "Widgets",
    mode = { "n", "v" },
  },
  {
    "<leader>de",
    function()
      require("dapui").eval()
    end,
    desc = "Eval",
    mode = { "n", "v" },
  },
}

M.neotest = {
  {
    "<leader>tf",
    function()
      require("neotest").run.run(vim.fn.expand("%"))
    end,
    desc = "Test File",
  },
  {
    "<leader>ta",
    function()
      require("neotest").run.run(vim.uv.cwd())
    end,
    desc = "Test All",
  },
  {
    "<leader>ts",
    function()
      require("neotest").summary.toggle()
    end,
    desc = "Toggle Summary",
  },
  {
    "<leader>to",
    function()
      require("neotest").output.open({ enter = true, auto_close = true })
    end,
    desc = "Show Output",
  },
  {
    "<leader>tS",
    function()
      require("neotest").run.stop()
    end,
    desc = "Stop",
  },
  {
    "<leader>td",
    function()
      require("neotest").run.run({ strategy = "dap" })
    end,
    desc = "Test & Debug Nearest",
  },
  {
    "<leader>tc",
    function()
      if not vim.g.coverage_loaded then
        require("coverage").load(true)
        vim.g.coverage_loaded = true
      else
        require("coverage").toggle()
      end
    end,
    desc = "Test Coverage",
  },
  {
    "<leader>tC",
    function()
      require("coverage").summary()
    end,
    desc = "Test Coverage Summary",
  },
}

M.overseer = {
  { "<leader>tt", "<cmd>OverseerToggle<cr>", mode = "n", desc = "Toggle Task Results" },
  { "<leader>tr", "<cmd>OverseerRun<cr>", mode = "n", desc = "Show Task Commands" },
  {
    "<leader>tl",
    function()
      local overseer = require("overseer")
      local tasks = overseer.list_tasks({ recent_first = true })
      if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], "restart")
      end
    end,
    mode = "n",
    desc = "Run Last Task",
  },
}

return M
