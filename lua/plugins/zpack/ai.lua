return {
  {
    "supermaven-inc/supermaven-nvim",
    opts = {
      keymaps = {
        accept_suggestion = "<C-j>",
        clear_suggestion = "<C-e>",
        accept_word = "<C-y>",
      },
      condition = function()
        local path = vim.fn.expand("%:p")
        return path:match(".*/gopass.*$") ~= nil or path:match(".*/.ssh/.*$") ~= nil
      end,
    },
    config = function(_, opts)
      local supermaven = require("supermaven-nvim")
      local lualine = require("lualine")
      supermaven.setup(opts)

      lualine.setup({
        sections = {
          lualine_c = vim.list_extend(lualine.get_config().sections.lualine_c, {
            function()
              return require("supermaven-nvim.api").is_running() and "󱜙 " or "󱚧 "
            end,
          }),
        },
      })
    end,
  },
  "olimorris/codecompanion.nvim",
}
