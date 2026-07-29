--- quate.nvim configuration
---
--- The attribute switches mirror gruvbox's `g:gruvbox_*` options, since quate
--- borrows its text manipulations (and nothing else) from gruvbox.

local M = {}

---@class QuateConfig
local defaults = {
  --- gruvbox `g:gruvbox_bold`
  bold = true,
  --- gruvbox `g:gruvbox_italic` -- master switch for every italic below
  italic = true,
  --- gruvbox `g:gruvbox_italicize_comments`
  italic_comments = true,
  --- gruvbox `g:gruvbox_italicize_strings`
  italic_strings = false,
  --- gruvbox italicizes folds
  italic_folds = true,
  --- not a gruvbox default; off unless you want slanted keywords
  italic_keywords = false,
  --- gruvbox `g:gruvbox_underline`
  underline = true,
  --- gruvbox `g:gruvbox_undercurl`
  undercurl = true,
  --- gruvbox `g:gruvbox_inverse` -- reverse video for Search/Error/Todo
  inverse = true,

  --- monoglow's `glow`. Stops rationing the accent: swaps the soft mint for
  --- monoglow's electric one, hands it to operators, bolds identifiers along
  --- with the functions and keywords, and lights search and the completion
  --- selection as a solid block instead of reverse video.
  glow = false,

  --- clear the background of Normal & friends
  transparent = false,
  --- dim unfocused windows
  dim_inactive = false,
  --- set g:terminal_color_{0..15} to the mint/gray ramp
  terminal_colors = true,

  ---@type table<string, table> highlight groups merged over the defaults
  overrides = {},
  --- last word on highlights; mutate `groups` in place
  ---@type fun(groups: table, palette: table)|nil
  on_highlights = nil,
}

M.options = vim.deepcopy(defaults)

M.defaults = defaults

---@param opts QuateConfig|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.options, opts or {})
  return M.options
end

return M
