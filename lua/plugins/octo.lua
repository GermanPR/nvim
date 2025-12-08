local function get_current_pr_details()
  local output = vim.fn.system({ "gh", "pr", "view", "--json", "number,baseRepository" })
  if vim.v.shell_error ~= 0 then
    return
  end
  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" then
    return
  end
  local repo = decoded.baseRepository and decoded.baseRepository.nameWithOwner
  if not repo or repo == vim.NIL then
    return
  end
  local pr_number = decoded.number and tostring(decoded.number)
  if not pr_number or pr_number == "" then
    return
  end
  local owner, name = repo:match("^([^/]+)/(.+)$")
  if not owner or not name then
    return
  end
  return {
    number = pr_number,
    owner = owner,
    name = name,
  }
end

local function fetch_assignable_reviewers(owner, name)
  local query = [[
    query($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        assignableUsers(first: 100) {
          nodes {
            login
            name
          }
        }
      }
    }
  ]]
  query = query:gsub("\n", " ")
  local output = vim.fn.system({
    "gh",
    "api",
    "graphql",
    "-F",
    "owner=" .. owner,
    "-F",
    "name=" .. name,
    "-f",
    "query=" .. query,
  })
  if vim.v.shell_error ~= 0 then
    return nil, vim.trim(output)
  end
  local ok, decoded = pcall(vim.json.decode, output)
  if not ok then
    return nil, decoded
  end
  local nodes = (((decoded or {}).data or {}).repository or {}).assignableUsers
  nodes = nodes and nodes.nodes or {}
  return nodes, nil
end

local function request_reviewer()
  local pr = get_current_pr_details()
  if not pr then
    vim.notify("Not on a PR branch or unable to detect PR details", vim.log.levels.WARN)
    return
  end

  local reviewers, err = fetch_assignable_reviewers(pr.owner, pr.name)
  if not reviewers then
    vim.notify("Failed to load reviewers: " .. err, vim.log.levels.ERROR)
    return
  end
  if vim.tbl_isempty(reviewers) then
    vim.notify("Repository has no assignable reviewers", vim.log.levels.INFO)
    return
  end

  local ok, Snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("Snacks picker is required for reviewer selection", vim.log.levels.ERROR)
    return
  end

  local items = vim.tbl_map(function(user)
    local display = user.login or ""
    if user.name and user.name ~= "" then
      display = string.format("%s  (%s)", user.login, user.name)
    end
    return {
      login = user.login,
      name = user.name,
      text = display,
    }
  end, reviewers)

  Snacks.picker.pick({
    title = "Request Reviewer",
    items = items,
    format = function(item, _)
      local label = item.login or ""
      if item.name and item.name ~= "" then
        label = string.format("%s  (%s)", item.login, item.name)
      end
      return {
        { label, "Normal" },
      }
    end,
    confirm = function(picker, item)
      if not item or not item.login then
        return
      end
      picker:close()
      local output = vim.fn.system({
        "gh",
        "pr",
        "edit",
        pr.number,
        "--add-reviewer",
        item.login,
      })
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to request review: " .. vim.trim(output), vim.log.levels.ERROR)
        return
      end
      vim.notify(string.format("Requested review from @%s", item.login), vim.log.levels.INFO)
    end,
  })
end

return {
  -- octo.nvim - GitHub PR management (list, review, comment, approve)
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
      "folke/snacks.nvim", -- Reviewer picker UI
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
      {
        "<leader>gpA",
        request_reviewer,
        desc = "PR: Request Reviewer",
      },
      -- Checkout PR branch
      {
        "<leader>gpk",
        function()
          -- Try to get PR number from Octo buffer first
          local bufname = vim.api.nvim_buf_get_name(0)
          local pr_number = bufname:match("octo://[^/]+/[^/]+/(%d+)")

          -- If not in Octo buffer, try to get from current git branch
          if not pr_number then
            pr_number = vim.fn.system("gh pr view --json number -q .number 2>/dev/null")
            pr_number = vim.trim(pr_number)
            if vim.v.shell_error ~= 0 or pr_number == "" then
              pr_number = nil
            end
          end

          if not pr_number then
            vim.notify("Not viewing a PR in Octo or on a PR branch", vim.log.levels.WARN)
            return
          end

          vim.notify("Checking out PR #" .. pr_number .. "...", vim.log.levels.INFO)
          local output = vim.fn.system("gh pr checkout " .. pr_number .. " 2>&1")
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to checkout PR: " .. vim.trim(output), vim.log.levels.ERROR)
            return
          end
          vim.notify("Checked out PR #" .. pr_number, vim.log.levels.INFO)
          -- Reload buffers to reflect the branch change
          vim.cmd("checktime")
        end,
        desc = "PR: Checkout Branch",
      },
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
        picker = "telescope", -- Use telescope for Octo's built-in pickers
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
