# cobalt-neon.nvim

A Neovim colorscheme plugin based on the Cobalt Neon iTerm palette, with corrected ANSI semantics.

## Architecture

**Standalone plugin** following the gruvbox.nvim pattern (single Lua file, no dependencies).

```
cobalt-neon.nvim/
├── colors/cobalt-neon.lua    # Entry: require("cobalt-neon").load()
├── lua/cobalt-neon.lua       # Main module (~900 lines)
├── .cloned-sources/          # Reference implementations (gruvbox.nvim, cobalt.nvim, nightfox.nvim)
└── .beads/                   # Issue tracking
```

## Key Reference Files

When adding highlight groups, use these as reference:

- `.cloned-sources/gruvbox.nvim/lua/gruvbox.lua` - Primary structural pattern
- `.cloned-sources/cobalt.nvim/lua/cobalt/highlights/plugins.lua` - Plugin highlight examples
- `.cloned-sources/nightfox.nvim/lua/nightfox/group/modules/` - Comprehensive plugin modules

## Configuration API

```lua
require("cobalt-neon").setup({
  terminal_colors = true,   -- Set terminal ANSI colors
  transparent_mode = false, -- Transparent background
  dim_inactive = false,     -- Dim inactive windows
  undercurl = true,         -- Use undercurl for diagnostics
  underline = true,         -- Use underline styling
  bold = true,              -- Use bold styling
  italic = {
    strings = false,
    comments = true,
    keywords = false,
    functions = false,
    variables = false,
  },
  palette_overrides = {},   -- Override specific colors
  overrides = {},           -- Override specific highlight groups
})
```

## Plugin Support

Core:
- Vim highlight groups, syntax, LSP diagnostics, Treesitter, LSP semantic tokens

Plugins:
- Telescope, Gitsigns, Neogit, Neo-tree, Which-key, Trouble, Todo-comments
- Blink.cmp, nvim-cmp (compatibility)
- Mini.nvim (statusline, diff, icons, indentscope, cursorword, files, pick)
- Snacks.nvim (picker, indent)
- Diffview, TreesitterContext, Copilot
- Mason, Illuminate, RainbowDelimiters

## Adding Highlight Groups

1. Find the reference in `.cloned-sources/` (gruvbox.nvim or nightfox.nvim usually have it)
2. Add groups to the `groups` table in `lua/cobalt-neon.lua` (around line 700+)
3. Use existing `CobaltNeon*` linking groups where appropriate
4. Test by reloading: `:source $MYVIMRC` or restart Neovim

Run `bd ready` to see current work items.
