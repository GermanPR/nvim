-- Linting configuration for TypeScript/JavaScript development
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      ["javascript.jsx"] = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      ["typescript.tsx"] = { "eslint_d" },
    },
    linters = {
      eslint_d = {
        condition = function(ctx)
          return vim.fs.find({ ".eslintrc", ".eslintrc.js", "eslint.config.js", "eslint.config.ts", "eslint.config.cjs", "eslint.config.cts", "eslint.config.mjs", "eslint.config.mts" }, { path = ctx.filename, upward = true })[1]
        end,
      },
    },
  },
}
