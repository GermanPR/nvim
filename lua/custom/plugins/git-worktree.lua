return {
  'ThePrimeagen/git-worktree.nvim',
  config = function()
    local gw = require('git-worktree')
    gw.setup {
      -- Optional configuration settings
      change_directory_command = 'cd', -- Command to change directory (default: 'cd')
      update_on_change = true, -- Automatically update NeoVim on worktree change
      clearjumps_on_change = true, -- Clear jumps on worktree change
      autopush = false, -- Automatically push changes after switching (false by default)
    }

    -- Keybinding to create a new worktree
    vim.keymap.set('n', '<leader>gwc', function()
      -- gw.create_worktree(vim.fn.input 'Branch name: ', 'origin/main', 'checkout')
     require('telescope').extensions.git_worktree.create_git_worktree()
    end, { desc = 'Create worktree' })

    -- -- Keybinding to switch to an existing worktree
    -- vim.keymap.set('n', '<leader>gws', function()
    --   gw.switch_worktree(vim.fn.input 'Worktree path: ')
    -- end, { desc = 'Switch worktree' })

    -- Keybinding to switch to an existing worktree
    -- vim.keymap.set('n', '<leader>gws', function()
    --   gw.delete_worktree(vim.fn.input 'Worktree path: ')
    -- end, { desc = 'Switch worktree' })

    -- Keybinding to list all worktrees
    vim.keymap.set('n', '<leader>gwl', function()
      require('telescope').extensions.git_worktree.git_worktrees()
    end, { desc = 'List worktrees' })
  end,
}
