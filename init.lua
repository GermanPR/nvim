require("custom.options")
require("custom.mappings")

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require('lazy').setup({
  { import = 'custom.plugins'},
  { import = 'kickstart.plugins'}
}, {
  ui = {
    icons = { plugin = '🔌' }
  }
})

