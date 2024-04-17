--- Print Lua objects in command line
---@see https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/misc.lua#L106
---@param ... any Any number of objects to be printed each on separate line.
function P(...)
  local objects = {}
  -- Not using `{...}` because it removes `nil` input
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  vim.print(table.concat(objects, "\n"))
end

--- Re-import the package
---@param modname string the module name to reload
function R(modname)
  require("plenary.reload").reload_module(modname)
  return require(modname)
end
