return {
  -- Configure gitsigns for git blame toggle
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<leader>gb",
        "<cmd>Gitsigns toggle_current_line_blame<cr>",
        desc = "Toggle Git Blame",
      },
    },
    opts = {
      current_line_blame = false, -- Start with blame disabled
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    },
  },

  -- Override Snacks git diff to allow branch selection
  {
    "folke/snacks.nvim",
    keys = {
      -- Disable the default <leader>gD keybinding
      { "<leader>gD", false },
    },
  },

  -- Add custom git diff with branch selection
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gdb",
        function()
          -- Get list of all branches (local and remote)
          local branches = vim.fn.systemlist("git branch -a --format='%(refname:short)'")

          -- Clean up remote branch names and remove duplicates
          local seen = {}
          local clean_branches = {}
          for _, branch in ipairs(branches) do
            -- Remove "remotes/" prefix and clean up
            local clean = branch:gsub("^remotes/", "")
            if not seen[clean] and clean ~= "" then
              seen[clean] = true
              table.insert(clean_branches, clean)
            end
          end

          -- Sort branches: current branch first, then alphabetically
          local current_branch = vim.fn.systemlist("git branch --show-current")[1]
          table.sort(clean_branches, function(a, b)
            if a == current_branch then
              return true
            end
            if b == current_branch then
              return false
            end
            return a < b
          end)

          -- Show picker to select branch
          vim.ui.select(clean_branches, {
            prompt = "Select branch to diff against:",
            format_item = function(branch)
              if branch == current_branch then
                return branch .. " (current)"
              end
              return branch
            end,
          }, function(selected)
            if selected then
              -- Use diffview to show side-by-side diff against selected branch
              -- Using three-dot syntax to show only changes in current branch (like GitHub PRs)
              vim.cmd("DiffviewOpen " .. selected .. "...HEAD")
            end
          end)
        end,
        desc = "Diff: vs Branch",
      },
    },
  },

  -- File path utilities
  {
    "LazyVim/LazyVim",
    keys = {
      -- Copy relative path from project root
      {
        "<leader>fyr",
        function()
          local path = vim.fn.expand("%:.")
          vim.fn.setreg("+", path)
          vim.notify('Copied relative path: "' .. path .. '"', vim.log.levels.INFO)
        end,
        desc = "Copy Relative Path",
      },
      -- Copy absolute path
      {
        "<leader>fya",
        function()
          local path = vim.fn.expand("%:p")
          vim.fn.setreg("+", path)
          vim.notify('Copied absolute path: "' .. path .. '"', vim.log.levels.INFO)
        end,
        desc = "Copy Absolute Path",
      },
      -- Copy filename only
      {
        "<leader>fyn",
        function()
          local path = vim.fn.expand("%:t")
          vim.fn.setreg("+", path)
          vim.notify('Copied filename: "' .. path .. '"', vim.log.levels.INFO)
        end,
        desc = "Copy Filename",
      },
    },
  },
}
