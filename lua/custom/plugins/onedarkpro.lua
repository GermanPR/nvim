return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	config = function()
		require("onedarkpro").setup({
			colors = {
				onedark = {
					bg = "#1c1f36",
				},
			},
		})
		vim.cmd("colorscheme onedark")
	end,
}
