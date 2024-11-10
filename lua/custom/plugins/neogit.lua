return {
  'NeogitOrg/neogit',
  dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>gs', ':Neogit<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gc', ':Neogit commit<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gp', ':Neogit push<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gl', ':Neogit pull<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gL', ':Neogit log<CR>', { noremap = true, silent = true })
  end,
}
