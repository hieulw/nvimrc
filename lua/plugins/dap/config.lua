local M = {}

function M.setup(_, opts)
  local icons = require("hieulw.icons")
  local dap = require("dap")
  local dapview = require("dap-view")
  local dapvt = require("nvim-dap-virtual-text")
  local daprh = require("nvim-dap-repl-highlights")
  local lualine = require("lualine")

  for name, sign in pairs(icons.dap) do
    sign = type(sign) == "table" and sign or { sign }
    vim.fn.sign_define("Dap" .. name, {
      text = sign[1],
      texthl = sign[2] or "DiagnosticInfo",
      linehl = sign[3],
      numhl = sign[3],
    })
  end

  -- integrate with overseer
  require("overseer").enable_dap()
  require("dap.ext.vscode").json_decode = require("overseer.json").decode

  -- setup UI
  daprh.setup()
  dapvt.setup({ virt_text_pos = "inline" })
  dapview.setup({
    auto_toggle = true,
    windows = {
      position = "right",
      size = 0.25,
    },
  })
  lualine.setup({
    sections = {
      lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, {
        function()
          if dap.status() ~= "" then
            return ("%s %s"):format(icons.ui.Bug, string.lower(dap.status()))
          end
          return dap.status()
        end,
      }),
    },
  })

  -- setup adapters
  for _config, _opts in pairs(opts.configurations) do
    dap.configurations[_config] = _opts
  end
  for _adapters, _opts in pairs(opts.adapters) do
    dap.adapters[_adapters] = _opts
  end
end

return M
