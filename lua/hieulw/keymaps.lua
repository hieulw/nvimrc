local map = vim.keymap.set

map({ "n", "v" }, vim.g.mapleader, "<Nop>", { silent = true })

-- Switch between vertical and horizontal
map("n", "<leader>sh", "<C-w>t<C-w>K")
map("n", "<leader>sv", "<C-w>t<C-w>H")

-- Better scroll
map("n", "<C-y>", "5<C-y>")
map("n", "<C-e>", "5<C-e>")

map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<leader><bs>", "<cmd>set hlsearch!<cr>", { noremap = true, silent = true })

-- Fugitive Conflict Resolution
map("n", "<leader>gd", ":Gvdiff!<CR>")
map("n", "<leader>gdh", ":diffget //2<CR>")
map("n", "<leader>gdl", ":diffget //3<CR>")

-- Apply @record to multiple lines
-- https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
map("x", "@", function()
  local register = vim.fn.nr2char(vim.fn.getchar())
  vim.print("@" .. vim.fn.getcmdline())
  return ":'<,'>normal @" .. register .. "<cr>"
end, { silent = true, expr = true }) -- expr = true will execute return value of function

-- Better Yank & Paste
-- https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
-- xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>
-- use P instead of p because it doesn't override register
map("n", "Y", "y$", { desc = "Copy to end of line" })
map("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Open a URL under the cursor with the current operating system (without netrw)
map("n", "gx", function(path)
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
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next Quickfix" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Prev Quickfix" })
-- buffer list
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })

-- Undo breakpoint
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")

-- Jumplist mutations
map("n", "<M-k>", [[ (v:count > 5 ? "m'" . v:count : "") . 'gk']], { expr = true, silent = true })
map("n", "<M-j>", [[ (v:count > 5 ? "m'" . v:count : "") . 'gj']], { expr = true, silent = true })
-- Move only sideways in command mode. Using `silent = false` makes movements
-- to be immediately shown.
map("c", "<M-h>", "<Left>", { silent = false, desc = "Left" })
map("c", "<M-l>", "<Right>", { silent = false, desc = "Right" })
-- Don't `noremap` in insert mode to have these keybindings behave exactly
-- like arrows (crucial inside TelescopePrompt)
map("i", "<M-h>", "<Left>", { noremap = false, desc = "Left" })
map("i", "<M-j>", "<Down>", { noremap = false, desc = "Down" })
map("i", "<M-k>", "<Up>", { noremap = false, desc = "Up" })
map("i", "<M-l>", "<Right>", { noremap = false, desc = "Right" })
map("t", "<M-h>", "<Left>", { desc = "Left" })
map("t", "<M-j>", "<Down>", { desc = "Down" })
map("t", "<M-k>", "<Up>", { desc = "Up" })
map("t", "<M-l>", "<Right>", { desc = "Right" })

map("i", "<M-w>", "<S-Right>")
map("i", "<M-b>", "<S-Left>")

-- Utilities
map("n", "<leader>pl", "<cmd>Lazy<cr>")
map("n", "<leader>pm", "<cmd>Mason<cr>")
