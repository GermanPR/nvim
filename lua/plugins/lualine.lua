return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options = opts.options or {}
    opts.options.globalstatus = true

    -- Clear bottom statusline
    opts.sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }
    opts.inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    }

    -- Move everything to top (tabline)
    opts.tabline = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    }

    return opts
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
    -- Ensure statusline is completely disabled after lualine loads
    vim.opt.laststatus = 0
  end,
}
