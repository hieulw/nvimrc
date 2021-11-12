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

    -- basic support for buffer-scoped keybindings
    local buffer = opts.buffer
    opts.buffer = nil

    if buffer then
        vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
        vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
    end
end

return M
