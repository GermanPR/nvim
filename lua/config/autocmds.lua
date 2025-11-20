-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Open Harpoon's first file on startup (if it exists)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only auto-navigate if no files were specified on command line
    if vim.fn.argc() == 0 then
      -- Small delay to ensure Harpoon is loaded
      vim.defer_fn(function()
        local ok, harpoon_ui = pcall(require, "harpoon.ui")
        if ok then
          -- Silently try to navigate, ignore errors (swap files, etc.)
          pcall(harpoon_ui.nav_file, 1)
        end
      end, 100)
    end
  end,
})
