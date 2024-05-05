local M = {}

function M.setup(_, opts)
  ---@see https://github.com/nvim-treesitter/nvim-treesitter/issues/3581
  -- commenting out the comment queries in injections.scm seem to fix performance issues
  require("nvim-treesitter.configs").setup(opts)
  require("ts_context_commentstring").setup({ enable_autocmd = false })
  require("plugins.treesitter.keymaps").setup()
end

return M
