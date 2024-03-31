return {
  {
    "<leader>dC",
    function()
      require("dap").continue({
        before = function(config)
          local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
          config = vim.deepcopy(config)
          ---@cast args string[]
          config.args = function()
            local new_args = vim.fn.input("[Arguments]> ", table.concat(args, " ")) --[[@as string]]
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
      require("dap").set_breakpoint(vim.fn.input("[Condition]> "))
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
    desc = "Step Into",
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
