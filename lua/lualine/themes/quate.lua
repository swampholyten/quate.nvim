-- lualine theme for quate: a grey bar, with the mode as the only mint.

local p = require('quate').palette()

local function mode(fg)
  return { a = { fg = p.bg[1], bg = fg[1], gui = 'bold' } }
end

local base = {
  b = { fg = p.fg_dim[1], bg = p.bg_alt[1] },
  c = { fg = p.comment[1], bg = p.bg_dim[1] },
}

local theme = {}
for name, accent in pairs({
  normal = p.mint,
  insert = p.fg,
  visual = p.fg_dim,
  replace = p.mint_dim,
  command = p.fg_dim,
  terminal = p.mint_dim,
}) do
  theme[name] = vim.tbl_extend('force', vim.deepcopy(base), mode(accent))
end

theme.inactive = {
  a = { fg = p.comment[1], bg = p.bg_dim[1] },
  b = { fg = p.comment[1], bg = p.bg_dim[1] },
  c = { fg = p.line_nr[1], bg = p.bg_dim[1] },
}

return theme
