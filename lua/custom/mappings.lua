
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

-- Indentation in visual and normal mode
vim.keymap.set('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Tab>', '<gv', { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>', '>>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', '<<', { noremap = true, silent = true })


-- Other custom mappings
keymap('n', '<leader>e', ':Explore<CR>', { noremap = true, silent = true })
keymap('n', '<leader>j', ':join<CR>', { noremap = true, silent = true })

