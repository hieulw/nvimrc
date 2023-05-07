vim.g.mapleader = ' '
vim.g.localleader = ' '

vim.keymap.set({'n', 'v'}, vim.g.mapleader, '<Nop>', {silent = true})

-- My hand too lazy to reach Esc
vim.keymap.set('i', 'kj', '<esc>', {silent = true, nowait = true})

-- nano feel here
vim.keymap.set('n', '<C-q>', ':q<cr>', {silent = true})
vim.keymap.set('n', '<C-s>', ':w<cr>', {silent = true})

-- Better tabbing
vim.keymap.set('v', 'L', ">gv")
vim.keymap.set('v', 'H', "<gv")
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv")

-- Better window navigation
-- vim.keymap.set('n', '<C-h>', ":wincmd h<cr>", {silent = true})
-- vim.keymap.set('n', '<C-j>', ":wincmd j<cr>", {silent = true})
-- vim.keymap.set('n', '<C-k>', ":wincmd k<cr>", {silent = true})
-- vim.keymap.set('n', '<C-l>', ":wincmd l<cr>", {silent = true})
-- Resize windows
vim.keymap.set('n', '<C-Down>', ":resize -2<CR>", {silent = true})
vim.keymap.set('n', '<C-Up>', ":resize +2<CR>", {silent = true})
vim.keymap.set('n', '<C-Left>', ":vertical resize -2<CR>", {silent = true})
vim.keymap.set('n', '<C-Right>', ":vertical resize +2<CR>", {silent = true})
if vim.fn.has("macunix") then
    vim.keymap.set('n', '˚', ":resize -2<CR>", {silent = true})
    vim.keymap.set('n', '∆', ":resize +2<CR>", {silent = true})
    vim.keymap.set('n', '¬', ":vertical resize -2<CR>", {silent = true})
    vim.keymap.set('n', '˙', ":vertical resize +2<CR>", {silent = true})
end
-- Switch between vertical and horizontal
vim.keymap.set('n', '<leader>sh', "<C-w>t<C-w>K")
vim.keymap.set('n', '<leader>sv', "<C-w>t<C-w>H")

-- Better scroll
vim.keymap.set('n', '<C-y>', "5<C-y>")
vim.keymap.set('n', '<C-e>', "5<C-e>")

vim.keymap.set('t', '<Esc>', "<C-\\><C-n>")
vim.keymap.set('n', '<leader><bs>', ":nohlsearch<cr>")

-- Fugitive Conflict Resolution
vim.keymap.set('n', '<leader>gd', ":Gvdiff!<CR>")
vim.keymap.set('n', '<leader>gdh', ":diffget //2<CR>")
vim.keymap.set('n', '<leader>gdl', ":diffget //3<CR>")

-- Functions
vim.keymap.set('n', '<leader>e', ":Explore<cr>")
vim.keymap.set('n', '<leader>gb', ":Git blame<CR>")
vim.keymap.set('n', '<leader>d', ":DBUIToggle<CR>")

-- Diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
               {desc = "Go to previous diagnostic message"})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
               {desc = "Go to next diagnostic message"})

-- Easy Align
vim.keymap.set('x', 'ga', "<Plug>(EasyAlign)")
vim.keymap.set('n', 'ga', "<Plug>(EasyAlign)")

-- Apply @record to multiple lines
-- https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
vim.keymap.set('x', '@', function()
    local register = vim.fn.nr2char(vim.fn.getchar())
    vim.print("@" .. vim.fn.getcmdline())
    return ":'<,'>normal @" .. register .. "<cr>"
end, {silent = true, expr = true}) -- expr = true will execute return value of function

-- Better Yank & Paste
-- https://stackoverflow.com/questions/290465/how-to-paste-over-without-overwriting-register
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
-- xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>
vim.keymap.set('n', 'Y', "y$")
vim.keymap.set('v', 'p', function()
    local restore_register, register
    register = vim.api.nvim_get_option('clipboard') == 'unnamedplus' and '+' or
                   '"'
    restore_register = vim.fn.getreginfo(register)
    vim.schedule(function() vim.fn.setreg(register, restore_register) end)
    return 'p'
end, {silent = true, expr = true})

--- Open a URL under the cursor with the current operating system (without netrw)
vim.keymap.set('n', 'gx', function(path)
  local cmd
  if vim.fn.has "unix" == 1 and vim.fn.executable "xdg-open" == 1 then
    cmd = { "xdg-open" }
  elseif (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1) and vim.fn.executable "open" == 1 then
    cmd = { "open" }
  end
  if not cmd then vim.notify("Available system opening tool not found!", vim.log.levels.ERROR) end
  vim.fn.jobstart(vim.fn.extend(cmd, { path or vim.fn.expand "<cfile>" }), { detach = true })
end)

-- Keep cursor center
vim.keymap.set('n', 'n', "nzzzv")
vim.keymap.set('n', 'N', "Nzzzv")
vim.keymap.set('n', 'J', "mzJ`z")
vim.keymap.set('n', '<C-i>', "<C-i>zzzv")
vim.keymap.set('n', '<C-o>', "<C-o>zzzv")

-- Visual text process
-- vim.keymap.set('v', 'gj', ":join<cr>")
-- vim.keymap.set('v', 'gs', ":sort<cr>")

-- Undo breakpoint
vim.keymap.set('i', ',', ",<c-g>u")
vim.keymap.set('i', '.', ".<c-g>u")

-- Jumplist mutations
vim.keymap.set('n', 'k', [[ (v:count > 5 ? "m'" . v:count : "") . 'gk']],
               {expr = true, silent = true})
vim.keymap.set('n', 'j', [[ (v:count > 5 ? "m'" . v:count : "") . 'gj']],
               {expr = true, silent = true})
