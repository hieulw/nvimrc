return {
  "joryeugene/dadbod-grip.nvim",
  version = "*",
  pkg = false,
  dependencies = {
    "tpope/vim-dadbod",
  },
  keys = {
    { "<leader>sd", "<cmd>GripConnect<cr>", desc = "Database Connect" },
    { "<leader>st", "<cmd>GripTables<cr>", desc = "Database Tables" },
    { "<leader>sq", "<cmd>GripQuery<cr>", desc = "Database Query" },
    { "<leader>ss", "<cmd>GripSchema<cr>", desc = "Database Schema" },
  },
  cmd = {
    "Grip",
    "GripConnect",
    "GripSchema",
    "GripTables",
    "GripQuery",
    "GripHistory",
    "GripToggle",
  },
  opts = {
    completion = false,
  },
}
