-- Mason configuration for TypeScript/Next.js development
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- TypeScript Language Servers
      "typescript-language-server",
      "vtsls", -- Vercel TypeScript Language Server (faster alternative)

      -- Linting
      "eslint-lsp",

      -- Formatting
      "prettierd", -- Fast prettier daemon

      -- Tailwind CSS
      "tailwindcss-language-server",

      -- JSON support
      "json-lsp",
    },
  },
}
