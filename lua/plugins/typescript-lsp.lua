return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- TypeScript Language Server (Vercel's faster implementation)
      vtsls = {},
      -- Tailwind CSS Language Server
      tailwindcss = {
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      },
    },
  },
}
