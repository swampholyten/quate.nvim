# quate.nvim

A quiet colorscheme for Neovim.

Vim's built-in [`quiet`](https://github.com/vim/colorschemes) for the greys and
the group structure, [gruvbox](https://github.com/morhetz/gruvbox) for the text
manipulations — italics and bolds, nothing else — and mint for the glow.

There is exactly one hue in the whole theme.

```lua
{ 'quate.nvim', lazy = false, priority = 1000, config = function()
  vim.cmd.colorscheme('quate')
end }
```

Dark only — `background` is pinned to `dark`, and quate reasserts it if something
flips it.

## The idea

`quiet` is almost monochrome on purpose: syntax is one flat foreground, and the
few colours it owns appear only as reverse video. That flatness is the point,
but it leaves nothing to tell a function from a keyword.

gruvbox already solved that half of the problem with attributes rather than
colour — italic comments, bold callables — so quate takes those and only those:

| | |
|---|---|
| **italic** | comments, folds, doc strings, builtins, deprecated/unnecessary hints, `Todo` |
| **bold** | functions, constructors, keywords & statements, storage classes, types-as-structure, titles, directories, tags, headings |
| **plain** | constants, strings, numbers, identifiers, properties, operators, delimiters |

Strings are upright by default, as in gruvbox; `italic_strings = true` slants
them.

### The glow

Mint is the only chroma, and it is spent sparingly — on the things that are
genuinely asking for your eye:

`Special` and escape sequences · `Todo` and `@comment.note` · `MatchParen` ·
`CursorLineNr` · search and substitute · the completion selection and its fuzzy
matches · `DiagnosticOk` · git additions · `ModeMsg` · list markers and `h1`.

| | quiet | `glow = true` |
|---|---|---|
| `mint_dim` | `#5faf87` | `#00d7af` |
| `mint` | `#87d7af` | `#1bfd9c` |
| `mint_hi` | `#afffd7` | `#87ffd7` |

### `glow = true`

Borrowed from [monoglow.nvim](https://github.com/wnkz/monoglow.nvim), whose own
`glow` option bolds the callable things and hands its accent to the operators.
Turning it on in quate stops rationing the mint:

- the accent swaps to monoglow's electric `#1bfd9c` (its cterm fallback, 49, is
  the mint `quiet` already reserved for `Todo`)
- operators take the accent, and bold
- identifiers join the bolded set, alongside functions and keywords
- search and the completion selection become a lit block rather than reverse
  video

Off by default — quate's resting state is the quiet one.

### No second hue

Because mint is the whole budget, the places that normally reach for red and
green express themselves differently:

- **Diagnostics** grade by weight and underline style — error is bright and
  bold under an undercurl, warning is dimmer under a dash, info and hint fade
  into dotted greys. Only `Ok` is mint.
- **Diffs** glow or fade: an addition is a mint-tinted background, a deletion is
  a darker block with its text dimmed toward the background, a change sits
  between them.
- **Errors** use reverse video and bold, the way `quiet` does.

If you want a red back for errors, that is what `overrides` is for.

## Options

Calling `setup()` is optional. The attribute switches deliberately mirror
gruvbox's `g:gruvbox_*` names.

```lua
require('quate').setup({
  bold = true,             -- g:gruvbox_bold
  italic = true,           -- g:gruvbox_italic; master switch for the italics below
  italic_comments = true,  -- g:gruvbox_italicize_comments
  italic_strings = false,  -- g:gruvbox_italicize_strings
  italic_folds = true,
  italic_keywords = false,
  underline = true,        -- g:gruvbox_underline
  undercurl = true,        -- g:gruvbox_undercurl
  inverse = true,          -- g:gruvbox_inverse; reverse video for Search/Error/Todo

  glow = false,            -- monoglow's `glow`; see above

  transparent = false,     -- clear the background of Normal & friends
  dim_inactive = false,    -- dim unfocused windows
  terminal_colors = true,  -- g:terminal_color_{0..15} on the mint/grey ramp

  overrides = {},          -- merged over the defaults
  on_highlights = nil,     -- function(groups, palette) -- last word
})
vim.cmd.colorscheme('quate')
```

`overrides` is merged per group, so a partial spec keeps the rest:

```lua
overrides = {
  Comment = { fg = { '#5f5f5f', 59 } },   -- { gui, cterm }
  Visual = { bg = { '#3a3a3a', 237 } },
}
```

`on_highlights(groups, palette)` runs after the merge and can mutate anything:

```lua
on_highlights = function(groups, p)
  groups.DiagnosticError = { fg = { '#d75f5f', 167 }, bold = true }
  groups['@keyword'] = { fg = p.fg, italic = true }
end,
```

## Terminals

Every grey sits on the xterm-256 colour cube and carries its `cterm` index, so
the 256-colour fallback is exact rather than approximated. `termguicolors` is
recommended but not required, and quate never sets it for you.

## Extras

`lualine` — a grey bar where the mode indicator is the only mint:

```lua
require('lualine').setup({ options = { theme = 'quate' } })
```

The palette is available if you are building your own statusline:

```lua
local p = require('quate').palette()  -- p.mint == { '#87d7af', 115 }, or the
                                      -- electric ramp when glow is on
```

## Credits

- **quiet** by Maxence Weynans, shipped with Vim/Neovim under the Vim License —
  the greys, the group structure, and the restraint.
- **gruvbox** by Pavel Pertsev (MIT) — the bold/italic conventions and the names
  of the switches that control them.

quate is an independent derivative of both and is not affiliated with either.
