local M = {}

-- key mapping function
function M.map(key)
  -- get the extra options
  local opts = { noremap = true }
  for i, v in pairs(key) do
    if type(i) == "string" then
      opts[i] = v
    end
    if type(v) == "table" then
      for ti, tv in pairs(v) do
        opts[ti] = tv
      end
    end
  end

  vim.keymap.set(key[1], key[2], key[3], opts)
end

function M.feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

--- Trigger an AstroNvim user event
---@param event string The event name to be appended to Astro
function M.event(event)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = event })
  end)
end

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd string The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command as an error to the user
---@return string|nil # The result of a successfully executed command or nil
function M.cmd(cmd, show_error)
  local wind32_cmd
  if vim.fn.has("win32") == 1 then
    wind32_cmd = { "cmd.exe", "/C", cmd }
  end
  local result = vim.fn.system(wind32_cmd or cmd)
  local success = vim.api.nvim_get_vvar("shell_error") == 0
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_err_writeln("Error running command: " .. cmd .. "\nError message:\n" .. result)
  end
  return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

M.icon = {
  diagnostics = {
    Error = "",
    Warn = "",
    Hint = "󰌵",
    Info = "",
  },
  git = {
    Added = "",
    Changed = "",
    Deleted = "",
    Octoface = "",
  },
  kind = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
  },
  prompt = {
    Search = "",
    Selected = "❯",
  },
}

return M
