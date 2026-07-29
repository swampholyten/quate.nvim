--- quate.nvim
---
--- Vim's `quiet` for the palette, gruvbox for the italics and bolds, mint for
--- the glow. Nothing else gets a colour.

local config = require('quate.config')

local M = {}

M.setup = config.setup

--- attributes passed straight through to nvim_set_hl, mirrored onto cterm
local ATTRS = {
  'bold',
  'italic',
  'underline',
  'undercurl',
  'underdouble',
  'underdotted',
  'underdashed',
  'strikethrough',
  'reverse',
  'standout',
  'nocombine',
}

---@param spec table
---@return table
local function to_hl(spec)
  if spec.link then
    return { link = spec.link }
  end

  local hl, cterm = {}, {}

  for _, key in ipairs({ 'fg', 'bg', 'sp' }) do
    local color = spec[key]
    if type(color) == 'table' then
      hl[key] = color[1]
      if key ~= 'sp' then
        hl['cterm' .. key] = color[2]
      end
    elseif type(color) == 'string' then
      hl[key] = color
      if key ~= 'sp' then
        hl['cterm' .. key] = color
      end
    end
  end

  for _, attr in ipairs(ATTRS) do
    if spec[attr] then
      hl[attr] = true
      cterm[attr] = true
    end
  end
  hl.cterm = cterm

  return hl
end

---@param palette table
local function set_terminal_colors(palette)
  for i, color in ipairs(palette.terminal) do
    vim.g['terminal_color_' .. (i - 1)] = color[1]
  end
end

--- Apply the colorscheme.
---@param opts QuateConfig|nil merged over the current options
function M.load(opts)
  local o = opts and config.setup(opts) or config.options

  -- Dark only. If something flipped 'background', come back once the option
  -- handler has finished -- setting it inline leaves Neovim on its own light
  -- defaults with `colors_name` cleared.
  if vim.o.background ~= 'dark' then
    vim.schedule(function()
      vim.cmd.colorscheme('quate')
    end)
  end
  vim.o.background = 'dark'

  if vim.g.colors_name then
    vim.cmd('highlight clear')
  end
  if vim.fn.exists('syntax_on') == 1 then
    vim.cmd('syntax reset')
  end
  vim.g.colors_name = 'quate'

  local palette = require('quate.palette').get(o)
  local groups = require('quate.highlights').setup(palette, o)

  for group, spec in pairs(o.overrides or {}) do
    if spec.link or groups[group] == nil or groups[group].link then
      groups[group] = spec
    else
      groups[group] = vim.tbl_extend('force', groups[group], spec)
    end
  end

  if type(o.on_highlights) == 'function' then
    o.on_highlights(groups, palette)
  end

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, to_hl(spec))
  end

  if o.terminal_colors then
    set_terminal_colors(palette)
  end
end

--- The palette, for statuslines and such. Reflects the current `glow` setting.
---@return table
function M.palette()
  return require('quate.palette').get(config.options)
end

return M
