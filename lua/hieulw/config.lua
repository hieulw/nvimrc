local M = {}

--- Bundle every configs|plugins we need for specific language
---@type table<string,boolean>
M.pack = {
  bash = true,
  cloud = true,
  common = true,
  copilot = false,
  csharp = true,
  go = true,
  lua = true,
  markdown = true,
  php = true,
  proto = true,
  python = true,
  sql = false,
  tailwind = true,
  typescript = true,
}

--- Root patterns for auto detect and change root
---@type string[]
M.root_patterns = { ".git" }

return M
