vim.keymap.set({ "n", "v" }, vim.g.mapleader, "<Nop>", { silent = true })

-- Switch between vertical and horizontal
vim.keymap.set("n", "<leader>sh", "<C-w>t<C-w>K")
vim.keymap.set("n", "<leader>sv", "<C-w>t<C-w>H")

-- Better scroll
vim.keymap.set("n", "<C-y>", "5<C-y>")
vim.keymap.set("n", "<C-e>", "5<C-e>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<leader><bs>", "<cmd>nohlsearch<cr>")

-- Fugitive Conflict Resolution
vim.keymap.set("n", "<leader>gd", ":Gvdiff!<CR>")
vim.keymap.set("n", "<leader>gdh", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>gdl", ":diffget //3<CR>")

-- Apply @record to multiple lines
-- https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
vim.keymap.set("x", "@", function()
  local register = vim.fn.nr2char(vim.fn.getchar())
  vim.print("@" .. vim.fn.getcmdline())
  return ":'<,'>normal @" .. register .. "<cr>"
end, { silent = true, expr = true }) -- expr = true will execute return value of function

-- Better Yank & Paste
-- https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
-- xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>
-- use P instead of p because it doesn't override register
vim.keymap.set("n", "Y", "y$")

-- Open a URL under the cursor with the current operating system (without netrw)
vim.keymap.set("n", "gx", function(path)
  local cmd
  if vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
    cmd = { "xdg-open" }
  elseif (vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1) and vim.fn.executable("open") == 1 then
    cmd = { "open" }
  end
  if not cmd then
    vim.notify("Available system opening tool not found!", vim.log.levels.ERROR)
  end
  vim.fn.jobstart(vim.fn.extend(cmd, { path or vim.fn.expand("<cfile>") }), { detach = true })
end)

-- quickfix list
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Prev Quickfix" })
-- buffer list
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })

-- Undo breakpoint
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")

-- Jumplist mutations
vim.keymap.set("n", "<M-k>", [[ (v:count > 5 ? "m'" . v:count : "") . 'gk']], { expr = true, silent = true })
vim.keymap.set("n", "<M-j>", [[ (v:count > 5 ? "m'" . v:count : "") . 'gj']], { expr = true, silent = true })
vim.keymap.set("i", "<M-h>", "<Left>")
vim.keymap.set("i", "<M-j>", "<Down>")
vim.keymap.set("i", "<M-k>", "<Up>")
vim.keymap.set("i", "<M-l>", "<Right>")
vim.keymap.set("i", "<M-w>", "<S-Right>")
vim.keymap.set("i", "<M-b>", "<S-Left>")
