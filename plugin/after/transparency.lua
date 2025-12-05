-- transparent background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })

-- transparent background for neotree
vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeStatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "NeoTreeStatusLineNC", { bg = "none" })

-- transparent background for nvim-tree
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

-- transparent notify background
vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyINFOTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyERRORTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyWARNTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyTRACETitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyINFOBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyERRORBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyWARNBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { bg = "none" })

-- Disable underlines entirely (they extend to end of line in terminals)
-- Use subtle background highlight instead which only affects actual error text
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", {})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", {})

-- Very subtle background colors for diagnostics (only on error text, not full line)
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#f38ba8", bg = "#2d1f1f" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#f9e2af", bg = "#2d2a1f" })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#89dceb", bg = "#1f2a2d" })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#a6adc8", bg = "#252525" })

-- Configure diagnostics: disable underline, use signs + hover
vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  signs = true,
  float = {
    border = "rounded",
    source = "always",
  },
  severity_sort = true,
  update_in_insert = false,
})

-- Git diff highlights with blend (see syntax colors through diff background)
-- Dynamically uses theme colors and reapplies on colorscheme change
local function get_hl_bg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl.bg and string.format("#%06x", hl.bg) or nil
end

local function apply_diff_blend()
  local add_bg = get_hl_bg("DiffAdd") or "#2d4f2d"
  local del_bg = get_hl_bg("DiffDelete") or "#4f2d2d"
  local chg_bg = get_hl_bg("DiffChange") or "#4f4f2d"

  vim.api.nvim_set_hl(0, "DiffAdd", { bg = add_bg, blend = 30 })
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = del_bg, blend = 30 })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = chg_bg, blend = 30 })
  vim.api.nvim_set_hl(0, "DiffText", { bg = chg_bg, blend = 20 })

  -- Diffview-specific overrides
  vim.api.nvim_set_hl(0, "DiffviewDiffAdd", { bg = add_bg, blend = 30 })
  vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = del_bg, blend = 30 })
  vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = chg_bg, blend = 30 })
end

-- Apply on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.defer_fn(apply_diff_blend, 10)
  end,
})

-- Apply now
apply_diff_blend()
vim.opt.fillchars:append("diff:=")
