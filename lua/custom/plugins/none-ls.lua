return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.ruff,        -- Linter
        null_ls.builtins.formatting.black,        -- Formatter
        null_ls.builtins.formatting.isort,        -- Import sorter
      },
    })
  end,
}
