return {
  -- octo.nvim - GitHub PR comments and reviews
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim", -- Required for Octo picker
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
      -- List PRs
      { "<leader>op", "<cmd>Octo pr list<cr>", desc = "List PRs Octo" },
      -- Open PR in browser
      {
        "<leader>gpw",
        function()
          local pr_number = vim.fn.system("gh pr view --json number -q .number 2>/dev/null")
          pr_number = vim.trim(pr_number)
          if vim.v.shell_error ~= 0 or pr_number == "" then
            vim.notify("Not on a PR branch or no PR open", vim.log.levels.WARN)
            return
          end
          vim.fn.system("gh pr view " .. pr_number .. " --web")
        end,
        desc = "Open PR in Browser",
      },
      -- Add comment (when in octo buffer or on a line in review)
      { "<leader>gpc", "<cmd>Octo comment add<cr>", desc = "Add Comment" },
      -- Resolve/unresolve threads
      { "<leader>gpr", "<cmd>Octo thread resolve<cr>", desc = "Resolve Thread" },
      { "<leader>gpu", "<cmd>Octo thread unresolve<cr>", desc = "Unresolve Thread" },
      -- Review management
      { "<leader>gpt", "<cmd>Octo review start<cr>", desc = "Start Review" },
      { "<leader>gps", "<cmd>Octo review submit<cr>", desc = "Submit Review" },
      { "<leader>gpd", "<cmd>Octo review discard<cr>", desc = "Discard Review" },
      -- Approve PR
      { "<leader>gpa", "<cmd>Octo review submit approve<cr>", desc = "Approve PR" },
      -- Request changes
      { "<leader>gpx", "<cmd>Octo review submit request_changes<cr>", desc = "Request Changes" },
      -- Reload PR
      { "<leader>gpl", "<cmd>Octo pr reload<cr>", desc = "Reload PR" },
    },
    config = function()
      require("octo").setup({
        default_remote = { "upstream", "origin" },
        ssh_aliases = { ["github.com-stack"] = "github.com" },
        reaction_viewer_hint_icon = " ",
        user_icon = " ",
        timeline_marker = " ",
        timeline_indent = 2,
        picker = "telescope", -- Explicitly use telescope (now installed as dependency)
        gh_cmd = "gh",
        gh_env = {},
        timeout = 10000, -- Increased to 10 seconds
        suppress_missing_scope = {
          projects_v2 = true,
        },
        -- Use local filesystem files for PR reviews so LSP works properly
        use_local_fs = true,
      })
    end,
  },
}
