local M = {}

function M.setup(_, opts)
  local icons = require("hieulw.icons")
  local dap = require("dap")
  local dapui = require("dapui")
  local dapvt = require("nvim-dap-virtual-text")
  local daprh = require("nvim-dap-repl-highlights")
  local lualine = require("lualine")

  for name, sign in pairs(icons.dap) do
    sign = type(sign) == "table" and sign or { sign }
    vim.fn.sign_define(
      "Dap" .. name,
      { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
    )
  end

  -- setup UI
  daprh.setup()
  dapvt.setup({ virt_text_pos = "inline" })
  dapui.setup({
    controls = { element = "breakpoints" },
    expand_lines = false,
    layouts = {
      {
        elements = {
          { id = "stacks", size = 0.20 },
          { id = "scopes", size = 0.40 },
          { id = "watches", size = 0.30 },
          { id = "breakpoints", size = 0.10 },
        },
        position = "right",
        size = 40,
      },
    },
  })
  lualine.setup({
    sections = {
      lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, {
        function()
          if dap.status() ~= "" then
            return icons.ui.Bug .. " " .. dap.status()
          end
          return dap.status()
        end,
      }),
    },
  })

  -- setup hooks
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  -- setup adapters
  for _config, _opts in pairs(opts.configurations) do
    dap.configurations[_config] = _opts
  end
  for _adapters, _opts in pairs(opts.adapters) do
    dap.adapters[_adapters] = _opts
  end
end
return M
