-- Formatter configuration for TypeScript/JavaScript development
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      typescript = function(bufnr)
        local formatters = {}
        if vim.fs.find({ ".eslintrc", ".eslintrc.js", "eslint.config.js", "eslint.config.ts", "eslint.config.cjs", "eslint.config.cts", "eslint.config.mjs", "eslint.config.mts" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "eslint_d")
        end
        if vim.fs.find({ ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] or vim.fs.find({ "package.json" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "prettierd")
        end
        return formatters
      end,
      typescriptreact = function(bufnr)
        local formatters = {}
        if vim.fs.find({ ".eslintrc", ".eslintrc.js", "eslint.config.js", "eslint.config.ts", "eslint.config.cjs", "eslint.config.cts", "eslint.config.mjs", "eslint.config.mts" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "eslint_d")
        end
        if vim.fs.find({ ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] or vim.fs.find({ "package.json" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "prettierd")
        end
        return formatters
      end,
      javascript = function(bufnr)
        local formatters = {}
        if vim.fs.find({ ".eslintrc", ".eslintrc.js", "eslint.config.js", "eslint.config.ts", "eslint.config.cjs", "eslint.config.cts", "eslint.config.mjs", "eslint.config.mts" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "eslint_d")
        end
        if vim.fs.find({ ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] or vim.fs.find({ "package.json" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "prettierd")
        end
        return formatters
      end,
      javascriptreact = function(bufnr)
        local formatters = {}
        if vim.fs.find({ ".eslintrc", ".eslintrc.js", "eslint.config.js", "eslint.config.ts", "eslint.config.cjs", "eslint.config.cts", "eslint.config.mjs", "eslint.config.mts" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "eslint_d")
        end
        if vim.fs.find({ ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs", ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] or vim.fs.find({ "package.json" }, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })[1] then
          table.insert(formatters, "prettierd")
        end
        return formatters
      end,
    },
  },
}
