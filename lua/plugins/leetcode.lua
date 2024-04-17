local leet_arg = "leetcode"
return {
  "kawre/leetcode.nvim",
  lazy = leet_arg ~= vim.fn.argv()[1],
  build = ":TSUpdate html",
  opts = {
    arg = leet_arg,
    lang = "golang",
    plugins = {
      non_standalone = false,
    },
    injector = {
      golang = {
        before = { "package main" },
      },
    },
    keys = {
      toggle = { "q" },
      confirm = { "<CR>" },
      reset_testcases = "r",
      use_testcase = "U",
      focus_testcases = "H",
      focus_result = "L",
    },
    theme = {},
    ---@see https://github.com/3rd/image.nvim/issues/62
    image_support = false,
  },
  config = function(_, opts)
    require("leetcode").setup(opts)
    vim.keymap.set("n", "<leader>pc", "<cmd>Leet console<cr>", { desc = "Show Leetcode Console" })
    vim.keymap.set("n", "<leader>pr", "<cmd>Leet run<cr>", { desc = "Run Leetcode Test" })
    vim.keymap.set("n", "<leader>ps", "<cmd>Leet submit<cr>", { desc = "Submit Leetcode Solution" })
  end,
}
