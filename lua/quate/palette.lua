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

--- monoglow's electric accent, swapped in for `glow = true`. `#1bfd9c` is
--- monoglow's own glow colour; the cterm fallback lands on 49, which is the
--- mint `quiet` already reserved for Todo.
local electric = {
  mint_dim = { '#00d7af', 43 },
  mint = { '#1bfd9c', 49 },
  mint_hi = { '#87ffd7', 122 },
}

--- xterm-256: the 6x6x6 cube levels, then the 24-step grey ramp.
local CUBE = { 0, 95, 135, 175, 215, 255 }

---@param hex string '#rrggbb'
---@return integer, integer, integer
local function rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

--- Nearest xterm-256 index, so a user's glow keeps a sane 256-colour fallback.
---@param hex string
---@return integer
local function cterm(hex)
  local r, g, b = rgb(hex)

  local idx, best = 16, math.huge
  for i, cr in ipairs(CUBE) do
    for j, cg in ipairs(CUBE) do
      for k, cb in ipairs(CUBE) do
        local d = (cr - r) ^ 2 + (cg - g) ^ 2 + (cb - b) ^ 2
        if d < best then
          idx, best = 16 + 36 * (i - 1) + 6 * (j - 1) + (k - 1), d
        end
      end
    end
  end

  for i = 0, 23 do
    local v = 8 + 10 * i
    local d = (v - r) ^ 2 + (v - g) ^ 2 + (v - b) ^ 2
    if d < best then
      idx, best = 232 + i, d
    end
  end

  return idx
end

---@param hex string
---@param toward integer 0 for black, 255 for white
---@param amount number 0..1
---@return table {gui, cterm}
local function mix(hex, toward, amount)
  local out = { rgb(hex) }
  for i, c in ipairs(out) do
    out[i] = math.floor(c + (toward - c) * amount + 0.5)
  end
  local gui = string.format('#%02x%02x%02x', out[1], out[2], out[3])
  return { gui, cterm(gui) }
end

--- Build the three-step ramp around a user's colour.
---@param hex string
---@return table
local function ramp_from(hex)
  return {
    mint_dim = mix(hex, 0, 0.3),
    mint = { hex, cterm(hex) },
    mint_hi = mix(hex, 255, 0.45),
  }
end

--- @param glow boolean|string|nil
--- @return table|nil the accent ramp replacing the quiet mint, if any
local function resolve(glow)
  if type(glow) == 'string' then
    if not glow:match('^#%x%x%x%x%x%x$') then
      vim.notify("quate: glow expects a boolean or '#rrggbb', got " .. glow, vim.log.levels.WARN)
      return electric
    end
    return ramp_from(glow)
  end
  return glow and electric or nil
end

---@param opts QuateConfig|nil
---@return table
function M.get(opts)
  local p = vim.deepcopy(palette)

  local ramp = resolve(opts and opts.glow)
  if ramp then
    for key, color in pairs(ramp) do
      p[key] = color
    end
    p.terminal[3] = ramp.mint_dim
    p.terminal[7] = ramp.mint
    p.terminal[11] = ramp.mint
    p.terminal[15] = ramp.mint_hi
  end

  return p
end

return M
