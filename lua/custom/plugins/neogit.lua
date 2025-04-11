return {
  'NeogitOrg/neogit',
  dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    vim.keymap.set('n', '<leader>gs', ':Neogit<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gc', ':Neogit commit<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gp', ':Neogit push<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gl', ':Neogit pull<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gL', ':Neogit log<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gb', ':Telescope git_branches<CR>', { noremap = true, silent = true })
  end,
}
