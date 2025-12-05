return {
  -- diffview.nvim - Advanced git diff and PR review tool
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewToggleFiles" },
    keys = {
      -- File history for current file
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Git File History",
      },
      -- File history for current line/selection
      {
        "<leader>gH",
        ":'<,'>DiffviewFileHistory<cr>",
        mode = "v",
        desc = "Git Line History",
      },
      -- Close diffview
      {
        "<leader>gq",
        "<cmd>DiffviewClose<cr>",
        desc = "Close Diffview",
      },
      -- Open PR review (fetch and review a PR by number)
      {
        "<leader>gpr",
        function()
          vim.ui.input({ prompt = "PR number: " }, function(pr_number)
            if pr_number and pr_number ~= "" then
              -- Fetch the PR and open diffview
              local fetch_cmd = string.format("gh pr checkout %s 2>&1", pr_number)
              local output = vim.fn.system(fetch_cmd)
              if vim.v.shell_error == 0 then
                vim.notify("Checked out PR #" .. pr_number, vim.log.levels.INFO)
                -- Get the base branch for the PR
                local base_branch =
                  vim.fn.system(string.format("gh pr view %s --json baseRefName -q .baseRefName", pr_number))
                base_branch = vim.trim(base_branch)
                -- Open diffview comparing with base branch
                vim.cmd("DiffviewOpen " .. base_branch)
              else
                vim.notify("Failed to checkout PR: " .. output, vim.log.levels.ERROR)
              end
            end
          end)
        end,
        desc = "Review PR (by number)",
      },
      -- Browse PRs and review selected one
      {
        "<leader>gpl",
        function()
          -- Use Snacks picker to show list of PRs
          local prs = vim.fn.systemlist(
            "gh pr list --json number,title,headRefName --jq '.[] | \"#\\(.number) - \\(.title) (\\(.headRefName))\"'"
          )

          if vim.v.shell_error ~= 0 or #prs == 0 then
            vim.notify("No PRs found or gh CLI not available", vim.log.levels.WARN)
            return
          end

          vim.ui.select(prs, {
            prompt = "Select PR to review:",
          }, function(selected)
            if selected then
              -- Extract PR number from selection
              local pr_number = selected:match("#(%d+)")
              if pr_number then
                -- Checkout and review the PR
                local fetch_cmd = string.format("gh pr checkout %s 2>&1", pr_number)
                local output = vim.fn.system(fetch_cmd)
                if vim.v.shell_error == 0 then
                  vim.notify("Checked out PR #" .. pr_number, vim.log.levels.INFO)
                  -- Get the base branch for the PR
                  local base_branch =
                    vim.fn.system(string.format("gh pr view %s --json baseRefName -q .baseRefName", pr_number))
                  base_branch = vim.trim(base_branch)
                  -- Open diffview comparing with base branch
                  vim.cmd("DiffviewOpen " .. base_branch)
                else
                  vim.notify("Failed to checkout PR: " .. output, vim.log.levels.ERROR)
                end
              end
            end
          end)
        end,
        desc = "List & Review PRs",
      },
      -- Show my PRs (created by me)
      {
        "<leader>gpm",
        function()
          local my_prs = vim.fn.systemlist(
            'gh pr list --author @me --json number,title,headRefName,reviewDecision --jq \'.[] | "#\\(.number) - \\(.title) [\\(.reviewDecision // "PENDING")]"\''
          )

          if vim.v.shell_error ~= 0 or #my_prs == 0 or my_prs[1] == "" then
            vim.notify("You have no open PRs", vim.log.levels.INFO)
            return
          end

          vim.ui.select(my_prs, {
            prompt = string.format("My PRs (%d):", #my_prs),
          }, function(selected)
            if selected then
              local pr_number = selected:match("#(%d+)")
              if pr_number then
                local fetch_cmd = string.format("gh pr checkout %s 2>&1", pr_number)
                local output = vim.fn.system(fetch_cmd)
                if vim.v.shell_error == 0 then
                  vim.notify("Checked out PR #" .. pr_number, vim.log.levels.INFO)
                  local base_branch =
                    vim.fn.system(string.format("gh pr view %s --json baseRefName -q .baseRefName", pr_number))
                  base_branch = vim.trim(base_branch)
                  vim.cmd("DiffviewOpen " .. base_branch)
                else
                  vim.notify("Failed to checkout PR: " .. output, vim.log.levels.ERROR)
                end
              end
            end
          end)
        end,
        desc = "My PRs",
      },
      -- Show PRs needing my review
      {
        "<leader>gpn",
        function()
          local review_prs = vim.fn.systemlist(
            'gh pr list --search "review-requested:@me" --json number,title,headRefName,author --jq \'.[] | "#\\(.number) - \\(.title) (by @\\(.author.login))"\''
          )

          if vim.v.shell_error ~= 0 or #review_prs == 0 or review_prs[1] == "" then
            vim.notify("No PRs need your review!", vim.log.levels.INFO)
            return
          end

          vim.ui.select(review_prs, {
            prompt = string.format("PRs needing your review (%d):", #review_prs),
          }, function(selected)
            if selected then
              local pr_number = selected:match("#(%d+)")
              if pr_number then
                local fetch_cmd = string.format("gh pr checkout %s 2>&1", pr_number)
                local output = vim.fn.system(fetch_cmd)
                if vim.v.shell_error == 0 then
                  vim.notify("Checked out PR #" .. pr_number, vim.log.levels.INFO)
                  local base_branch =
                    vim.fn.system(string.format("gh pr view %s --json baseRefName -q .baseRefName", pr_number))
                  base_branch = vim.trim(base_branch)
                  vim.cmd("DiffviewOpen " .. base_branch)
                else
                  vim.notify("Failed to checkout PR: " .. output, vim.log.levels.ERROR)
                end
              end
            end
          end)
        end,
        desc = "PRs Needing My Review",
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
