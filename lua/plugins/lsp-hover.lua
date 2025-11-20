return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Disable K for hover on all LSP servers (we use it for navigation)
      ["*"] = {
        keys = {
          { "K", false },
          { "gh", vim.lsp.buf.hover, desc = "Hover Documentation" },
        },
      },
    },
  },
}
