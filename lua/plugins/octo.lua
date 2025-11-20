return {
  -- octo.nvim - GitHub PR comments and reviews
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
      -- Open current PR for commenting
      {
        "<leader>gpo",
        function()
          local pr_number = vim.fn.system("gh pr view --json number -q .number 2>/dev/null")
          pr_number = vim.trim(pr_number)
          if vim.v.shell_error ~= 0 or pr_number == "" then
            vim.notify("Not on a PR branch", vim.log.levels.WARN)
            return
          end
          vim.cmd("Octo pr edit " .. pr_number)
        end,
        desc = "Open PR in Octo",
      },
      -- Add comment (when in octo buffer or on a line in review)
      { "<leader>gpc", "<cmd>Octo comment add<cr>", desc = "Add Comment" },
      -- Approve PR
      { "<leader>gpa", "<cmd>Octo review submit approve<cr>", desc = "Approve PR" },
      -- Request changes
      { "<leader>gpx", "<cmd>Octo review submit request_changes<cr>", desc = "Request Changes" },
      -- Start review (add multiple comments before submitting)
      { "<leader>gpt", "<cmd>Octo review start<cr>", desc = "Start Review" },
    },
    config = function()
      require("octo").setup({
        default_remote = { "upstream", "origin" },
        ssh_aliases = {},
        reaction_viewer_hint_icon = " ",
        user_icon = " ",
        timeline_marker = " ",
        timeline_indent = 2,
        picker = "snacks",
        gh_cmd = "gh", -- Explicitly specify gh command
        gh_env = {}, -- Additional environment variables for gh
        timeout = 5000, -- Increase timeout to 5 seconds
      })
    end,
  },
}
