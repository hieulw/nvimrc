return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "thehamsta/nvim-dap-virtual-text",
      "liadoz/nvim-dap-repl-highlights",
    },
    keys = require("plugins.dap.keymaps"),
    opts = {
      configurations = {},
      adapters = {},
    },
    config = require("plugins.dap.config").setup,
  },
}
