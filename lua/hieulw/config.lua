local M = {}

--- Bundle every configs|plugins we need for specific language
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
  tailwind = true,
  typescript = true,
}

return M
