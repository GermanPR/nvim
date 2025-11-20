-- ============================================================================
-- Quickfix Management
-- ============================================================================
--
-- Keymaps:
-- <leader>xq - Toggle quickfix list (Snacks picker)
-- <leader>xa - Add/remove current location to/from quickfix list
--
-- ============================================================================

return {
  {
    "folke/snacks.nvim",
    keys = {
      -- Override LazyVim's default <leader>xq to use Snacks picker
      {
        "<leader>xq",
        function()
          require("snacks").picker.qflist()
        end,
        desc = "Quickfix List (Snacks)",
      },
      -- Add/remove current location to/from quickfix list (toggle)
      {
        "<leader>xa",
        function()
          local filename = vim.fn.expand("%:p")
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          local text = vim.fn.getline(".")

          -- Skip special buffers
          if vim.bo.buftype ~= "" or filename == "" then
            vim.notify("Not a regular file buffer", vim.log.levels.WARN)
            return
          end

          -- Get current quickfix list
          local qflist = vim.fn.getqflist()

          -- Check if current location already exists in quickfix
          local found_idx = nil
          for idx, item in ipairs(qflist) do
            if item.bufnr == vim.fn.bufnr() and item.lnum == line then
              found_idx = idx
              break
            end
          end

          if found_idx then
            -- Remove from quickfix list
            table.remove(qflist, found_idx)
            vim.fn.setqflist(qflist, "r") -- 'r' = replace entire list
            vim.notify("Removed from quickfix: " .. filename .. ":" .. line, vim.log.levels.INFO)
          else
            -- Add to quickfix list
            vim.fn.setqflist({
              {
                bufnr = vim.fn.bufnr(),
                filename = filename,
                lnum = line,
                col = col,
                text = text,
              },
            }, "a") -- 'a' = append to existing quickfix list
            vim.notify("Added to quickfix: " .. filename .. ":" .. line, vim.log.levels.INFO)
          end

          -- Show quickfix count in message
          local count = #vim.fn.getqflist()
          if count > 0 then
            vim.notify(string.format("Quickfix list: %d item%s", count, count == 1 and "" or "s"), vim.log.levels.INFO)
          end
        end,
        desc = "Add/remove location to/from quickfix",
      },
    },
  },
}
