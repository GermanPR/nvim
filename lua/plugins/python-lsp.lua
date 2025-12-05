return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Ruff for linting and formatting (replaces ruff-lsp)
      ruff = {
        root_markers = { ".venv", ".git", "pyproject.toml" },
        init_options = {
          settings = {
            configurationPreference = "filesystemFirst",
          },
        },
      },
      -- Basedpyright for type checking
      basedpyright = {
        root_markers = { ".venv", ".git", "pyproject.toml" },
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
