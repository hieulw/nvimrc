local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "gruvbox" } },
  pkg = {
    sources = {
      "rockspec",
      "packspec",
    },
  },
  ui = {
    size = { width = 0.6, height = 0.7 },
    border = "rounded",
  },
  change_detection = { enabled = false },
  performance = {
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
