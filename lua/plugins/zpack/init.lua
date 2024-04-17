return (function()
  local plugins = {}
  local packs = require("hieulw.config").pack
  for k, v in pairs(packs) do
    if v == true then
      local ok, pack = pcall(require, "plugins.zpack." .. k)
      if ok then
        vim.list_extend(plugins, pack)
      end
    end
  end
  return plugins
end)()
