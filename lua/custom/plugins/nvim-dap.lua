return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'nvim-telescope/telescope-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    require('dap').defaults.fallback.exception_breakpoints = { 'uncaught' }

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'delve' },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      elements_mappings = {
        expand = '<CR>',
      },
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
    -- -- Define custom highlight for stopped line
    -- vim.highlight.create('DapBreakpoint', { ctermbg=0, guifg='#993939', guibg='#31353f' }, false)
    -- vim.highlight.create('DapLogPoint', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)
    -- vim.highlight.create('DapStopped', { ctermbg=0, guifg='#98c379', guibg='#31353f' }, false)

    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      desc = 'Prevent colorscheme clearing self-defined DAP marker colors',
      callback = function()
        -- Reuse current SignColumn background (except for DapStoppedLine)
        local sign_column_hl = vim.api.nvim_get_hl(0, { name = 'SignColumn' })
        -- if bg or ctermbg aren't found, use bg = 'bg' (which means current Normal) and ctermbg = 'Black'
        -- convert to 6 digit hex value starting with #
        local sign_column_bg = (sign_column_hl.bg ~= nil) and ('#%06x'):format(sign_column_hl.bg) or 'bg'
        local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or 'Black'

        vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#00ff00', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
        vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d', ctermbg = 'Green' })
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#c23127', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
        vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#888ca6', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
        vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef', bg = sign_column_bg, ctermbg = sign_column_ctermbg })
      end,
    })

    -- reload current color scheme to pick up colors override if it was set up in a lazy plugin definition fashion
    vim.cmd.colorscheme(vim.g.colors_name)

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '🛑', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '🛑', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })

    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = 'DapStoppedLine' })
    -- Function to place the highlight

    -- Clear the highlight sign when continuing
    -- dap.listeners.after.event_continued['clear_breakpoint_highlight'] = function()
    --   vim.fn.sign_unplace 'dap_stopped'
    -- end
    -- vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
    -- -- Set up automatic line highlighting on breakpoint
    -- dap.listeners.after.event_stopped['highlight_breakpoint_line'] = function()
    --   vim.api.nvim_set_hl(0, 'CursorLine', { link = 'DapBreakpointLine' })
    --   vim.cmd 'setlocal cursorline' -- enable cursorline for the breakpoint
    -- end

    -- Clear highlight when debugger continues
    dap.listeners.after.event_continued['clear_breakpoint_highlight'] = function()
      vim.cmd 'setlocal nocursorline' -- disable cursorline
    end
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

    vim.keymap.set('n', '<leader>dt', function()
      dapui.float_element 'stacks'
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<leader>dr', function()
      require('dap.repl').toggle({}, 'vsplit')
    end, { noremap = true, silent = true }) -- Close REPL and UI panels on debug session end

    vim.keymap.set('v', '<leader>dl', function()
      require('dap.repl').toggle({}, 'vsplit')
    end, { noremap = true, silent = true }) -- Close REPL and UI panels on debug session end

    vim.keymap.set('n', '<leader>dñ', function()
      dap.focus_frame()
    end, { noremap = true, silent = true })

    -- test

    function _G.send_visual_selection_to_dap_repl()
      local session = dap.session()
      if not session then
        print 'No active debug session'
        return
      end

      local start_pos = vim.fn.getpos "'<"
      local end_pos = vim.fn.getpos "'>"
      local lines = vim.fn.getline(start_pos[2], end_pos[2])
      local selected_text
      if #lines == 0 then
        print 'No text selected'
        return
      elseif #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
        selected_text = lines[1]
      else
        -- Adjust the first and last lines to account for partial selections
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
        selected_text = table.concat(lines, '\n')
      end


      -- Ensure the REPL is open
      dap.repl.open()
      dap.repl.execute(selected_text)
    end

    vim.api.nvim_set_keymap('v', '<leader>dr', ':lua send_visual_selection_to_dap_repl()<CR>', { noremap = true, silent = true })

    -- test

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
        local python_executable = vim.fn.has 'win32' == 1 and conda_prefix .. '\\python.exe' or conda_prefix .. '/bin/python'
        return python_executable
      end
      return 'python'
    end
    -- require('dap.ext.vscode').load_launchjs(nil, { debugpy = { 'python' } })
    -- dap.adapters.debugpy = {
    --   type = 'executable',
    --   command = 'python',
    --   args = { '-m', 'debugpy.adapter' },
    -- -- }
    -- require('dap.ext.vscode').load_launchjs(nil, { debugpy = { 'python' } })
    require('dap-python').setup(pythonPath())

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = pythonPath(),
        console = 'integratedTerminal',
      },
    }
    -- set dap config for .vscode/launch.json

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
