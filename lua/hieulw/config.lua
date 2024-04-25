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

--- Root patterns for auto detect and change root
---@type string[]
M.root_patterns = { ".git" }

return M
