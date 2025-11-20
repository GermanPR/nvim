-- JSON Schema support for better autocompletion in package.json, tsconfig.json, etc.
return {
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
}
