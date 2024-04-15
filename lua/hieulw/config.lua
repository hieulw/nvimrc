local M = {}

-- Bundle every config we need for specific language
---@type table<string,boolean>
M.pack = {
  ai = true,
  cloud = true,
  common = true,
  csharp = false,
  go = true,
  lua = true,
  markdown = true,
  php = false,
  python = true,
  tailwind = false,
  typescript = false,
}

return M
