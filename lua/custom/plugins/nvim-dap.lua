return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'delve' },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Automatically open the REPL on debug session start
    dap.listeners.after.event_initialized['open_repl'] = function()
      require('dap').repl.open()
      vim.cmd 'wincmd H'
    end

    -- Key mappings to toggle console and scopes as floating windows
    vim.keymap.set('n', '<leader>dc', function()
      dapui.float_element 'console'
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<leader>ds', function()
      dapui.float_element 'scopes'
    end, { noremap = true, silent = true })

    -- Close REPL and UI panels on debug session end
    dap.listeners.before.event_terminated['close_repl'] = function()
      vim.cmd ":lua require('dap').repl.close()"
      dapui.close()
    end

    dap.listeners.before.event_exited['close_repl'] = function()
      vim.cmd ":lua require('dap').repl.close()"
      dapui.close()
    end

    -- Golang and Python debugger setup
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    local pythonPath = function()
      local conda_prefix = os.getenv 'CONDA_PREFIX'
      if conda_prefix then
        return vim.fn.has 'win32' == 1 and conda_prefix .. '\\python.exe' or conda_prefix .. '/bin/python'
      end
      return 'python'
    end

    require('dap-python').setup(pythonPath())

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = pythonPath,
        console = 'integratedTerminal',
      },
    }

    -- Debugging key mappings
    vim.keymap.set('n', '<F5>', dap.continue)
    vim.keymap.set('n', '<F10>', dap.step_over)
    vim.keymap.set('n', '<F11>', dap.step_into)
    vim.keymap.set('n', '<F12>', dap.step_out)
    vim.keymap.set('n', '<leader>dd', dap.run_last)
    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)
  end,
}
