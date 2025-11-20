# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a LazyVim-based Neovim configuration with custom extensions for:
- Spanish keyboard optimization
- Advanced theme hot-reload system
- Transparency-first UI aesthetic
- Minimal custom code on top of LazyVim defaults

## Architecture

### Initialization Flow

1. `init.lua` → bootstraps lazy.nvim
2. `lua/config/lazy.lua` → initializes lazy.nvim, loads LazyVim framework + local plugin specs
3. LazyVim loads core plugins (LSP, completion, treesitter, etc.)
4. Custom plugins from `lua/plugins/*.lua` are loaded
5. `plugin/after/transparency.lua` applies post-load UI customizations

### Directory Structure

```
lua/
├── config/
│   ├── lazy.lua      # Lazy.nvim bootstrap and plugin manager setup
│   ├── options.lua   # Global Neovim settings (extends LazyVim defaults)
│   ├── keymaps.lua   # Custom keybindings (Spanish keyboard support)
│   └── autocmds.lua  # Autocommands (Harpoon integration on startup)
└── plugins/          # Plugin specifications (18 files total)
    ├── all-themes.lua                     # Collection of 11 colorscheme plugins (lazy-loaded)
    ├── omarchy-theme-hotreload.lua        # Custom theme hot-reload system
    ├── snacks-picker.lua                  # Snacks picker configuration (UNIFIED PICKER SYSTEM)
    ├── snacks-animated-scrolling-off.lua  # Disable scrolling animations
    ├── example.lua                        # Example plugin patterns (disabled)
    ├── lsp-hover.lua                      # LSP hover keybinding (gh)
    ├── harpoon.lua                        # File navigation marks system
    ├── file-utils.lua                     # Gitsigns blame + file path utilities
    ├── neo-tree.lua                       # File explorer configuration
    ├── disable-bufferline.lua             # Disable bufferline plugin
    ├── lualine.lua                        # Custom statusline (moved to tabline)
    ├── typescript-lsp.lua                 # TypeScript/JavaScript LSP servers (vtsls, eslint, tailwindcss)
    ├── treesitter-typescript.lua          # TypeScript/TSX parser installation
    ├── formatter-typescript.lua           # Prettier/Prettierd formatter config
    ├── mason-typescript.lua               # TypeScript tools installation (Mason)
    ├── json-schemas.lua                   # JSON schema store for package.json, tsconfig.json
    └── python-lsp.lua                     # Python LSP servers (ruff, basedpyright)

plugin/
└── after/
    └── transparency.lua  # Post-initialization highlight overrides for transparent background (50+ groups)
```

### Plugin Management

- **Manager**: lazy.nvim (stable branch)
- **Bootstrap location**: `~/.local/share/nvim/lazy/lazy.nvim`
- **Plugin data**: `~/.local/share/nvim/lazy/`
- **Lock file**: `lazy-lock.json` (tracks exact commit hashes for 45+ plugins)

### Key Systems

#### Theme Hot-Reload System

**Location**: `lua/plugins/omarchy-theme-hotreload.lua`

Custom local plugin that enables seamless theme switching without restarting Neovim:
- Triggers on `LazyReload` user events (`:LazyReload` command)
- Unloads theme modules from Lua package cache
- Clears all highlights and resets background
- Walks plugin directory tree to unload all theme submodules
- Reapplies colorscheme with proper background detection
- Reloads transparency settings
- Triggers dependent plugin updates via autocmds

**Usage**: After editing a theme file, run `:LazyReload` to see changes immediately.

#### Snacks Picker System (UNIFIED PICKER)

**Location**: `lua/plugins/snacks-picker.lua`

