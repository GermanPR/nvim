-- Mason configuration for TypeScript/JavaScript development
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- TypeScript Language Server
      "vtsls", -- Vercel TypeScript Language Server

      -- Linting
      "eslint_d", -- Fast ESLint daemon

      -- Formatting
      "prettierd", -- Fast prettier daemon

      -- Tailwind CSS
      "tailwindcss-language-server",

      -- JSON support
      "json-lsp",
    },
  },
}
