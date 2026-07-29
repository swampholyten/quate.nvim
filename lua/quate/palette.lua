--- quate.nvim palette
---
--- Every colour is a `{ gui, cterm }` pair. The greys are lifted from Vim's
--- built-in `quiet` colorscheme and stay on the xterm-256 colour cube, so the
--- 256-colour fallback is exact rather than approximate.
---
--- There is exactly one hue in this file: mint.

local M = {}

local dark = {
  bg = { '#000000', 16 },
  bg_dim = { '#121212', 233 }, -- statusline, tabline, winbar
  bg_float = { '#121212', 233 },
  bg_alt = { '#1c1c1c', 234 }, -- colorcolumn
  bg_cursorline = { '#1c1c1c', 234 },
  bg_pmenu = { '#1c1c1c', 234 },
  bg_visual = { '#303030', 236 },
  bg_sel = { '#303030', 236 },
  border = { '#3a3a3a', 237 },
  line_nr = { '#4e4e4e', 239 },
  comment = { '#707070', 242 },
  fg_dim = { '#a8a8a8', 248 },
  fg = { '#dadada', 253 },
  fg_hi = { '#ffffff', 231 },

  mint_dim = { '#5faf87', 72 },
  mint = { '#87d7af', 115 },
  mint_hi = { '#afffd7', 158 },

  diff_add = { '#10241c', 22 },
  diff_change = { '#1a1a1a', 235 },
  diff_text = { '#1f4034', 23 },
  diff_delete = { '#141414', 233 },
  diff_delete_fg = { '#4e4e4e', 239 },

  terminal = {
    { '#1c1c1c', 234 },
    { '#a8a8a8', 248 },
    { '#5faf87', 72 },
    { '#c6c6c6', 251 },
    { '#8a8a8a', 245 },
    { '#a8a8a8', 248 },
    { '#87d7af', 115 },
    { '#dadada', 253 },
    { '#585858', 240 },
    { '#c6c6c6', 251 },
    { '#87d7af', 115 },
    { '#dadada', 253 },
    { '#a8a8a8', 248 },
    { '#c6c6c6', 251 },
    { '#afffd7', 158 },
    { '#ffffff', 231 },
  },
}

local light = {
  bg = { '#d7d7d7', 188 },
  bg_dim = { '#c6c6c6', 251 },
  bg_float = { '#e4e4e4', 254 },
  bg_alt = { '#cfcfcf', 252 },
  bg_cursorline = { '#e4e4e4', 254 },
  bg_pmenu = { '#e4e4e4', 254 },
  bg_visual = { '#bcbcbc', 250 },
  bg_sel = { '#bcbcbc', 250 },
  border = { '#a8a8a8', 248 },
  line_nr = { '#a8a8a8', 248 },
  comment = { '#626262', 241 },
  fg_dim = { '#4e4e4e', 239 },
  fg = { '#1c1c1c', 234 },
  fg_hi = { '#000000', 16 },

  -- darkened so the glow still clears ~4.5:1 against the paper grey
  mint_dim = { '#2f7f5f', 72 },
  mint = { '#006b4b', 29 },
  mint_hi = { '#005f3f', 23 },

  diff_add = { '#bfe3d2', 151 },
  diff_change = { '#cbcbcb', 251 },
  diff_text = { '#9fd8c0', 115 },
  diff_delete = { '#cfcfcf', 252 },
  diff_delete_fg = { '#9e9e9e', 247 },

  terminal = {
    { '#d7d7d7', 188 },
    { '#4e4e4e', 239 },
    { '#006b4b', 29 },
    { '#626262', 241 },
    { '#8a8a8a', 245 },
    { '#4e4e4e', 239 },
    { '#006b4b', 29 },
    { '#1c1c1c', 234 },
    { '#a8a8a8', 248 },
    { '#3a3a3a', 237 },
    { '#2f7f5f', 72 },
    { '#4e4e4e', 239 },
    { '#626262', 241 },
    { '#3a3a3a', 237 },
    { '#2f7f5f', 72 },
    { '#000000', 16 },
  },
}

---@param background string|nil 'dark' or 'light'
function M.get(background)
  return vim.deepcopy((background or vim.o.background) == 'light' and light or dark)
end

return M
