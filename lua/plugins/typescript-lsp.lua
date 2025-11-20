return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false, -- Disable inlay hints globally
    },
    servers = {
      -- TypeScript Language Server (Vercel's faster implementation)
      vtsls = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              parameterNames = { enabled = "none" },
              parameterTypes = { enabled = false },
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              enumMemberValues = { enabled = false },
            },
          },
          javascript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              parameterNames = { enabled = "none" },
              parameterTypes = { enabled = false },
              variableTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              enumMemberValues = { enabled = false },
            },
          },
        },
      },
      -- ESLint Language Server (stackweb uses flat config)
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          experimental = {
            useFlatConfig = true,
          },
        },
      },
      -- Tailwind CSS Language Server (for stackweb's Tailwind classes)
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
