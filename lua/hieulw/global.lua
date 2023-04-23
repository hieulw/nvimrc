-- inspired by TeeJ 
-- https://www.youtube.com/watch?v=n4Lp4cV8YR0
function P(value)
    vim.print(vim.inspect(value))
    -- return value
end

function RELOAD(...) return require('plenary.reload').reload_module(...) end

function R(name)
    RELOAD(name)
    return require(name)
end
