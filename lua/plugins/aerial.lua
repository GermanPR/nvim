return {
  "stevearc/aerial.nvim",
  event = "LazyFile",
  opts = {
    -- Position on the right side
    placement = "edge",
    layout = {
      default_direction = "prefer_right",
      placement = "edge",
      width = 30,
    },
    -- Automatically open aerial when entering a buffer
    open_automatic = false,
    -- Show line numbers in aerial window
    show_guides = true,
    -- Filter to show only classes and functions by default
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Method",
      "Struct",
    },
    -- Nice icons for different symbol types
    icons = {
      Array = "󰅪 ",
      Boolean = "󰨙 ",
      Class = "󰠱 ",
      Constant = "󰏿 ",
      Constructor = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = "󰈙 ",
      Function = "󰊕 ",
      Interface = " ",
      Key = "󰌋 ",
      Method = "󰆧 ",
      Module = " ",
      Namespace = "󰌗 ",
      Null = "󰟢 ",
      Number = "󰎠 ",
      Object = "󰅩 ",
      Operator = "󰆕 ",
      Package = " ",
      Property = "󰜢 ",
      String = "󰀬 ",
      Struct = "󰙅 ",
      TypeParameter = "󰊄 ",
      Variable = "󰀫 ",
    },
  },
  keys = {
    { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Toggle Outline (Aerial)" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
