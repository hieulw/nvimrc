local M = {}

function M.load(place)
  local ftype = vim.bo.filetype
  local config = require("coverage.config")
  local report = require("coverage.report")
  local overlays = require("coverage.overlays")
  local watch = require("coverage.watch")
  local util = require("coverage.util")

  local ok, lang = pcall(require, "coverage.languages." .. ftype)
  if not ok then
    vim.notify("Coverage report not available for filetype " .. ftype)
    return
  end

  local load_lang = function()
    lang.load(function(result)
      if config.opts.load_coverage_cb ~= nil then
        vim.schedule(function()
          config.opts.load_coverage_cb(ftype)
        end)
      end
      report.cache(result, ftype)
      local overlay_list = lang.overlay_list(result)
      if place or overlays.is_enabled() then
        overlays.place(overlay_list)
      else
        overlays.cache(overlay_list)
      end
    end)
  end

  local lang_config = config.opts.lang[ftype]
  if lang_config == nil then
    lang_config = config.opts.lang[lang.config_alias]
  end

  -- Automatically watch the coverage file for updates when auto_reload is enabled
  -- and when the language setup allows it
  if
    config.opts.auto_reload
    and lang_config ~= nil
    and lang_config.coverage_file ~= nil
    and not lang_config.disable_auto_reload
  then
    local coverage_file = util.get_coverage_file(lang_config.coverage_file)
    watch.start(coverage_file, load_lang)
  end

  overlays.clear()
  load_lang()
end

function M.setup(_, opts)
  local coverage = require("coverage")
  local overlays = require("coverage.overlays")
  local watch = require("coverage.watch")

  coverage.load = M.load
  coverage.show = overlays.show
  coverage.hide = overlays.unplace
  coverage.toggle = overlays.toggle
  ---@diagnostic disable-next-line: duplicate-set-field
  coverage.clear = function()
    overlays.clear()
    watch.stop()
  end
  coverage.setup(opts)
end

return M
