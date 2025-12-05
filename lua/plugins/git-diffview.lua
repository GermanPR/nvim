return {
  -- diffview.nvim - Git diff viewer for local operations
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles" },
    keys = {
      -- File history for current file
      {
        "<leader>gdf",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Diff: File History",
      },
      -- File history for current line/selection
      {
        "<leader>gdl",
        ":'<,'>DiffviewFileHistory<cr>",
        mode = "v",
        desc = "Diff: Line History",
      },
      -- Open diffview (working changes vs HEAD)
      {
        "<leader>gdo",
        "<cmd>DiffviewOpen<cr>",
        desc = "Diff: Open (working changes)",
      },
      -- Close diffview
      {
        "<leader>gdq",
        "<cmd>DiffviewClose<cr>",
        desc = "Diff: Close",
      },
    },
    opts = {
      enhanced_diff_hl = true, -- Better syntax highlighting in diffs
      view = {
        default = {
          layout = "diff2_horizontal", -- Side-by-side layout
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
    },
  },
}
