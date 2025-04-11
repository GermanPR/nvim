return {
  'stevearc/aerial.nvim',
  config = function()
    require('aerial').setup {
      backends = { 'lsp', 'treesitter', 'markdown' }, -- Symbol sources
      layout = {
        default_direction = 'right', -- Position outline on the right side
        width = 30, -- Width of the aerial window
        min_width = 20, -- Minimum width
        max_width = 50, -- Maximum width
      },
      attach_mode = 'global', -- Attach to all buffers globally
      default_bindings = true, -- Enable default key bindings
      show_guides = true, -- Show guides for nested symbols
      float = {
        border = 'rounded', -- Rounded border for floating window
        max_height = 0.9, -- Floating window height limit
        max_width = 0.5, -- Floating window width limit
      },
    }
    -- You probably also want to set a keymap to toggle aerial
  end,
  lazy = true,
  cmd = { 'AerialToggle', 'AerialOpen', 'AerialClose' , 'AerialNext', 'AerialPrev'}, -- Load only with commands
}
