local M = {}

function M.setup()
  local UIInput = require("nui.input"):extend("UIInput")
  local event = require("nui.utils.autocmd").event
  local input = nil

  local function get_prompt(prompt, default_prompt)
    prompt = vim.trim(prompt or default_prompt)
    if prompt:sub(-1) == ":" then
      prompt = prompt:sub(1, -2)
    end
    return prompt
  end

  function UIInput:init(opts, on_done)
    local top_text = get_prompt(opts.prompt, "Input")
    local default_value = tostring(opts.default or "")

    UIInput.super.init(self, {
      relative = "cursor",
      position = { row = 0, col = 0 },
      size = { width = math.max(20, vim.api.nvim_strwidth(default_value)) },
      border = { style = "rounded", text = { top = top_text, top_align = "center" } },
      win_options = { winhighlight = "NormalFloat:Normal,FloatBorder:Normal" },
    }, {
      default_value = default_value,
      on_close = function()
        on_done(nil)
      end,
      on_submit = function(value)
        on_done(value)
      end,
    })

    self:on(event.BufLeave, function()
      if input then
        input:unmount()
      end
      input = nil
    end, { once = true })
    self:map("n", "<Esc>", "<cmd>close<cr>", { noremap = true, nowait = true })
  end

  ---@param opts table?
  ---     - prompt (string|nil)
  ---               Text of the prompt
  ---     - default (string|nil)
  ---               Default reply to the input
  ---@param on_confirm function ((input|nil) -> ())
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(opts, on_confirm)
    vim.validate({
      opts = { opts, "table", true },
      on_confirm = { on_confirm, "function", false },
    })
    opts = (opts and not vim.tbl_isempty(opts)) and opts or vim.empty_dict()
    opts = vim.tbl_extend("keep", opts, { cancelreturn = vim.NIL })

    if input then
      vim.api.nvim_err_writeln("busy: another input is pending!")
      return
    end

    input = UIInput(opts, on_confirm)
    input:mount()
  end
end

return M
