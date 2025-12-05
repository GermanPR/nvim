-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
  local current_path = vim.env.PATH or ""
  if not string.find(current_path, mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. current_path
  end
end

vim.opt.relativenumber = false
vim.opt.laststatus = 0 -- Disable bottom statusline
vim.opt.cmdheight = 0 -- Hide command line when not in use

-- Disable swap files completely (you lose unsaved changes if nvim crashes)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.wrap = true
