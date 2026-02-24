return (function()
  local plugins = {}
  local packs = require("hieulw.config").pack
  local zpack_dir = vim.fn.stdpath("config") .. "/lua/plugins/zpack"
  for name, t in vim.fs.dir(zpack_dir) do
    if t == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
      local k = name:sub(1, -5)
      if packs[k] == true then
        local ok, pack_or_err = pcall(require, "plugins.zpack." .. k)
        if ok then
          vim.list_extend(plugins, pack_or_err)
        else
          vim.schedule(function()
            vim.notify(
              ("Failed loading pack '%s': %s"):format(k, pack_or_err),
              vim.log.levels.ERROR,
              { title = "zpack" }
            )
          end)
        end
      end
    end
  end
  return plugins
end)()
