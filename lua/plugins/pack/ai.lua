return {
  {
    "exafunction/codeium.vim",
    event = "InsertEnter",
    init = function()
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_manual = true
      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        ["dap-repl"] = false,
      }
    end,
    config = function()
      local has_cmp, cmp = pcall(require, "cmp")
      vim.keymap.set("i", "<C-]>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-]>", function()
        if has_cmp then
          cmp.abort()
        end
        return vim.fn["codeium#CycleOrComplete"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<M-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
    end,
  },
}
