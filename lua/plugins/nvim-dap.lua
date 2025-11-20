return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Enable DAP logging for debugging
    dap.set_log_level("TRACE")

    -- Set default exception breakpoints
    require("dap").defaults.fallback.exception_breakpoints = { "uncaught" }

    -- Mason DAP setup - auto-install Python debugger
    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = { "debugpy" },
    })

    -- DAP UI setup
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      elements_mappings = {
        expand = "<CR>",
      },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    -- Custom highlights for DAP (theme-aware, reapplies on colorscheme change)
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      desc = "Prevent colorscheme clearing self-defined DAP marker colors",
      callback = function()
        -- Reuse current SignColumn background (except for DapStoppedLine)
        local sign_column_hl = vim.api.nvim_get_hl(0, { name = "SignColumn" })
        local sign_column_bg = (sign_column_hl.bg ~= nil) and ("#%06x"):format(sign_column_hl.bg) or "bg"
        local sign_column_ctermbg = (sign_column_hl.ctermbg ~= nil) and sign_column_hl.ctermbg or "Black"

        vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00ff00", bg = sign_column_bg, ctermbg = sign_column_ctermbg })
        vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d3d", ctermbg = "Green" })
        vim.api.nvim_set_hl(
          0,
          "DapBreakpoint",
          { fg = "#c23127", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
        )
        vim.api.nvim_set_hl(
          0,
          "DapBreakpointRejected",
          { fg = "#888ca6", bg = sign_column_bg, ctermbg = sign_column_ctermbg }
        )
        vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bg = sign_column_bg, ctermbg = sign_column_ctermbg })
      end,
    })

    -- Reload current colorscheme to pick up highlight overrides
    if vim.g.colors_name then
      vim.cmd.colorscheme(vim.g.colors_name)
    end

    -- Define sign icons
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "🛑", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "🛑", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = "🛑", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapLogPoint",
      { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
    )
    vim.fn.sign_define(
      "DapStopped",
      { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
    )

    -- Clear cursorline highlight when debugger continues
    dap.listeners.after.event_continued["clear_breakpoint_highlight"] = function()
      vim.cmd("setlocal nocursorline")
    end

    -- Automatically open the REPL on debug session start (vertical split on right)
    dap.listeners.after.event_initialized["open_repl"] = function()
      local current_win = vim.api.nvim_get_current_win()
      require("dap").repl.open({}, "botright vsplit")
      vim.api.nvim_set_current_win(current_win)  -- Return focus to original window
    end

    -- Key mappings for floating DAP UI elements
    vim.keymap.set("n", "<leader>dc", function()
      dapui.float_element("console")
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>ds", function()
      dapui.float_element("scopes")
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>dt", function()
      dapui.float_element("stacks")
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>dr", function()
      require("dap.repl").toggle({}, "vsplit")
    end, { noremap = true, silent = true })

    vim.keymap.set("v", "<leader>dl", function()
      require("dap.repl").toggle({}, "vsplit")
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>dñ", function()
      dap.focus_frame()
    end, { noremap = true, silent = true })

    -- Function to send visual selection to DAP REPL
    function _G.send_visual_selection_to_dap_repl()
      local session = dap.session()
      if not session then
        print("No active debug session")
        return
      end

      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local lines = vim.fn.getline(start_pos[2], end_pos[2])
      local selected_text

      if #lines == 0 then
        print("No text selected")
        return
      elseif #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
        selected_text = lines[1]
      else
        -- Adjust the first and last lines to account for partial selections
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
        selected_text = table.concat(lines, "\n")
      end

      -- Ensure the REPL is open
      dap.repl.open()
      dap.repl.execute(selected_text)
    end

    vim.api.nvim_set_keymap(
      "v",
      "<leader>dr",
      ":lua send_visual_selection_to_dap_repl()<CR>",
      { noremap = true, silent = true }
    )

    -- Close REPL and UI panels on debug session end
    dap.listeners.before.event_terminated["close_repl"] = function()
      pcall(function()
        require("dap").repl.close()
      end)
      dapui.close()
    end

    dap.listeners.before.event_exited["close_repl"] = function()
      pcall(function()
        require("dap").repl.close()
      end)
      dapui.close()
    end

    -- Python debugger setup with conda/virtualenv support
    local pythonPath = function()
      local conda_prefix = os.getenv("CONDA_PREFIX")
      if conda_prefix then
        local python_executable = vim.fn.has("win32") == 1 and conda_prefix .. "\\python.exe"
          or conda_prefix .. "/bin/python"
        return python_executable
      end
      -- Check for Poetry virtualenv in .venv (consistent with your python-lsp.lua)
      local cwd = vim.fn.getcwd()
      local poetry_venv = cwd .. "/.venv/bin/python"
      if vim.fn.filereadable(poetry_venv) == 1 then
        return poetry_venv
      end
      return "python"
    end

    require("dap-python").setup(pythonPath())

    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = pythonPath(),
        console = "integratedTerminal",
      },
    }

    -- Load configurations from .vscode/launch.json (if it exists)
    local launch_json = vim.fn.getcwd() .. "/.vscode/launch.json"
    if vim.fn.filereadable(launch_json) == 1 then
      local ok, err = pcall(function()
        require("dap.ext.vscode").load_launchjs(nil, { debugpy = { "python" } })
      end)
      if not ok then
        vim.notify("Failed to load .vscode/launch.json: " .. tostring(err), vim.log.levels.WARN)
      end
    end

    -- Command to view DAP logs
    vim.api.nvim_create_user_command("DapShowLog", function()
      local log_path = vim.fn.stdpath("cache") .. "/dap.log"
      vim.cmd("tabnew " .. log_path)
    end, {})

    -- Debugging key mappings
    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F10>", dap.step_over)
    vim.keymap.set("n", "<F11>", dap.step_into)
    vim.keymap.set("n", "<F12>", dap.step_out)
    vim.keymap.set("n", "<leader>dd", dap.run_last)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end)
    vim.keymap.set("n", "<leader>dL", ":DapShowLog<CR>", { noremap = true, silent = true })
  end,
}
