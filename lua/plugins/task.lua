return {
  "stevearc/overseer.nvim",
  keys = {
    { "<leader>tt", "<cmd>OverseerToggle<cr>", mode = "n", desc = "Toggle Tasks Result" },
    { "<leader>tr", "<cmd>OverseerRun<cr>", mode = "n", desc = "Run Tasks" },
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
  },
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
}
