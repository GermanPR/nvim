return {
  'ThePrimeagen/harpoon',
  config = function()
    require('harpoon').setup {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 20,
      },
    }

    vim.keymap.set('n', '<leader>a', function()
      require('harpoon.mark').add_file()
    end)
    vim.keymap.set('n', '<leader>m', function()
      require('harpoon.ui').toggle_quick_menu()
    end)
    vim.keymap.set('n', '<leader>l', function()
      require('harpoon.ui').nav_prev()
    end)
    vim.keymap.set('n', '<leader>1', function()
      require('harpoon.ui').nav_file(1)
    end)
    vim.keymap.set('n', '<leader>2', function()
      require('harpoon.ui').nav_file(2)
    end)
    vim.keymap.set('n', '<leader>3', function()
      require('harpoon.ui').nav_file(3)
    end)
    vim.keymap.set('n', '<leader>4', function()
      require('harpoon.ui').nav_file(4)
    end)
  end,
}
