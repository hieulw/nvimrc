local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.pack" },
  },
  install = { colorscheme = { "gruvbox" } },
  ui = {
    -- a number <1 is a percentage., >1 is a fixed size
    size = { width = 0.6, height = 0.7 },
    border = "rounded",
  },
  change_detection = { enabled = false },
  performance = {
    cache = { false },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        --"man",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
