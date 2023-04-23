local M = {}

-- key mapping function
function M.map(key)
    -- get the extra options
    local opts = {noremap = true}
    for i, v in pairs(key) do
        if type(i) == 'string' then opts[i] = v end
        if type(v) == 'table' then
            for ti, tv in pairs(v) do opts[ti] = tv end
        end
    end

    vim.keymap.set(key[1], key[2], key[3], opts)
end

M.icon = {
  diagnostics = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
  },
  git = {
    added = "",
    changed = "",
    deleted = "",
  },
}

return M
