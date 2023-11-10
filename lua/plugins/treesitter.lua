---@diagnostic disable: missing-fields
return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    event = "User File",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        indent = { enable = false },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
      vim.treesitter.language.register("bash", { "tmux", "zsh", "sh" })
    end,
  },
}
