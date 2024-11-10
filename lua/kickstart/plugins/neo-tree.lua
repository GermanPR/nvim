return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Recommended for icons
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<C-b>', ':Neotree reveal toggle<CR>', desc = 'NeoTree toggle and reveal', silent = true },
  },
  opts = {
    filesystem = {
      follow_current_file = true, -- Enable automatic selection of the current file
      window = {
        mappings = {
          ['<C-b>'] = 'close_window',
        },
      },
      use_libuv_file_watcher = false, -- Prevents auto-refresh on directory change
    },
    git_status = {
      enabled = true, -- Enable Git integration
      symbols = {
        added = '✚',
        modified = '',
        deleted = '✖',
        renamed = '',
        untracked = '★',
        ignored = '◌',
        unstaged = '✗',
        staged = '✓',
        conflict = '',
      },
    },
  },
  config = function()
    require('neo-tree').setup {
      enable_diagnostics = false,
				close_if_last_window = true,
      filesystem = {
        follow_current_file = true, -- Automatically select and reveal the current file
        use_libuv_file_watcher = false,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        diagnostics = {
          enabled = false, -- Explicitly disable diagnostics for filesystem
        },
      },
      git_status = {
        enabled = true,
      },
    }

    -- Custom Git Status Colors
    vim.cmd [[
      highlight NeoTreeGtAdded guifg=#a6e22e
      highlight NeoTreeGitModified guifg=#fc9867
      highlight NeoTreeGitDeleted guifg=#f92672
      highlight NeoTreeGitRenamed guifg=#66d9ef
      highlight NeoTreeGitUntracked guifg=#e6db74
      highlight NeoTreeGitIgnored guifg=#75715e
      highlight NeoTreeGitUnstaged guifg=#f92672
      highlight NeoTreeGitStaged guifg=#a6e22e
      highlight NeoTreeGitConflict guifg=#fd971f
    ]]
  end,
}
