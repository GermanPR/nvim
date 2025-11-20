-- Treesitter configuration for TypeScript/Next.js development
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "css",
        "scss",
        "html",
      })
    end
  end,
}
