local M = {}

function M.setup(_, opts)
  ---@see https://github.com/nvim-treesitter/nvim-treesitter/issues/3581
  -- commenting out the comment queries in injections.scm seem to fix performance issues
  require("plugins.treesitter.keymaps").setup()
  require("plugins.treesitter.parser").setup()
  require("plugins.treesitter.compat").setup()
  require("nvim-treesitter").setup({ install_dir = opts.install_dir })
  local parsers = vim.list.unique(opts.parsers or {})
  if #parsers > 0 then
    local installed = require("nvim-treesitter").get_installed()
    local missing = vim.tbl_filter(function(lang)
      return not vim.list_contains(installed, lang)
    end, parsers)
    if #missing > 0 then
      require("nvim-treesitter").install(missing)
    end
  end
  require("ts-comments").setup()
end

return M
