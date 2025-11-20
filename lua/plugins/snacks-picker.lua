-- ============================================================================
-- Snacks Picker Configuration - Unified Picker System
-- ============================================================================
--
-- This configures Snacks picker (LazyVim's default) to match the layout and
-- path display preferences previously used with Telescope.
--
-- UNIFIED APPROACH:
-- - All pickers (<leader>ff, <leader>sg, <C-p>, etc.) use Snacks
-- - Consistent layout across all picker types
-- - Configurable path display via single variable
--
-- ============================================================================

return {
  "folke/snacks.nvim",
  keys = {
    -- Disable <leader>gp to avoid conflict with octo.nvim
    { "<leader>gp", false },
    { "<leader>gP", false },
  },
  opts = function(_, opts)
    -- ========================================================================
    -- CONFIGURATION VARIABLE - Change this to toggle path display mode
    -- ========================================================================
    -- true  = Show full/absolute paths (large min_width to avoid truncation)
    -- false = Show smart truncated paths (Snacks default behavior)
    local show_absolute_paths = false
    -- ========================================================================

    -- Ensure picker table exists
    opts.picker = opts.picker or {}

    -- Configure path display formatters
    opts.picker.formatters = vim.tbl_deep_extend("force", opts.picker.formatters or {}, {
      file = {
        filename_only = false, -- Show full path, not just filename
        filename_first = false, -- Path comes before filename (standard order)
        truncate = show_absolute_paths and "right" or "center", -- Truncate from right for absolute-like paths
        min_width = show_absolute_paths and 200 or 40, -- Large value prevents truncation
      },
    })

    -- Custom preview function to show full path in title (not just filename)
    opts.picker.preview = function(ctx)
      -- Call the default file previewer
      Snacks.picker.preview.file(ctx)

      -- Override the title with full path instead of just filename
      local path = Snacks.picker.util.path(ctx.item)
      if path then
        ctx.preview:set_title(path)
      end
    end

    -- Configure layout to match Telescope setup (87% width, 80% height, horizontal, prompt at top)
    opts.picker.layout = vim.tbl_deep_extend("force", opts.picker.layout or {}, {
      layout = {
        box = "horizontal",
        backdrop = false,
        width = 0.87, -- Match Telescope width
        height = 0.80, -- Match Telescope height
        border = "none",
        -- Left side: Search bar on top, results list below
        {
          box = "vertical",
          {
            win = "input",
            height = 1,
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
          { win = "list", title = " Results ", title_pos = "center", border = true },
        },
        -- Right side: Preview window (shows full path in title)
        {
          win = "preview",
          title = "{preview}",
          width = 0.55, -- Match Telescope preview_width
          border = true,
          title_pos = "center",
        },
      },
      reverse = false, -- Results flow top-to-bottom (most relevant at top)
    })

    -- Add Tab/Shift-Tab navigation like lazygit
    opts.picker.win = vim.tbl_deep_extend("force", opts.picker.win or {}, {
      input = {
        keys = {
          ["<Tab>"] = { "focus_preview", mode = { "n", "i" } },
          ["<S-Tab>"] = { "focus_input", mode = { "n", "i" } },
        },
      },
      list = {
        keys = {
          ["<Tab>"] = "focus_preview",
          ["<S-Tab>"] = "focus_input",
        },
      },
      preview = {
        keys = {
          ["<Tab>"] = "focus_input",
          ["<S-Tab>"] = "focus_list",
        },
      },
    })

    return opts
  end,
}
