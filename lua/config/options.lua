-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.laststatus = 0 -- Disable bottom statusline
vim.opt.cmdheight = 0 -- Hide command line when not in use

-- Disable swap files completely (you lose unsaved changes if nvim crashes)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
