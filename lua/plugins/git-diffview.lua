local function view_pr_in_diffview()
  -- Fetch PRs with their head refs
  local prs = vim.fn.systemlist(
    'gh pr list --json number,title,headRefName,author --jq \'.[] | "#\\(.number) - \\(.title) (by @\\(.author.login)) [\\(.headRefName)]"\''
  )
  if vim.v.shell_error ~= 0 or #prs == 0 or prs[1] == "" then
    vim.notify("No open PRs found", vim.log.levels.INFO)
    return
  end

  vim.ui.select(prs, { prompt = "Select PR to view:" }, function(selected)
    if not selected then
      return
    end
    local pr_number = selected:match("#(%d+)")
    local branch = selected:match("%[([^%]]+)%]$")
    if not pr_number or not branch then
      vim.notify("Failed to parse PR info", vim.log.levels.ERROR)
      return
    end

    vim.notify("Fetching PR #" .. pr_number .. "...", vim.log.levels.INFO)
    -- Fetch the PR branch
    local fetch_output = vim.fn.system("gh pr checkout " .. pr_number .. " 2>&1")
    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to fetch PR: " .. vim.trim(fetch_output), vim.log.levels.ERROR)
      return
    end

    -- Get base branch
    local base = vim.fn.system("gh pr view " .. pr_number .. " --json baseRefName -q .baseRefName 2>/dev/null")
    base = vim.trim(base)
    if vim.v.shell_error ~= 0 or base == "" then
      vim.notify("Failed to get base branch", vim.log.levels.ERROR)
      return
    end

    -- Open in Diffview (use .. not ... to match GitHub's comparison)
    vim.cmd("DiffviewOpen " .. base .. ".." .. branch)
    vim.notify("Viewing PR #" .. pr_number .. " (" .. base .. ".." .. branch .. ")", vim.log.levels.INFO)
  end)
end

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
      -- View PR in Diffview
      {
        "<leader>gdp",
        view_pr_in_diffview,
        desc = "Diff: View PR",
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
