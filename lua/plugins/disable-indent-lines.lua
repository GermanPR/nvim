-- Disable animated indentation plugins (using Snacks static indent instead)

return {
  -- Disable indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  -- Disable mini.indentscope (animated scope indicator)
  {
    "nvim-mini/mini.indentscope",
    enabled = false,
  },
}
