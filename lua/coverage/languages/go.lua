local M = {}

local Path = require("plenary.path")
local common = require("coverage.languages.common")
local config = require("coverage.config")
local util = require("coverage.util")
local overlays = require("coverage.overlays")

--- Returns a list of signs to be placed.
M.sign_list = common.sign_list

--- Returns a list of signs to be placed.
--- @param json_data CoverageData data from the generated report
--- @returns OverlayMark[]
M.overlay_list = function(json_data)
  --- @type OverlayMark[]
  local overlay_list = {}
  for fname, cov in pairs(json_data.files) do
    local buffer = vim.fn.bufnr(fname, false)
    if buffer ~= -1 then
      for _, range in ipairs(cov.covered_ranges) do
        local spos, epos = unpack(range)
        table.insert(overlay_list, overlays.new_covered(buffer, spos, epos))
      end

      for _, range in ipairs(cov.uncovered_ranges) do
        local spos, epos = unpack(range)
        table.insert(overlay_list, overlays.new_uncovered(buffer, spos, epos))
      end
    end
  end
  return overlay_list
end

--- Returns a summary report.
M.summary = common.summary

-- the fields are: name.go:line.column,line.column numberOfStatements count
-- see https://github.com/golang/go/blob/0104a31b8fbcbe52728a08867b26415d282c35d2/src/cmd/cover/profile.go#L115
-- and https://github.com/golang/go/blob/master/src/testing/cover.go#L102
local line_re = "^(.+):(%d+)%.(%d+),(%d+)%.(%d+) %d+ (%d+)$"

-- for parsing the module name from go.mod
local mod_name_re = "^module (.*)$"

local get_module_name = function()
  local p = Path:new("."):find_upwards("go.mod")
  if p == "" then
    return ""
  end
  local lines = p:readlines()
  for _, line in ipairs(lines) do
    if line:match(mod_name_re) then
      local name = line:match(mod_name_re)
      name = name:gsub("%-", "%%-")
      name = name:gsub("%.", "%%.")
      name = name:gsub("%+", "%%+")
      name = name:gsub("%?", "%%?")
      return name
    end
  end
  return ""
end

--- @class FileCoverage
--- @field covered_ranges table[][] line, col ranges covered under test
--- @field uncovered_ranges table[][] line, col ranges excluded under test

--- Returns a table containing file parameters.
--- @return FileCoverage
local function get_file_meta()
  return {
    summary = {
      covered_lines = 0,
      excluded_lines = 0,
      missing_lines = 0,
      num_statements = 0,
      percent_covered = 0,
    },
    missing_lines = {},
    missing_branches = {},
    executed_lines = {},
    excluded_lines = {},
    covered_ranges = {},
    uncovered_ranges = {},
  }
end

--- Parses a coverprofile formatted file
--- @param path Path
--- @param files table<string, FileCoverage>
local parse_coverprofile = function(path, files)
  local lines_by_filename, ranges_by_filename = {}, {}
  local lines = path:readlines()
  local mod_name = get_module_name()
  for _, line in ipairs(lines) do
    if line:match(line_re) then
      -- example/main.go:3.14,5.2 0 0
      local fname, line_start, col_start, line_end, col_end, count = line:match(line_re)
      fname = fname:gsub(mod_name .. "/", "", 1)
      line_start = tonumber(line_start)
      col_start = tonumber(col_start)
      line_end = tonumber(line_end)
      col_end = tonumber(col_end)
      count = tonumber(count)
      if lines_by_filename[fname] == nil then
        lines_by_filename[fname] = {}
      end
      for linenr = line_start, line_end do
        lines_by_filename[fname][linenr] = (lines_by_filename[fname][linenr] or 0) + count
      end
      if ranges_by_filename[fname] == nil then
        ranges_by_filename[fname] = {}
      end
      ranges_by_filename[fname][{ { line_start, col_start }, { line_end, col_end } }] = count
    end
  end

  for fname, linenrs in pairs(lines_by_filename) do
    local file = get_file_meta()
    for linenr, count in pairs(linenrs) do
      if count == 0 then
        table.insert(file.missing_lines, linenr)
      else
        table.insert(file.executed_lines, linenr)
        file.summary.covered_lines = file.summary.covered_lines + 1
      end
      file.summary.num_statements = file.summary.num_statements + 1
    end
    file.summary.percent_covered = file.summary.covered_lines / file.summary.num_statements * 100
    for range, count in pairs(ranges_by_filename[fname]) do
      if count == 0 then
        table.insert(file.uncovered_ranges, range)
      else
        table.insert(file.covered_ranges, range)
      end
    end
    files[fname] = file
  end
end

--- Loads a coverage report.
--- @param callback function called with the results of the coverage report
M.load = function(callback)
  local go_config = config.opts.lang.go
  local p = Path:new(util.get_coverage_file(go_config.coverage_file))
  if not p:exists() then
    vim.notify("No coverage file exists.", vim.log.levels.INFO)
    return
  end

  callback(util.report_to_table(p, parse_coverprofile))
end

return M
