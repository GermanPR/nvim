
local keymap = vim.api.nvim_set_keymap

-- Clear search highlights with <Esc>
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { noremap = true, silent = true })

-- Custom key mappings
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, 'K', '7k')
vim.keymap.set({ 'n', 'v' }, 'J', '7j')
vim.keymap.set({ 'n', 'v' }, 'ñ', '/')
vim.keymap.set({ 'n', 'v' }, 'Ñ', '?')
vim.keymap.set({ 'n', 'v' }, '<leader>ñ', '*')

vim.keymap.set({ 'n', 'v' }, '<CR>l', '<cmd>AerialPrev<CR>')

-- Indentation in visual and normal mode
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', '>>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<<', { noremap = true, silent = true })

-- go to explorer
keymap('n', '<leader>e', ':Explore<CR>', { noremap = true, silent = true })
-- join lines
keymap('n', '<leader>j', ':join<CR>', { noremap = true, silent = true })
-- aerial
vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { noremap = true, silent = true })

-- join lines
vim.keymap.set('n', '<leader>i', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

-- keep the ctrl i for the jump list
vim.keymap.set('n', '<C-i>', '<C-i>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
