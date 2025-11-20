-- Treesitter context: Shows function/class headers stuck to top while scrolling
return {
  "nvim-treesitter/nvim-treesitter-context",
  opts = {
    enable = true, -- Enable by default on startup
    max_lines = 3, -- How many lines of context to show
    min_window_height = 0, -- Minimum editor window height to enable context
    line_numbers = true, -- Show line numbers in context
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = "outer", -- Which context lines to discard if max_lines is exceeded
    mode = "cursor", -- Line used to calculate context (cursor or topline)
    separator = nil, -- Separator between context and content (nil = no separator)
    zindex = 20, -- Z-index of the context window
  },
}
