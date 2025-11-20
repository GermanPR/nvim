return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- Disable auto-opening on startup
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    window = {
      position = "left",
      width = 30,
    },
  },
  -- Remove the default VimEnter autocmd that opens Neo-tree
  init = function()
    -- Disable LazyVim's default Neo-tree auto-open behavior
    vim.g.neo_tree_remove_legacy_commands = 1
  end,
}
