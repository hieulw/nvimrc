local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end

require("lazy").setup('plugins', {
    install = { colorscheme = { "gruvbox" } },
    ui = {
        -- a number <1 is a percentage., >1 is a fixed size
        size = { width = 0.6, height = 0.7 },
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "rounded",
    },
    change_detection = {
        enabled = true,
        notify = false -- get a notification when changes are found
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", -- "matchit", -- "matchparen",
                "man",             -- "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin"
            }
        }
    }
})
