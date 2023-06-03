return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    main = 'nvim-treesitter.configs',
    build = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))
    end,
    event = "User File",
    opts = {
      ensure_installed = { 'lua' },
      indent = { enable = false },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    }
  }
}
