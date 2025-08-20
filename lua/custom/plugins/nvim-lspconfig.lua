return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")

		-- Keymaps & niceties on attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gh", vim.lsp.buf.hover, "[G]oto [H]over")
				map("<C-k>", vim.lsp.buf.signature_help, "Show signature help", "i")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]earch [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- Unify position encodings to avoid the warning
		capabilities.offsetEncoding = { "utf-16" }

		-- Helper: prefer .venv binaries (uv-managed)
		local function venv_bin(exe)
			local root = util.root_pattern("pyrightconfig.json", "pyproject.toml", ".git")(vim.loop.cwd())
				or vim.loop.cwd()
			local sep = package.config:sub(1, 1)
			local bin = (vim.fn.has("win32") == 1) and "Scripts" or "bin"
			local ext = (vim.fn.has("win32") == 1) and ".exe" or ""
			return table.concat({ root, ".venv", bin, exe .. ext }, sep)
		end
		local function prefer_venv_cmd(exe, args_if_global)
			local v = venv_bin(exe)
			if vim.fn.executable(v) == 1 then
				return { v, unpack(args_if_global or {}) }
			end
			if vim.fn.executable(exe) == 1 then
				return { exe, unpack(args_if_global or {}) }
			end
			return nil
		end
		local function ruff_cmd()
			-- Prefer ruff's built-in LSP: `ruff server`; fall back to ruff-lsp if needed
			local vruff = venv_bin("ruff")
			if vim.fn.executable(vruff) == 1 then
				return { vruff, "server" }
			end
			local vrufflsp = venv_bin("ruff-lsp")
			if vim.fn.executable(vrufflsp) == 1 then
				return { vrufflsp }
			end
			if vim.fn.executable("ruff") == 1 then
				return { "ruff", "server" }
			end
			if vim.fn.executable("ruff-lsp") == 1 then
				return { "ruff-lsp" }
			end
			return nil
		end

		-- Servers we want (no pylsp)
		local servers = {
			["rust-analyzer"] = {
				settings = { checkOnSave = { command = "clippy" } },
			},
			lua_ls = {
				settings = { Lua = { completion = { callSnippet = "Replace" } } },
			},
			basedpyright = {
				cmd = prefer_venv_cmd("basedpyright-langserver", { "--stdio" }),
				root_dir = util.root_pattern("pyrightconfig.json", "pyproject.toml", ".git"),
				settings = {
					-- Keep analysis minimal here; let pyrightconfig.json drive most behavior
					basedpyright = {
						analysis = {
							diagnosticMode = "workspace",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
						-- Let Ruff handle import organizes/fixes
						disableOrganizeImports = true,
					},
				},
			},
			ruff = {
				cmd = ruff_cmd(),
				root_dir = util.root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git"),
				init_options = {
					settings = { args = {} }, -- override with CLI args if you really need to
				},
			},
		}

		-- Mason: keep defaults (don’t override install_root_dir; better for WSL)
		require("mason").setup()

		-- Install a minimal set; we manage Python tools in .venv via uv
		local ensure_installed = { "rust-analyzer", "lua_ls" }
		-- If you still want Mason copies of Python LSPs as a fallback, uncomment:
		vim.list_extend(ensure_installed, { "basedpyright", "ruff" })

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
			handlers = {
				-- Skip pylsp if it happens to be installed
				function(server_name)
					if server_name == "pylsp" then
						return
					end

					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

					-- If we defined a custom setup above, use it; otherwise default
					lspconfig[server_name].setup(server)
				end,

				-- Explicit handlers for our Python stack (ensure .venv binaries are used)
				["basedpyright"] = function()
					local server = servers.basedpyright
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					lspconfig.basedpyright.setup(server)
				end,
				["ruff"] = function()
					local server = servers.ruff
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					lspconfig.ruff.setup(server)
				end,
			},
		})
	end,
}
