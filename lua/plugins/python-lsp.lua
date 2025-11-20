return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Ruff for linting and formatting (replaces ruff-lsp)
      ruff = {
        init_options = {
          settings = {
            -- Use project's ruff configuration from pyproject.toml
            configurationPreference = "filesystemFirst",
          },
        },
      },
      -- Basedpyright for type checking
      basedpyright = {
        settings = {
          basedpyright = {
            -- Use pyproject.toml configuration
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly", -- Changed from "workspace" for better performance
              -- Performance optimizations
              indexing = true, -- Enable indexing for faster go-to-definition
              autoImportCompletions = true,
              -- Exclude common directories that slow down analysis
              exclude = {
                "**/node_modules",
                "**/__pycache__",
                "**/.venv",
                "**/venv",
                "**/.git",
              },
            },
          },
          python = {
            -- Point to Poetry virtualenv
            pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
          },
        },
      },
    },
  },
}
