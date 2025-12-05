return {
  -- octo.nvim - GitHub PR management (list, review, comment, approve)
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim", -- Required for Octo picker
    },
    event = "VeryLazy",
    keys = {
      -- ============================================
      -- PR Listing & Navigation
      -- ============================================
      -- List all PRs
      { "<leader>gpl", "<cmd>Octo pr list<cr>", desc = "PR: List All" },
      -- My PRs (author @me)
      {
        "<leader>gpm",
        function()
          local my_prs = vim.fn.systemlist(
            'gh pr list --author @me --json number,title,reviewDecision --jq \'.[] | "#\\(.number) - \\(.title) [\\(.reviewDecision // "PENDING")]"\''
          )
          if vim.v.shell_error ~= 0 or #my_prs == 0 or my_prs[1] == "" then
            vim.notify("You have no open PRs", vim.log.levels.INFO)
            return
          end
          vim.ui.select(my_prs, { prompt = "My PRs:" }, function(selected)
            if selected then
              local pr_number = selected:match("#(%d+)")
              if pr_number then
                vim.cmd("Octo pr edit " .. pr_number)
              end
            end
          end)
        end,
        desc = "PR: My PRs",
      },
      -- PRs needing my review
      {
        "<leader>gpn",
        function()
          local prs = vim.fn.systemlist(
            'gh pr list --search "review-requested:@me" --json number,title,author --jq \'.[] | "#\\(.number) - \\(.title) (by @\\(.author.login))"\''
          )
          if vim.v.shell_error ~= 0 or #prs == 0 or prs[1] == "" then
            vim.notify("No PRs need your review!", vim.log.levels.INFO)
            return
          end
          vim.ui.select(prs, { prompt = "PRs needing review:" }, function(selected)
            if selected then
              local pr_number = selected:match("#(%d+)")
              if pr_number then
                vim.cmd("Octo pr edit " .. pr_number)
              end
            end
          end)
        end,
        desc = "PR: Needing My Review",
      },

      -- ============================================
      -- PR Actions
      -- ============================================
      -- Create a PR from the current branch
      { "<leader>gpC", "<cmd>Octo pr create<cr>", desc = "PR: Create" },
      -- Open current branch's PR in Octo
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
        desc = "PR: Open in Octo",
      },
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
        desc = "PR: Open in Browser",
      },
      -- Reload PR
      { "<leader>gpr", "<cmd>Octo pr reload<cr>", desc = "PR: Reload" },
      -- View PR diff in Diffview (alternative to Octo's built-in review)
      {
        "<leader>gpv",
        function()
          local base = vim.fn.system("gh pr view --json baseRefName -q .baseRefName 2>/dev/null")
          base = vim.trim(base)
          if vim.v.shell_error ~= 0 or base == "" then
            vim.notify("Not on a PR branch", vim.log.levels.WARN)
            return
          end
          vim.cmd("DiffviewOpen " .. base .. "...HEAD")
        end,
        desc = "PR: View Diff (Diffview)",
      },

      -- ============================================
      -- Comments & Threads
      -- ============================================
      { "<leader>gpc", "<cmd>Octo comment add<cr>", desc = "PR: Add Comment" },
      { "<leader>gpR", "<cmd>Octo thread resolve<cr>", desc = "PR: Resolve Thread" },
      { "<leader>gpU", "<cmd>Octo thread unresolve<cr>", desc = "PR: Unresolve Thread" },

      -- ============================================
      -- Review Flow
      -- ============================================
      -- Start or resume review (tries resume first, falls back to start)
      {
        "<leader>gpt",
        function()
          -- Try to resume first, if it fails start a new review
          local ok = pcall(vim.cmd, "Octo review resume")
          if not ok then
            vim.cmd("Octo review start")
          end
        end,
        desc = "PR: Start/Resume Review",
      },
      { "<leader>gps", "<cmd>Octo review submit<cr>", desc = "PR: Submit Review" },
      { "<leader>gpd", "<cmd>Octo review discard<cr>", desc = "PR: Discard Review" },

      -- ============================================
      -- Approval Actions
      -- ============================================
      { "<leader>gpa", "<cmd>Octo review submit approve<cr>", desc = "PR: Approve" },
      { "<leader>gpx", "<cmd>Octo review submit request_changes<cr>", desc = "PR: Request Changes" },
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
