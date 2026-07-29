--- quate.nvim highlight groups
---
--- Structure follows Vim's built-in `quiet`: a flat, monochrome surface where
--- nothing shouts. Meaning is carried by gruvbox's text manipulations -- bold
--- for callable/structural things, italic for prose-like things -- and by a
--- single mint glow reserved for what genuinely wants your eye.

local M = {}

---@param p table palette
---@param o QuateConfig
---@return table<string, table>
function M.setup(p, o)
  local none = 'NONE'

  -- gruvbox's attribute switches
  local bold = o.bold or nil
  local italic = o.italic
  local it_comment = (italic and o.italic_comments) or nil
  local it_string = (italic and o.italic_strings) or nil
  local it_fold = (italic and o.italic_folds) or nil
  local it_keyword = (italic and o.italic_keywords) or nil
  local uline = o.underline or nil
  local ucurl = o.undercurl or nil
  local inverse = o.inverse or nil

  --- monoglow's `glow`: the accent stops being rationed
  local glow = o.glow or nil

  local bg = o.transparent and none or p.bg
  local bg_float = o.transparent and none or p.bg_float

  --- squiggle under bad text, honouring the undercurl/underline switches
  local function squiggle(sp, style)
    if style == 'dashed' then
      return { sp = sp, underdashed = uline, underline = (not uline) and true or nil }
    elseif style == 'dotted' then
      return { sp = sp, underdotted = uline, underline = (not uline) and true or nil }
    end
    return { sp = sp, undercurl = ucurl, underline = (not ucurl) and uline or nil }
  end

  --- gruvbox `inverse`: reverse video, or a plain fill when it is switched off
  local function invert(color)
    if inverse then
      return { fg = color, bg = bg, reverse = true }
    end
    return { fg = p.bg, bg = color }
  end

  --- a lit block, the way monoglow draws its selection and incremental search
  local function lit(color)
    return { fg = p.bg, bg = color, bold = bold }
  end

  local groups = {

    -- ------------------------------------------------------------------
    -- editor
    -- ------------------------------------------------------------------
    Normal = { fg = p.fg, bg = bg },
    NormalNC = o.dim_inactive and { fg = p.fg_dim, bg = p.bg_dim } or { link = 'Normal' },
    NormalFloat = { fg = p.fg, bg = bg_float },
    FloatBorder = { fg = p.border, bg = bg_float },
    FloatTitle = { fg = p.fg, bg = bg_float, bold = bold },
    FloatFooter = { fg = p.comment, bg = bg_float },

    ColorColumn = { bg = p.bg_alt },
    Conceal = { fg = p.comment },
    Cursor = { reverse = true },
    lCursor = { link = 'Cursor' },
    CursorIM = { link = 'Cursor' },
    TermCursor = { link = 'Cursor' },
    TermCursorNC = { bg = p.bg_visual },
    CursorColumn = { bg = p.bg_cursorline },
    CursorLine = { bg = p.bg_cursorline },
    CursorLineNr = { fg = p.mint, bold = bold },
    CursorLineFold = { link = 'FoldColumn' },
    CursorLineSign = { link = 'SignColumn' },

    Directory = { fg = p.fg, bold = bold },
    EndOfBuffer = { fg = p.line_nr },
    ErrorMsg = { fg = p.fg_hi, bold = bold },
    WarningMsg = { fg = p.fg_dim },
    ModeMsg = { fg = p.mint, bold = bold },
    MoreMsg = { fg = p.fg_dim },
    MsgArea = { fg = p.fg },
    MsgSeparator = { fg = p.border, bg = p.bg_dim },
    Question = { fg = p.mint },

    Folded = { fg = p.comment, bg = p.bg_dim, italic = it_fold },
    FoldColumn = { fg = p.line_nr, bg = bg },
    SignColumn = { fg = p.line_nr, bg = bg },
    LineNr = { fg = p.line_nr },
    LineNrAbove = { link = 'LineNr' },
    LineNrBelow = { link = 'LineNr' },

    MatchParen = { fg = p.mint_hi, bold = bold },
    NonText = { fg = p.line_nr },
    Whitespace = { fg = p.line_nr },
    SpecialKey = { fg = p.comment },

    Search = glow and { fg = p.mint, bold = bold } or invert(p.mint),
    IncSearch = glow and lit(p.mint) or vim.tbl_extend('force', invert(p.mint_hi), { bold = bold }),
    CurSearch = { link = 'IncSearch' },
    Substitute = { link = 'IncSearch' },
    QuickFixLine = { bg = p.bg_sel, bold = bold },

    Pmenu = { fg = p.fg, bg = p.bg_pmenu },
    PmenuSel = glow and lit(p.mint) or { fg = p.mint_hi, bg = p.bg_sel, bold = bold },
    PmenuKind = { fg = p.comment, bg = p.bg_pmenu, bold = bold },
    PmenuKindSel = { fg = p.comment, bg = p.bg_sel, bold = bold },
    PmenuExtra = { fg = p.comment, bg = p.bg_pmenu },
    PmenuExtraSel = { fg = p.fg_dim, bg = p.bg_sel },
    PmenuMatch = { fg = p.mint, bg = p.bg_pmenu, bold = bold },
    PmenuMatchSel = { fg = p.mint_hi, bg = p.bg_sel, bold = bold },
    PmenuSbar = { bg = p.bg_alt },
    PmenuThumb = { bg = p.border },
    ComplMatchIns = { fg = p.comment },
    WildMenu = { link = 'PmenuSel' },

    StatusLine = { fg = p.fg, bg = p.bg_dim, bold = bold },
    StatusLineNC = { fg = p.comment, bg = p.bg_dim },
    StatusLineTerm = { fg = p.mint, bg = p.bg_dim, bold = bold },
    StatusLineTermNC = { fg = p.mint_dim, bg = p.bg_dim },
    TabLine = { fg = p.comment, bg = p.bg_dim },
    TabLineFill = { bg = p.bg_dim },
    TabLineSel = { fg = p.fg, bg = bg, bold = bold },
    WinBar = { fg = p.fg_dim, bg = none, bold = bold },
    WinBarNC = { fg = p.comment, bg = none },
    WinSeparator = { fg = p.border, bg = bg },
    VertSplit = { link = 'WinSeparator' },

    Title = { fg = p.fg, bold = bold },
    Visual = { bg = p.bg_visual },
    VisualNOS = { bg = p.bg_alt },
    SnippetTabstop = { bg = p.bg_visual },

    SpellBad = squiggle(p.fg_hi),
    SpellCap = squiggle(p.fg_dim, 'dashed'),
    SpellLocal = squiggle(p.comment, 'dotted'),
    SpellRare = squiggle(p.mint_dim, 'dotted'),

    DiffAdd = { bg = p.diff_add },
    DiffChange = { bg = p.diff_change },
    DiffText = { bg = p.diff_text, bold = bold },
    DiffDelete = { fg = p.diff_delete_fg, bg = p.diff_delete },
    Added = { fg = p.mint },
    Changed = { fg = p.fg_dim },
    Removed = { fg = p.comment },

    -- ------------------------------------------------------------------
    -- syntax -- flat colour, gruvbox weights
    -- ------------------------------------------------------------------
    Comment = { fg = p.comment, italic = it_comment },
    SpecialComment = { fg = p.comment, italic = it_comment, bold = bold },
    Todo = vim.tbl_extend('force', invert(p.mint), { bold = bold, italic = it_comment }),

    Constant = { fg = p.fg },
    String = { fg = p.fg, italic = it_string },
    Character = { link = 'Constant' },
    Number = { link = 'Constant' },
    Boolean = { link = 'Constant' },
    Float = { link = 'Constant' },

    Identifier = { fg = p.fg, bold = glow and bold or nil },
    Function = { fg = p.fg, bold = bold },

    Statement = { fg = p.fg, bold = bold, italic = it_keyword },
    Conditional = { link = 'Statement' },
    Repeat = { link = 'Statement' },
    Label = { link = 'Statement' },
    Keyword = { link = 'Statement' },
    Exception = { link = 'Statement' },
    Operator = glow and { fg = p.mint, bold = bold } or { fg = p.fg },

    PreProc = { fg = p.fg_dim },
    Include = { link = 'PreProc' },
    Define = { link = 'PreProc' },
    Macro = { link = 'PreProc' },
    PreCondit = { link = 'PreProc' },

    Type = { fg = p.fg },
    StorageClass = { fg = p.fg, bold = bold },
    Structure = { link = 'StorageClass' },
    Typedef = { link = 'StorageClass' },

    Special = { fg = p.mint },
    SpecialChar = { fg = p.mint },
    Tag = { fg = p.fg, bold = bold },
    Delimiter = { fg = p.fg_dim },
    Debug = { fg = p.mint },

    Underlined = { fg = p.fg, underline = uline },
    Bold = { bold = bold },
    Italic = { italic = italic or nil },
    Ignore = { fg = p.line_nr },
    Error = vim.tbl_extend('force', invert(p.fg_hi), { bold = bold }),

    -- ------------------------------------------------------------------
    -- diagnostics -- severity by weight and underline style, not by hue
    -- ------------------------------------------------------------------
    DiagnosticError = { fg = p.fg_hi, bold = bold },
    DiagnosticWarn = { fg = p.fg_dim },
    DiagnosticInfo = { fg = p.comment },
    DiagnosticHint = { fg = p.comment, italic = it_comment },
    DiagnosticOk = { fg = p.mint },

    DiagnosticVirtualTextError = { fg = p.fg_dim, bold = bold },
    DiagnosticVirtualTextWarn = { fg = p.comment },
    DiagnosticVirtualTextInfo = { fg = p.line_nr },
    DiagnosticVirtualTextHint = { fg = p.line_nr, italic = it_comment },
    DiagnosticVirtualTextOk = { fg = p.mint_dim },

    DiagnosticUnderlineError = squiggle(p.fg_hi),
    DiagnosticUnderlineWarn = squiggle(p.fg_dim, 'dashed'),
    DiagnosticUnderlineInfo = squiggle(p.comment, 'dotted'),
    DiagnosticUnderlineHint = squiggle(p.line_nr, 'dotted'),
    DiagnosticUnderlineOk = squiggle(p.mint_dim),

    DiagnosticFloatingError = { link = 'DiagnosticError' },
    DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
    DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
    DiagnosticFloatingHint = { link = 'DiagnosticHint' },
    DiagnosticFloatingOk = { link = 'DiagnosticOk' },
    DiagnosticSignError = { link = 'DiagnosticError' },
    DiagnosticSignWarn = { link = 'DiagnosticWarn' },
    DiagnosticSignInfo = { link = 'DiagnosticInfo' },
    DiagnosticSignHint = { link = 'DiagnosticHint' },
    DiagnosticSignOk = { link = 'DiagnosticOk' },
    DiagnosticDeprecated = { fg = p.comment, strikethrough = true },
    DiagnosticUnnecessary = { fg = p.line_nr, italic = it_comment },

    -- ------------------------------------------------------------------
    -- lsp
    -- ------------------------------------------------------------------
    LspReferenceText = { bg = p.bg_alt },
    LspReferenceRead = { bg = p.bg_alt },
    LspReferenceWrite = { bg = p.bg_alt, underline = uline, sp = p.mint_dim },
    LspReferenceTarget = { bg = p.bg_alt },
    LspInlayHint = { fg = p.line_nr, bg = p.bg_alt, italic = it_comment },
    LspCodeLens = { fg = p.line_nr, italic = it_comment },
    LspCodeLensSeparator = { fg = p.line_nr },
    LspSignatureActiveParameter = { fg = p.mint, bold = bold },
    LspInfoBorder = { link = 'FloatBorder' },

    ['@lsp.type.namespace'] = { link = '@module' },
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.struct'] = { link = '@type' },
    ['@lsp.type.typeParameter'] = { link = '@type.definition' },
    ['@lsp.type.parameter'] = { link = '@variable.parameter' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.method'] = { link = '@function.method' },
    ['@lsp.type.macro'] = { link = '@function.macro' },
    ['@lsp.type.decorator'] = { link = '@attribute' },
    ['@lsp.type.comment'] = { link = '@comment' },
    ['@lsp.mod.deprecated'] = { link = 'DiagnosticDeprecated' },

    -- ------------------------------------------------------------------
    -- treesitter
    -- ------------------------------------------------------------------
    ['@variable'] = { fg = p.fg },
    ['@variable.builtin'] = { fg = p.fg, italic = italic or nil },
    ['@variable.parameter'] = { fg = p.fg },
    ['@variable.parameter.builtin'] = { fg = p.fg, italic = italic or nil },
    ['@variable.member'] = { fg = p.fg },

    ['@constant'] = { fg = p.fg },
    ['@constant.builtin'] = { fg = p.fg, italic = italic or nil },
    ['@constant.macro'] = { link = 'PreProc' },

    ['@module'] = { fg = p.fg_dim },
    ['@module.builtin'] = { fg = p.fg_dim, italic = italic or nil },
    ['@label'] = { link = 'Label' },

    ['@string'] = { link = 'String' },
    ['@string.documentation'] = { fg = p.comment, italic = it_comment },
    ['@string.regexp'] = { fg = p.fg_dim },
    ['@string.escape'] = { fg = p.mint, bold = bold },
    ['@string.special'] = { fg = p.mint },
    ['@string.special.symbol'] = { fg = p.fg },
    ['@string.special.path'] = { fg = p.fg, underline = uline },
    ['@string.special.url'] = { fg = p.mint_dim, underline = uline },

    ['@character'] = { link = 'Character' },
    ['@character.special'] = { link = 'SpecialChar' },
    ['@boolean'] = { link = 'Boolean' },
    ['@number'] = { link = 'Number' },
    ['@number.float'] = { link = 'Float' },

    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = { fg = p.fg, italic = italic or nil },
    ['@type.definition'] = { link = 'Typedef' },
    ['@attribute'] = { fg = p.fg_dim, italic = italic or nil },
    ['@attribute.builtin'] = { fg = p.fg_dim, italic = italic or nil },
    ['@property'] = { fg = p.fg },

    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = { fg = p.fg, bold = bold, italic = italic or nil },
    ['@function.call'] = { link = 'Function' },
    ['@function.macro'] = { fg = p.fg_dim, bold = bold },
    ['@function.method'] = { link = 'Function' },
    ['@function.method.call'] = { link = 'Function' },
    ['@constructor'] = { fg = p.fg, bold = bold },

    ['@operator'] = { link = 'Operator' },
    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.coroutine'] = { link = 'Keyword' },
    ['@keyword.function'] = { link = 'Keyword' },
    ['@keyword.operator'] = { link = 'Keyword' },
    ['@keyword.import'] = { link = 'Include' },
    ['@keyword.type'] = { link = 'Keyword' },
    ['@keyword.modifier'] = { link = 'StorageClass' },
    ['@keyword.repeat'] = { link = 'Repeat' },
    ['@keyword.return'] = { link = 'Keyword' },
    ['@keyword.debug'] = { link = 'Debug' },
    ['@keyword.exception'] = { link = 'Exception' },
    ['@keyword.conditional'] = { link = 'Conditional' },
    ['@keyword.conditional.ternary'] = { link = 'Operator' },
    ['@keyword.directive'] = { link = 'PreProc' },
    ['@keyword.directive.define'] = { link = 'Define' },

    ['@punctuation.delimiter'] = { fg = p.fg_dim },
    ['@punctuation.bracket'] = { fg = p.fg_dim },
    ['@punctuation.special'] = { fg = p.mint },

    ['@comment'] = { link = 'Comment' },
    ['@comment.documentation'] = { fg = p.comment, italic = it_comment },
    ['@comment.error'] = { fg = p.fg_hi, bold = bold },
    ['@comment.warning'] = { fg = p.fg_dim, bold = bold },
    ['@comment.todo'] = { link = 'Todo' },
    ['@comment.note'] = { fg = p.mint, bold = bold },

    ['@markup.strong'] = { fg = p.fg, bold = bold },
    ['@markup.italic'] = { fg = p.fg, italic = italic or nil },
    ['@markup.strikethrough'] = { fg = p.comment, strikethrough = true },
    ['@markup.underline'] = { underline = uline },
    ['@markup.heading'] = { fg = p.fg, bold = bold },
    ['@markup.heading.1'] = { fg = p.mint, bold = bold },
    ['@markup.heading.2'] = { fg = p.fg_hi, bold = bold },
    ['@markup.heading.3'] = { fg = p.fg, bold = bold },
    ['@markup.heading.4'] = { fg = p.fg_dim, bold = bold },
    ['@markup.heading.5'] = { fg = p.fg_dim },
    ['@markup.heading.6'] = { fg = p.comment },
    ['@markup.quote'] = { fg = p.comment, italic = it_comment },
    ['@markup.math'] = { fg = p.fg_dim },
    ['@markup.link'] = { fg = p.fg_dim },
    ['@markup.link.label'] = { fg = p.mint },
    ['@markup.link.url'] = { fg = p.comment, underline = uline },
    ['@markup.raw'] = { fg = p.fg_dim },
    ['@markup.raw.block'] = { fg = p.fg_dim },
    ['@markup.list'] = { fg = p.mint },
    ['@markup.list.checked'] = { fg = p.mint, bold = bold },
    ['@markup.list.unchecked'] = { fg = p.comment },

    ['@diff.plus'] = { fg = p.mint },
    ['@diff.minus'] = { fg = p.comment },
    ['@diff.delta'] = { fg = p.fg_dim },

    ['@tag'] = { fg = p.fg, bold = bold },
    ['@tag.builtin'] = { fg = p.fg, bold = bold },
    ['@tag.attribute'] = { fg = p.fg_dim, italic = italic or nil },
    ['@tag.delimiter'] = { fg = p.comment },

    -- ------------------------------------------------------------------
    -- filetypes worth a nudge
    -- ------------------------------------------------------------------
    diffAdded = { fg = p.mint },
    diffRemoved = { fg = p.comment },
    diffChanged = { fg = p.fg_dim },
    diffOldFile = { fg = p.comment },
    diffNewFile = { fg = p.fg },
    diffFile = { fg = p.fg, bold = bold },
    diffLine = { fg = p.fg_dim },
    diffIndexLine = { fg = p.comment },

    gitcommitSummary = { fg = p.fg, bold = bold },
    gitcommitOverflow = { fg = p.fg_hi, undercurl = ucurl, sp = p.fg_hi },
    gitcommitComment = { link = 'Comment' },

    healthError = { fg = p.fg_hi, bold = bold },
    healthWarning = { fg = p.fg_dim },
    healthSuccess = { fg = p.mint },
    helpHyperTextJump = { fg = p.mint },
    helpExample = { fg = p.fg_dim },

    markdownH1 = { link = '@markup.heading.1' },
    markdownH2 = { link = '@markup.heading.2' },
    markdownH3 = { link = '@markup.heading.3' },
    markdownCode = { fg = p.fg_dim },
    markdownUrl = { fg = p.comment, underline = uline },

    -- ------------------------------------------------------------------
    -- plugins
    -- ------------------------------------------------------------------
    -- gitsigns
    GitSignsAdd = { fg = p.mint_dim },
    GitSignsChange = { fg = p.fg_dim },
    GitSignsDelete = { fg = p.comment },
    GitSignsAddInline = { bg = p.diff_text },
    GitSignsChangeInline = { bg = p.diff_change },
    GitSignsDeleteInline = { bg = p.diff_delete, fg = p.diff_delete_fg },
    GitSignsCurrentLineBlame = { fg = p.line_nr, italic = it_comment },

    -- telescope
    TelescopeNormal = { fg = p.fg, bg = bg_float },
    TelescopeBorder = { fg = p.border, bg = bg_float },
    TelescopeTitle = { fg = p.fg, bold = bold },
    TelescopePromptTitle = { fg = p.mint, bold = bold },
    TelescopeSelection = { fg = p.fg_hi, bg = p.bg_sel, bold = bold },
    TelescopeSelectionCaret = { fg = p.mint, bg = p.bg_sel },
    TelescopeMultiSelection = { fg = p.mint },
    TelescopeMatching = { fg = p.mint, bold = bold },
    TelescopePromptCounter = { fg = p.comment },

    -- nvim-cmp / blink.cmp
    CmpItemAbbr = { fg = p.fg },
    CmpItemAbbrDeprecated = { fg = p.comment, strikethrough = true },
    CmpItemAbbrMatch = { fg = p.mint, bold = bold },
    CmpItemAbbrMatchFuzzy = { fg = p.mint_dim, bold = bold },
    CmpItemKind = { fg = p.comment },
    CmpItemMenu = { fg = p.line_nr, italic = it_comment },
    BlinkCmpMenu = { link = 'Pmenu' },
    BlinkCmpMenuBorder = { link = 'FloatBorder' },
    BlinkCmpMenuSelection = { link = 'PmenuSel' },
    BlinkCmpLabelMatch = { fg = p.mint, bold = bold },
    BlinkCmpLabelDeprecated = { fg = p.comment, strikethrough = true },
    BlinkCmpKind = { fg = p.comment },
    BlinkCmpGhostText = { fg = p.line_nr, italic = it_comment },

    -- indent-blankline
    IblIndent = { fg = p.bg_visual },
    IblScope = { fg = p.border },
    IblWhitespace = { fg = p.bg_alt },

    -- nvim-tree / neo-tree / oil
    NvimTreeNormal = { fg = p.fg, bg = bg_float },
    NvimTreeRootFolder = { fg = p.fg, bold = bold },
    NvimTreeFolderName = { fg = p.fg_dim },
    NvimTreeOpenedFolderName = { fg = p.fg, bold = bold },
    NvimTreeSpecialFile = { fg = p.mint },
    NvimTreeGitDirty = { fg = p.fg_dim },
    NvimTreeGitNew = { fg = p.mint_dim },
    NvimTreeGitDeleted = { fg = p.comment },
    NvimTreeIndentMarker = { fg = p.bg_visual },
    NeoTreeNormal = { fg = p.fg, bg = bg_float },
    NeoTreeDirectoryName = { fg = p.fg_dim },
    NeoTreeRootName = { fg = p.fg, bold = bold },
    NeoTreeGitAdded = { fg = p.mint_dim },
    NeoTreeGitModified = { fg = p.fg_dim },
    NeoTreeGitDeleted = { fg = p.comment },
    NeoTreeIndentMarker = { fg = p.bg_visual },
    OilDir = { fg = p.fg_dim },
    OilFile = { fg = p.fg },

    -- which-key
    WhichKey = { fg = p.mint, bold = bold },
    WhichKeyGroup = { fg = p.fg_dim },
    WhichKeyDesc = { fg = p.fg },
    WhichKeySeparator = { fg = p.line_nr },
    WhichKeyFloat = { bg = bg_float },
    WhichKeyBorder = { link = 'FloatBorder' },

    -- lazy / mason
    LazyNormal = { fg = p.fg, bg = bg_float },
    LazyH1 = { fg = p.fg_hi, bg = p.bg_sel, bold = bold },
    LazyButtonActive = { fg = p.mint, bg = p.bg_sel, bold = bold },
    LazyProgressDone = { fg = p.mint, bold = bold },
    LazyProgressTodo = { fg = p.line_nr },
    MasonNormal = { fg = p.fg, bg = bg_float },
    MasonHeader = { fg = p.fg_hi, bg = p.bg_sel, bold = bold },
    MasonHighlight = { fg = p.mint },
    MasonMuted = { fg = p.comment },

    -- mini.nvim
    MiniStatuslineModeNormal = { fg = p.bg, bg = p.mint, bold = bold },
    MiniStatuslineModeInsert = { fg = p.bg, bg = p.fg, bold = bold },
    MiniStatuslineModeVisual = { fg = p.bg, bg = p.fg_dim, bold = bold },
    MiniStatuslineModeReplace = { fg = p.bg, bg = p.mint_dim, bold = bold },
    MiniStatuslineModeCommand = { fg = p.bg, bg = p.fg_dim, bold = bold },
    MiniStatuslineModeOther = { fg = p.bg, bg = p.comment, bold = bold },
    MiniStatuslineDevinfo = { fg = p.fg_dim, bg = p.bg_alt },
    MiniStatuslineFilename = { fg = p.comment, bg = p.bg_dim },
    MiniStatuslineInactive = { fg = p.comment, bg = p.bg_dim },
    MiniIndentscopeSymbol = { fg = p.border },
    MiniCursorword = { bg = p.bg_alt },
    MiniCursorwordCurrent = { bg = p.bg_alt },
    MiniDiffSignAdd = { fg = p.mint_dim },
    MiniDiffSignChange = { fg = p.fg_dim },
    MiniDiffSignDelete = { fg = p.comment },
    MiniPickMatchCurrent = { link = 'PmenuSel' },
    MiniPickMatchRanges = { fg = p.mint, bold = bold },

    -- misc
    TreesitterContext = { bg = p.bg_alt },
    TreesitterContextLineNumber = { fg = p.line_nr, bg = p.bg_alt },
    NotifyINFOTitle = { fg = p.mint },
    NotifyERRORTitle = { fg = p.fg_hi, bold = bold },
    NotifyWARNTitle = { fg = p.fg_dim },
    FlashLabel = { fg = p.bg, bg = p.mint_hi, bold = bold },
    RainbowDelimiter1 = { fg = p.fg_dim },
    RainbowDelimiter2 = { fg = p.comment },
    RainbowDelimiter3 = { fg = p.mint_dim },
  }

  return groups
end

return M