Snacks picker (LazyVim's default) is configured as the unified picker for all file navigation:
- **Layout**: Horizontal (87% width, 80% height), search bar at top, results below
- **Path display**: Configurable via `show_absolute_paths` variable (line 23)
  - `true` = Full/absolute paths (large min_width to prevent truncation)
  - `false` = Smart truncated paths (relative to CWD, `~/` for home, `⋮repo/` for git)
- **Preview**: Shows full file path in window title (custom preview function)
- **All pickers use Snacks**: `<leader>ff`, `<leader>sg`, `<C-p>`, and all LazyVim picker commands

**How to change path display**: Edit line 23 in `snacks-picker.lua` and toggle `show_absolute_paths` between `true`/`false`.

#### Transparency System

**Location**: `plugin/after/transparency.lua`

Sets transparent background for 45+ highlight groups covering:
- Editor UI (Normal, NormalFloat, Pmenu, StatusLine, etc.)
- Tree views (NeoTree, NvimTree)
- Notifications (Notify*)
- Borders (FloatBorder, etc.)

Runs after colorscheme application to override default backgrounds.

#### Keymaps

**Location**: `lua/config/keymaps.lua`

Custom mappings optimized for Spanish keyboard:
- `K`/`J` → Navigate 7 lines up/down
- `ñ`/`Ñ` → Forward/backward search (`/`, `?`)
- `<leader>ñ` → Search word under cursor (`*`)
- `<Tab>`/`<S-Tab>` → Indent/unindent (works in normal and visual mode)

File picker:
- `<C-p>` → Find files (Snacks picker, same as `<leader>ff`)

Additional custom keymaps:
- `<leader>rk` → Reload config (unloads and reloads config modules + options + autocmds)
- `<leader>yp` → Copy file path (relative path to clipboard)
- `<leader>r` → Replace word under cursor (pre-populates substitute command)
- `<leader>uh` → Toggle LSP inlay hints
- `<leader>bx` → Clean buffers (close all buffers and delete swap files)
- `<C-j>` → Jump forward (Ctrl-i alternative for terminals that block Ctrl-i)
- `<leader>j` → Join lines below with current line

Harpoon keymaps (from `lua/plugins/harpoon.lua`):
- `<leader>a` → Add file to harpoon
- `<leader>m` → Open harpoon menu
- `<leader>l` → Navigate to previous harpoon file
- `<leader>1-4` → Navigate to harpoon file 1-4

File utilities (from `lua/plugins/file-utils.lua`):
- `<leader>gb` → Git blame current line (gitsigns)
- `<leader>fyr` → Yank relative file path
- `<leader>fya` → Yank absolute file path
- `<leader>fyn` → Yank filename only

**Pattern**: Imports LazyVim's LSP keymap defaults, then extends/overrides.

## Common Commands

### Plugin Management

```vim
:Lazy                  " Open lazy.nvim UI
:Lazy update          " Update all plugins
:Lazy sync            " Install missing plugins and update
:Lazy clean           " Remove unused plugins
:Lazy restore         " Restore plugins to lazy-lock.json versions
:LazyReload           " Reload theme (custom command from hot-reload system)
```

### LSP/Development

```vim
:Mason                " Open Mason UI (LSP server/tool installer)
:LspInfo              " Show LSP client status
:ConformInfo          " Show formatter status (conform.nvim)
:checkhealth          " Run Neovim health checks
```

### File Navigation

```vim
<leader>ff            " Find files (Snacks picker)
<C-p>                 " Find files (Snacks picker, same as <leader>ff)
<leader>fg            " Live grep (Snacks picker)
<leader>e             " Toggle Neo-tree file explorer

" Harpoon navigation
<leader>a             " Add current file to harpoon
<leader>m             " Open harpoon menu
<leader>l             " Navigate to previous harpoon file
<leader>1-4           " Navigate to harpoon file 1-4
```

### Code Formatting

```vim
:lua vim.lsp.buf.format()  " Format current buffer (or use <leader>cf in LazyVim)
```

## Development Workflow

### Adding New Plugins

1. Create a new file in `lua/plugins/` (e.g., `my-plugin.lua`)
2. Return a table with plugin spec(s):
   ```lua
   return {
     "username/plugin-name",
     opts = {
       -- configuration here
     },
   }
   ```
3. Restart Neovim or run `:Lazy sync`

### Modifying Existing Plugin Configs

LazyVim plugins can be overridden by creating a spec file in `lua/plugins/` that targets the same plugin name. **IMPORTANT**: Use the proper merge pattern to avoid replacing LazyVim's defaults:

```lua
-- CORRECT: Merges with LazyVim defaults
return {
  "plugin/name",
  opts = function(_, opts)
    opts.section = vim.tbl_deep_extend("force", opts.section or {}, {
      your_setting = "value",
    })
    return opts
  end,
}

-- INCORRECT: Replaces LazyVim defaults entirely
return {
  "plugin/name",
  opts = {
    your_setting = "value",  -- This wipes out all LazyVim's settings!
  },
}
```

See `lua/plugins/snacks-picker.lua` for a comprehensive example with detailed comments explaining this pattern.

### Editing Themes

1. Modify theme file in plugin directory (usually in `~/.local/share/nvim/lazy/<theme-name>/`)
2. Run `:LazyReload` to see changes immediately (thanks to hot-reload system)
3. No need to restart Neovim

### Code Formatting Rules

- **Lua**: Formatted with stylua (config in `stylua.toml`)
  - 2-space indentation
  - 120-column width
  - Run: `stylua .` from config root

## Language Support

### TypeScript/JavaScript

**LSP Servers** (configured in `lua/plugins/typescript-lsp.lua`):
- **vtsls**: Vercel's faster TypeScript server with inlay hints for parameters and types
- **eslint-lsp**: With flat config support
- **tailwindcss-language-server**: With CVA/cx classRegex patterns for Tailwind class completion

**Formatting** (configured in `lua/plugins/formatter-typescript.lua`):
- **prettierd** (daemon for speed) + **prettier** fallback
- Auto-formats on save via conform.nvim
- Filetypes: ts, tsx, js, jsx, json, jsonc, css, scss, html

**Treesitter** (configured in `lua/plugins/treesitter-typescript.lua`):
- Parsers: typescript, tsx, javascript, jsdoc, json, jsonc, css, scss, html

**Mason Tools** (auto-installed via `lua/plugins/mason-typescript.lua`):
- typescript-language-server, vtsls, eslint-lsp, prettierd, tailwindcss-language-server, json-lsp

### Python

**LSP Servers** (configured in `lua/plugins/python-lsp.lua`):
- **ruff**: Linting and formatting
- **basedpyright**: Type checking
  - Configured to use Poetry virtualenvs at `.venv/bin/python`
  - Diagnostic mode: `openFilesOnly` (performance optimization)
  - Excludes venv directories from analysis

### JSON

**LSP Server** (configured in `lua/plugins/json-schemas.lua`):
- **jsonls** with full schemastore.nvim integration
- Auto-validation for package.json, tsconfig.json, and other known JSON formats

### Lua

**LSP Server**: lua_ls (via LazyVim)
- Configured in `.neoconf.json` with lazydev and plugin support
- Neovim API completions enabled

### Other Languages

Check `:Mason` for additional servers. LazyVim auto-installs LSP servers based on filetypes.

**Treesitter parsers** (LazyVim core): bash, html, javascript, json, lua, markdown, python, tsx, typescript, vim, yaml

## Configuration Details

### LazyVim Extras

Installed extras (tracked in `lazyvim.json`):
- `lazyvim.plugins.extras.editor.neo-tree`

### Global Options

**Location**: `lua/config/options.lua`

Key settings:
- `relativenumber = false` → Absolute line numbers
- `laststatus = 0` → Disable bottom statusline (using tabline instead via lualine)
- `cmdheight = 0` → Hide command line when not in use

### Disabled Built-in Plugins

Performance optimization in `lua/config/lazy.lua`:
- gzip, tarPlugin, tohtml, tutor, zipPlugin

### LSP Configuration

**Location**: `.neoconf.json`

Enables:
- `lazydev` library for Neovim API development
- `lua_ls` plugin support

## File Locations

- **Config root**: `/home/germanpr/.config/nvim/`
- **Data directory**: `~/.local/share/nvim/`
- **Plugin installation**: `~/.local/share/nvim/lazy/`
- **State directory**: `~/.local/state/nvim/`

## Important Notes

- **Custom plugins load eagerly** (lazy = false) while LazyVim plugins are lazy-loaded
- **Version pinning**: Uses latest git commits (version = false), locked via lazy-lock.json
- **Plugin updates**: Checker enabled but notifications disabled
- **Colorscheme fallback**: tokyonight → habamax if theme fails to load
- **Spanish keyboard**: Many custom keybindings assume Spanish keyboard layout

## Extending This Config

When adding features:
1. Check if LazyVim already provides it (see [LazyVim docs](https://lazyvim.github.io))
2. **Override LazyVim defaults via plugin specs rather than replacing** (use `opts = function(_, opts)` pattern)
3. Keep custom code minimal - leverage LazyVim's curated plugin collection
4. Use `lua/plugins/` for plugin specifications
5. Use `plugin/after/` for post-load customizations
6. Update `lazy-lock.json` after plugin changes for reproducibility

## Special Features

### Harpoon Integration

Harpoon provides fast file navigation with numbered marks:
- Auto-navigates to first harpoon file on startup (if no files specified on command line)
- Configured in `lua/plugins/harpoon.lua` and `lua/config/autocmds.lua`

### Snacks Picker Configuration (Unified System)

Snacks picker is configured as the unified picker for ALL file navigation operations:
- **Path display**: Configurable via `show_absolute_paths` variable in `snacks-picker.lua:23`
  - Toggle between full/absolute paths or smart truncated paths
- **Custom layout**: Horizontal (87% width, 80% height), search bar at top, results flow top-to-bottom
- **Preview window**: Shows complete file path in title (custom preview function)
- **Unified experience**: All LazyVim picker keymaps (`<leader>ff`, `<leader>sg`, `<C-p>`) use the same configuration
- See `lua/plugins/snacks-picker.lua` for detailed configuration and merge pattern documentation

### Lualine Customization

Statusline moved to tabline (top of screen) instead of bottom:
- Bottom statusline disabled (`laststatus = 0`)
- All content (mode, branch, diagnostics, etc.) shown in top tabline
- Minimal aesthetic consistent with transparency theme
- Configured in `lua/plugins/lualine.lua`

### UI Aesthetic

Configuration emphasizes minimal, transparent UI:
- Transparent backgrounds for 50+ highlight groups
- No bufferline (disabled in `lua/plugins/disable-bufferline.lua`)
- No bottom statusline (content moved to tabline)
- Command line hidden when not in use (`cmdheight = 0`)
- Scrolling animations disabled
