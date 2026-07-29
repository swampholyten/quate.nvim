--- quate.nvim palette
---
--- Every colour is a `{ gui, cterm }` pair. The greys are lifted from Vim's
--- built-in `quiet` colorscheme and stay on the xterm-256 colour cube, so the
--- 256-colour fallback is exact rather than approximate.
---
--- Dark only. There is exactly one hue in this file: mint.

local M = {}

local palette = {
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

  -- the quiet mint: rationed, and never louder than the text
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

--- monoglow's electric accent, swapped in when `glow` is on. `#1bfd9c` is
--- monoglow's own glow colour; the cterm fallback lands on 49, which is the
--- mint `quiet` already reserved for Todo.
local glow_ramp = {
  mint_dim = { '#00d7af', 43 },
  mint = { '#1bfd9c', 49 },
  mint_hi = { '#87ffd7', 122 },
}

---@param opts QuateConfig|nil
---@return table
function M.get(opts)
  local p = vim.deepcopy(palette)
  if opts and opts.glow then
    for key, color in pairs(glow_ramp) do
      p[key] = color
    end
    p.terminal[3] = glow_ramp.mint_dim
    p.terminal[7] = glow_ramp.mint
    p.terminal[11] = glow_ramp.mint
    p.terminal[15] = glow_ramp.mint_hi
  end
  return p
end

return M
