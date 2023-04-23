return {
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gcc', mode = 'n',               desc = 'Go line comment' },
      { 'gbc', mode = 'n',               desc = 'Go block comment' },
      { 'gc',  mode = { 'n', 'v', 'o' }, desc = 'Go comment with motion' },
      { 'gb',  mode = { 'n', 'v', 'o' }, desc = 'Go comment with motion' }
    },
    config = function()
      require('Comment').setup({
        pre_hook = require(
          'ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
      })
    end
  }, {
  'windwp/nvim-autopairs',
  config = function()
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    require('nvim-autopairs').setup()
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end
},
  {
    'kylechui/nvim-surround', event = 'VeryLazy', opts = {}
  },
  {
    'Wansmer/treesj',
    keys = { { 'J', mode = 'n', desc = 'Toggle split join' } },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ use_default_keymaps = false })
      vim.keymap.set('n', 'J', require('treesj').toggle)
    end
  },
  {
    'Wansmer/sibling-swap.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('sibling-swap').setup({
        keymaps = {
          ['g.'] = 'swap_with_right',
          ['g,'] = 'swap_with_left',
          ['g>'] = 'swap_with_right_with_opp',
          ['g<'] = 'swap_with_left_with_opp',
        }
      })
    end,
  },
  { 'drybalka/tree-climber.nvim', keys = {} },
  { 'ethanholz/nvim-lastplace', opts = {} },
  'christoomey/vim-tmux-navigator',
}
