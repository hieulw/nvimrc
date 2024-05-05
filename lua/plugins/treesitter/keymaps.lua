local M = {}

local utils = require("plugins.treesitter.utils")

local function map(lhs, rhs, mode, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

function M.setup()
  map("<M-n>", utils.goto_next, { "n", "v" }, "Go to next node")
  map("<M-p>", utils.goto_prev, { "n", "v" }, "Go to previous node")
  map("<M-i>", utils.goto_child, { "n", "v" }, "Go to child node")
  map("<M-o>", utils.goto_parent, { "n", "v" }, "Go to parent node")
  map("<M-S-n>", utils.swap_next, { "n" }, "Swap next node")
  map("<M-S-p>", utils.swap_prev, { "n" }, "Swap previous node")
  map("in", utils.select_node, { "v", "o" }, "Select inside node")
end

return M
