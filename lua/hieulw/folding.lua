local M = {}

local function bufwidth()
    local width = vim.fn.winwidth(0)
    local numwidth = 0
    local wo = vim.wo
    if wo.number or wo.relativenumber then numwidth = wo.numberwidth end
    local foldwidth = wo.foldcolumn
    local sc = wo.signcolumn
    local signwidth = 0
    if sc == 'yes' then
        signwidth = 2
    elseif sc == 'auto' then
        local signs = vim.fn.execute(string.format("sign place buffer=%d",
                                                   vim.fn.bufnr("")))
        signs = vim.fn.split(signs, "\n")

        if #signs > 2 then
            signwidth = 2
        else
            signwidth = 0
        end
    end
    return width - numwidth - foldwidth - signwidth
end

function M.foldtext()
    local fs = vim.api.nvim_get_vvar("foldstart")
    local fe = vim.api.nvim_get_vvar("foldend")
    local start_line = vim.fn.substitute(vim.fn.getline(fs), "\t",
                                         string.rep(' ', vim.bo.tabstop), 'g')
    local end_line = vim.fn.substitute(vim.fn.getline(fe), ' ', '', 'g')
    local winSize = bufwidth()
    local fillcharcount = winSize - #start_line - #end_line - 3
    return start_line .. '  ' .. end_line .. string.rep(" ", fillcharcount)
end

return M
