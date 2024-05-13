local M = {}

local ns = "coverage_"
local enabled = false
local cached_overlays = nil
local default_priority = 10

--- @class OverlayMark
--- @field buffer integer
--- @field id? integer
--- @field lnum integer
--- @field name integer
--- @field priority integer
--- @field highlight string

--- Returns a namespaced overlays name.
--- @param name string
--- @return integer
M.name = function(name)
  return vim.api.nvim_create_namespace(ns .. name)
end

--- Caches overlays but does not place them.
--- @param overlays OverlayMark[]
M.cache = function(overlays)
  M.unplace()
  cached_overlays = overlays
end

--- Places a list of overlays.
--- Any previously placed overlays are removed.
--- @param overlays OverlayMark[]
M.place = function(overlays)
  if cached_overlays ~= nil then
    M.unplace()
  end
  for _, overlay in ipairs(overlays) do
    local ok, extmark_id = pcall(
      vim.api.nvim_buf_set_extmark,
      overlay.buffer,
      overlay.name,
      overlay.lnum - 1, -- minus one because of zero-indexed
      0,
      {
        end_row = overlay.lnum,
        priority = overlay.priority,
        hl_group = overlay.highlight,
        hl_eol = false,
      }
    )
    if ok then
      overlay.id = extmark_id
    else
      cached_overlays = overlays
      M.unplace()
      vim.notify("The coverage file is outdated, please re-run test!", vim.log.levels.WARN)
      return
    end
  end
  enabled = true
  cached_overlays = overlays
end

--- Unplaces all coverage overlays.
M.unplace = function()
  if cached_overlays ~= nil then
    for _, overlay in ipairs(cached_overlays) do
      if overlay.id ~= nil then
        vim.api.nvim_buf_del_extmark(overlay.buffer, overlay.name, overlay.id)
      end
    end
  end
  enabled = false
end

--- Returns true if coverage overlays are currently shown.
M.is_enabled = function()
  return enabled
end

--- Displays cached overlays.
M.show = function()
  if enabled or cached_overlays == nil then
    return
  end
  M.place(cached_overlays)
end

--- Toggles the visibility of coverage overlays.
M.toggle = function()
  if enabled then
    M.unplace()
  elseif cached_overlays ~= nil then
    M.place(cached_overlays)
  end
end

--- Turns off coverage overlays and removes cached results.
M.clear = function()
  M.unplace()
  cached_overlays = nil
end

--- Returns a new covered sign in the format used by nvim_buf_set_extmark.
--- @param buffer string|integer buffer name or id
--- @param lnum integer
--- @return OverlayMark
M.new_covered = function(buffer, lnum)
  return {
    buffer = buffer,
    lnum = lnum,
    name = M.name("covered"),
    priority = default_priority,
    highlight = "DiffAdd",
  }
end

--- Returns a new uncovered sign in the format used by nvim_buf_set_extmark.
--- @param buffer string|integer buffer name or id
--- @param lnum integer
--- @return OverlayMark
M.new_uncovered = function(buffer, lnum)
  return {
    buffer = buffer,
    lnum = lnum,
    name = M.name("uncovered"),
    priority = default_priority,
    highlight = "DiffDelete",
  }
end

--- Returns a new partial coverage sign in the format used by nvim_buf_set_extmark.
--- @param buffer string|integer buffer name or id
--- @param lnum integer
--- @return OverlayMark
M.new_partial = function(buffer, lnum)
  local priority = default_priority + 1
  return {
    buffer = buffer,
    lnum = lnum,
    name = M.name("partial"),
    priority = priority,
    highlight = "DiffChange",
  }
end

return M
