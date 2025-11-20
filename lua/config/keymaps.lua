-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Override K for movement (7 lines up)
map({ "n", "v" }, "K", "9k", { noremap = true, silent = true })
map({ "n", "v" }, "J", "9j")
map({ "n", "v" }, ";", "/")
map({ "n", "v" }, ":", "?")
map({ "n", "v" }, "/", ":")
map({ "n", "v" }, "<leader>;", "*")
map({ "n", "v" }, "<leader>h", "^")
map({ "n", "v" }, "<leader>l", "$")
map({ "i" }, "jk", "<C-c>")

-- File picker (same as <leader>ff) - Snacks picker
map("n", "<C-p>", function()
  require("snacks").picker.files()
end, { noremap = true, silent = true, desc = "Find Files (Snacks)" })

-- Remap <leader>sg to use fixed-string (literal) search by default
-- This means no need to escape special characters like {}, [], (), etc.
map("n", "<leader>sg", function()
  require("snacks").picker.grep({
    -- Add --fixed-strings flag to treat pattern as literal text
    rg = { "--fixed-strings" },
  })
end, { noremap = true, silent = true, desc = "Grep (Literal/Fixed-String)" })

-- Visual mode: grep with selected text (also literal search)
map("v", "<leader>sg", function()
  -- Get visually selected text
  vim.cmd('normal! "vy')
  local text = vim.fn.getreg("v")
  -- No need to escape since we're using fixed-strings mode
  require("snacks").picker.grep({
    search = text,
    rg = { "--fixed-strings" },
  })
end, { noremap = true, silent = true, desc = "Grep selection (literal)" })

-- Jump forward (opposite of Ctrl-o) - Ctrl-j as Ctrl-i since terminal blocks Ctrl-i
map("n", "<C-j>", "<C-i>", { noremap = true, silent = true, desc = "Jump forward in jump list" })
map("n", "<leader>j", ":join<CR>", { noremap = true, silent = true, desc = "Join lines" })

-- Reload config (using <leader>R to avoid shadowing with <leader>r search/replace)
map("n", "<leader>R", function()
  -- Unload config modules from Lua cache
  for module, _ in pairs(package.loaded) do
    if module:match("^config%.") then
      package.loaded[module] = nil
    end
  end

  -- Reload config files
  vim.cmd("source ~/.config/nvim/lua/config/keymaps.lua")
  vim.cmd("source ~/.config/nvim/lua/config/options.lua")
  vim.cmd("source ~/.config/nvim/lua/config/autocmds.lua")

  vim.notify("Config reloaded! (keymaps, options, autocmds)", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Reload config" })

-- Indentation in visual and normal mode
map("v", "<Tab>", ">gv", { noremap = true, silent = true })
map("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
map("n", "<Tab>", ">>", { noremap = true, silent = true })
map("n", "<S-Tab>", "<<", { noremap = true, silent = true })

-- Copy file path relative to cwd
map("n", "<leader>yp", function()
  local filepath = vim.fn.expand("%:.")
  local buftype = vim.bo.buftype

  -- Skip special buffers (terminal, quickfix, help, etc.)
  if buftype ~= "" or filepath == "" then
    vim.notify("Not a regular file buffer", vim.log.levels.WARN)
    return
  end

  vim.fn.setreg("+", filepath)
  vim.notify("Copied: " .. filepath, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Copy file path" })

-- Search and replace pre-populated with word under cursor (case-sensitive)
map("n", "<leader>r", function()
  local word = vim.fn.expand("<cword>")
  vim.api.nvim_feedkeys(":%s/\\C" .. word .. "/" .. word .. "/g", "n", false)
  -- Move cursor back to end of second occurrence (before /g)
  vim.defer_fn(function()
    local keys = vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end, 10)
end, { noremap = true, silent = true, desc = "Search/replace word under cursor (case-sensitive)" })

-- Search and replace pre-populated with visual selection (case-sensitive)
map("v", "<leader>r", function()
  -- Get visually selected text
  vim.cmd('normal! "vy')
  local text = vim.fn.getreg("v")
  -- Escape special characters for use in substitute command
  text = vim.fn.escape(text, "/\\")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  vim.api.nvim_feedkeys(":%s/\\C" .. text .. "/" .. text .. "/g", "n", false)
  -- Move cursor back to end of second occurrence (before /g)
  vim.defer_fn(function()
    local keys = vim.api.nvim_replace_termcodes("<Left><Left>", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end, 10)
end, { noremap = true, silent = true, desc = "Search/replace selection (case-sensitive)" })

-- Toggle inlay hints
map("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle Inlay Hints" })

-- Clean all buffers and start fresh
map("n", "<leader>bx", function()
  -- Close all buffers
  vim.cmd("bufdo bwipeout")
  -- Delete all swap files
  vim.fn.system("rm -f ~/.local/state/nvim/swap/*")
  vim.notify("All buffers and swap files cleaned!", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Clean all buffers and swap files" })

-- Code folding keymaps
map("n", "<leader><CR>", "za", { noremap = true, silent = true, desc = "Toggle fold under cursor" })
map("n", "zl", "zM", { noremap = true, silent = true, desc = "Close all folds" })
map("n", "zL", "zR", { noremap = true, silent = true, desc = "Open all folds" })

-- Open current markdown file in Typora
map("n", "<leader>tp", function()
  local filepath = vim.fn.expand("%:p")
  local filetype = vim.bo.filetype

  if filetype ~= "markdown" then
    vim.notify("Not a markdown file", vim.log.levels.WARN)
    return
  end

  -- Open in Typora (runs in background)
  vim.fn.jobstart({ "typora", filepath }, { detach = true })
  vim.notify("Opening in Typora: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Open markdown in Typora" })

-- Window resize with Alt+hjkl
map("n", "<A-h>", ":vertical resize -2<CR>", { noremap = true, silent = true, desc = "Decrease window width" })
map("n", "<A-l>", ":vertical resize +2<CR>", { noremap = true, silent = true, desc = "Increase window width" })
map("n", "<A-k>", ":resize -2<CR>", { noremap = true, silent = true, desc = "Decrease window height" })
map("n", "<A-j>", ":resize +2<CR>", { noremap = true, silent = true, desc = "Increase window height" })
