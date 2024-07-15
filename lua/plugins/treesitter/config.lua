local M = {}

function M.setup(_, opts)
  ---@see https://github.com/nvim-treesitter/nvim-treesitter/issues/3581
  -- commenting out the comment queries in injections.scm seem to fix performance issues
  require("plugins.treesitter.keymaps").setup()
  require("plugins.treesitter.parser").setup()
  require("nvim-treesitter.configs").setup(opts)
  require("ts-comments").setup()
end

return M
