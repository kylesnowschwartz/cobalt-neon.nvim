---@class CobaltNeon
---@field config CobaltNeonConfig
---@field palette CobaltNeonPalette
local M = {}

---@class ItalicConfig
---@field strings boolean
---@field comments boolean
---@field keywords boolean
---@field functions boolean
---@field variables boolean

---@class CobaltNeonConfig
---@field terminal_colors boolean
---@field transparent_mode boolean
---@field dim_inactive boolean
---@field undercurl boolean
---@field underline boolean
---@field bold boolean
---@field italic ItalicConfig
---@field palette_overrides table<string, string>
---@field overrides table<string, table>
local default_config = {
  terminal_colors = true,
  transparent_mode = false,
  dim_inactive = false,
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    comments = true,
    keywords = false,
    functions = false,
    variables = false,
  },
  palette_overrides = {},
  overrides = {},
}

M.config = vim.deepcopy(default_config)

-- Cobalt Neon palette (cleaned up from iTerm2-Color-Schemes)
-- Original had severe ANSI semantic violations - this fixes them
---@class CobaltNeonPalette
M.palette = {
  -- Core UI (original)
  bg = '#142838',
  fg = '#8FF586',
  cursor = '#C4206F',
  selection = '#094FB0',

  -- Grayscale spectrum (fixed - originals were wrong)
  black = '#142631',
  bright_black = '#3A4D5C', -- was #FFF688 (yellow!)
  white = '#B0C4D8', -- was #BA46B2 (magenta!)
  bright_white = '#E8F0F8', -- was #8FF586 (green!)

  -- Reds (original - these were correct)
  red = '#FF231F',
  bright_red = '#D4312E',

  -- Greens (moved from wrong ANSI positions)
  green = '#8FF586',
  bright_green = '#6CBC67',

  -- Yellows (original - correct)
  yellow = '#E9E75C',
  bright_yellow = '#E9F06D',

  -- Blues (swapped - were in green positions)
  blue = '#3BA5FF',
  bright_blue = '#3C7DD2',

  -- Magentas (original)
  magenta = '#781AA0',
  bright_magenta = '#8230A7',

  -- Cyans (new - derived to fit the neon aesthetic)
  cyan = '#5FCED8',
  bright_cyan = '#7EE8F2',

  -- Semantic colors
  orange = '#FF9D00',
  purple = '#C4206F',

  -- UI variations
  bg_dark = '#0D1E28',
  bg_light = '#1E3848',
  bg_visual = '#094FB0',
  comment = '#5A7A8A',
  line_nr = '#3A5A6A',

  -- Diagnostic colors
  error = '#FF231F',
  warning = '#FF9D00',
  info = '#3BA5FF',
  hint = '#5FCED8',
  ok = '#8FF586',
}

local function get_colors()
  local p = M.palette
  local config = M.config

  -- Apply user palette overrides
  for color, hex in pairs(config.palette_overrides) do
    p[color] = hex
  end

  return {
    -- Background/foreground
    bg0 = p.bg,
    bg1 = p.bg_light,
    bg2 = '#2A4858',
    bg3 = '#3A5A6A',
    bg4 = p.line_nr,
    fg0 = p.bright_white,
    fg1 = p.fg,
    fg2 = p.white,
    fg3 = '#8AA8B8',
    fg4 = p.comment,

    -- Core colors
    red = p.red,
    green = p.green,
    yellow = p.yellow,
    blue = p.blue,
    magenta = p.magenta,
    cyan = p.cyan,
    orange = p.orange,
    purple = p.purple,

    -- Bright variants
    bright_red = p.bright_red,
    bright_green = p.bright_green,
    bright_yellow = p.bright_yellow,
    bright_blue = p.bright_blue,
    bright_magenta = p.bright_magenta,
    bright_cyan = p.bright_cyan,

    -- Grayscale
    black = p.black,
    white = p.white,
    bright_black = p.bright_black,
    bright_white = p.bright_white,

    -- Semantic
    error = p.error,
    warning = p.warning,
    info = p.info,
    hint = p.hint,
    ok = p.ok,

    -- Special
    cursor = p.cursor,
    selection = p.selection,
    comment = p.comment,
  }
end

local function get_groups()
  local c = get_colors()
  local config = M.config

  -- Set terminal colors
  if config.terminal_colors then
    local term_colors = {
      c.black,
      c.red,
      c.green,
      c.yellow,
      c.blue,
      c.magenta,
      c.cyan,
      c.white,
      c.bright_black,
      c.bright_red,
      c.bright_green,
      c.bright_yellow,
      c.bright_blue,
      c.bright_magenta,
      c.bright_cyan,
      c.bright_white,
    }
    for i, color in ipairs(term_colors) do
      vim.g['terminal_color_' .. (i - 1)] = color
    end
  end

  local groups = {
    -- Base color groups (for linking)
    CobaltNeonFg0 = { fg = c.fg0 },
    CobaltNeonFg1 = { fg = c.fg1 },
    CobaltNeonFg2 = { fg = c.fg2 },
    CobaltNeonFg3 = { fg = c.fg3 },
    CobaltNeonFg4 = { fg = c.fg4 },
    CobaltNeonBg0 = { fg = c.bg0 },
    CobaltNeonBg1 = { fg = c.bg1 },
    CobaltNeonBg2 = { fg = c.bg2 },
    CobaltNeonBg3 = { fg = c.bg3 },
    CobaltNeonBg4 = { fg = c.bg4 },
    CobaltNeonRed = { fg = c.red },
    CobaltNeonRedBold = { fg = c.red, bold = config.bold },
    CobaltNeonGreen = { fg = c.green },
    CobaltNeonGreenBold = { fg = c.green, bold = config.bold },
    CobaltNeonYellow = { fg = c.yellow },
    CobaltNeonYellowBold = { fg = c.yellow, bold = config.bold },
    CobaltNeonBlue = { fg = c.blue },
    CobaltNeonBlueBold = { fg = c.blue, bold = config.bold },
    CobaltNeonMagenta = { fg = c.magenta },
    CobaltNeonMagentaBold = { fg = c.magenta, bold = config.bold },
    CobaltNeonCyan = { fg = c.cyan },
    CobaltNeonCyanBold = { fg = c.cyan, bold = config.bold },
    CobaltNeonOrange = { fg = c.orange },
    CobaltNeonOrangeBold = { fg = c.orange, bold = config.bold },
    CobaltNeonPurple = { fg = c.purple },
    CobaltNeonPurpleBold = { fg = c.purple, bold = config.bold },

    -- Underline variants
    CobaltNeonRedUnderline = { undercurl = config.undercurl, sp = c.red },
    CobaltNeonGreenUnderline = { undercurl = config.undercurl, sp = c.green },
    CobaltNeonYellowUnderline = { undercurl = config.undercurl, sp = c.yellow },
    CobaltNeonBlueUnderline = { undercurl = config.undercurl, sp = c.blue },
    CobaltNeonMagentaUnderline = { undercurl = config.undercurl, sp = c.magenta },
    CobaltNeonCyanUnderline = { undercurl = config.undercurl, sp = c.cyan },
    CobaltNeonOrangeUnderline = { undercurl = config.undercurl, sp = c.orange },

    -- Sign variants
    CobaltNeonRedSign = config.transparent_mode and { fg = c.red } or { fg = c.red, bg = c.bg1 },
    CobaltNeonGreenSign = config.transparent_mode and { fg = c.green } or { fg = c.green, bg = c.bg1 },
    CobaltNeonYellowSign = config.transparent_mode and { fg = c.yellow } or { fg = c.yellow, bg = c.bg1 },
    CobaltNeonBlueSign = config.transparent_mode and { fg = c.blue } or { fg = c.blue, bg = c.bg1 },
    CobaltNeonCyanSign = config.transparent_mode and { fg = c.cyan } or { fg = c.cyan, bg = c.bg1 },
    CobaltNeonOrangeSign = config.transparent_mode and { fg = c.orange } or { fg = c.orange, bg = c.bg1 },

    -- Editor UI
    Normal = config.transparent_mode and { fg = c.fg1 } or { fg = c.fg1, bg = c.bg0 },
    NormalFloat = config.transparent_mode and { fg = c.fg1 } or { fg = c.fg1, bg = c.bg1 },
    NormalNC = config.dim_inactive and { fg = c.fg2, bg = c.bg1 } or { link = 'Normal' },
    CursorLine = { bg = c.bg1 },
    CursorColumn = { link = 'CursorLine' },
    ColorColumn = { bg = c.bg1 },
    Conceal = { fg = c.blue },
    Cursor = { fg = c.bg0, bg = c.cursor },
    CursorLineNr = { fg = c.yellow, bg = c.bg1 },
    LineNr = { fg = c.bg4 },
    SignColumn = config.transparent_mode and {} or { bg = c.bg0 },
    FoldColumn = config.transparent_mode and { fg = c.comment } or { fg = c.comment, bg = c.bg0 },
    Folded = { fg = c.comment, bg = c.bg1, italic = config.italic.comments },
    MatchParen = { bg = c.bg3, bold = config.bold },
    NonText = { fg = c.bg3 },
    SpecialKey = { fg = c.fg4 },
    EndOfBuffer = { link = 'NonText' },
    Whitespace = { fg = c.bg2 },

    -- Visual/Search
    Visual = { bg = c.selection },
    VisualNOS = { link = 'Visual' },
    Search = { fg = c.bg0, bg = c.yellow },
    IncSearch = { fg = c.bg0, bg = c.orange },
    CurSearch = { link = 'IncSearch' },
    Substitute = { fg = c.bg0, bg = c.purple },

    -- Statusline/Tabline
    StatusLine = { fg = c.fg1, bg = c.bg2 },
    StatusLineNC = { fg = c.fg4, bg = c.bg1 },
    TabLine = { fg = c.fg4, bg = c.bg1 },
    TabLineFill = { fg = c.bg4, bg = c.bg1 },
    TabLineSel = { fg = c.green, bg = c.bg1, bold = config.bold },
    WinBar = { fg = c.fg4, bg = c.bg0 },
    WinBarNC = { fg = c.fg3, bg = c.bg1 },
    WinSeparator = config.transparent_mode and { fg = c.bg3 } or { fg = c.bg3, bg = c.bg0 },

    -- Popup menu
    Pmenu = { fg = c.fg1, bg = c.bg2 },
    PmenuSel = { fg = c.bg0, bg = c.blue, bold = config.bold },
    PmenuSbar = { bg = c.bg2 },
    PmenuThumb = { bg = c.bg4 },

    -- Float
    FloatBorder = { fg = c.fg3, bg = config.transparent_mode and nil or c.bg1 },
    FloatTitle = { fg = c.green, bg = config.transparent_mode and nil or c.bg1, bold = config.bold },
    FloatFooter = { fg = c.fg4, bg = config.transparent_mode and nil or c.bg1 },

    -- Messages
    ErrorMsg = { fg = c.bg0, bg = c.red, bold = config.bold },
    WarningMsg = { fg = c.orange, bold = config.bold },
    MoreMsg = { fg = c.yellow, bold = config.bold },
    ModeMsg = { fg = c.yellow, bold = config.bold },
    Question = { fg = c.orange, bold = config.bold },
    Title = { fg = c.green, bold = config.bold },
    Directory = { fg = c.green, bold = config.bold },
    WildMenu = { fg = c.blue, bg = c.bg2, bold = config.bold },
    QuickFixLine = { link = 'CobaltNeonPurple' },

    -- Syntax
    Comment = { fg = c.comment, italic = config.italic.comments },
    SpecialComment = { fg = c.comment, italic = config.italic.comments },

    Constant = { fg = c.magenta },
    String = { fg = c.green, italic = config.italic.strings },
    Character = { fg = c.magenta },
    Number = { fg = c.magenta },
    Boolean = { fg = c.magenta },
    Float = { fg = c.magenta },

    Identifier = { fg = c.blue },
    Function = { fg = c.green, bold = config.bold, italic = config.italic.functions },

    Statement = { fg = c.red },
    Conditional = { fg = c.red, italic = config.italic.keywords },
    Repeat = { fg = c.red, italic = config.italic.keywords },
    Label = { fg = c.red },
    Operator = { fg = c.orange },
    Keyword = { fg = c.red, italic = config.italic.keywords },
    Exception = { fg = c.red },

    PreProc = { fg = c.cyan },
    Include = { fg = c.cyan },
    Define = { fg = c.cyan },
    Macro = { fg = c.cyan },
    PreCondit = { fg = c.cyan },

    Type = { fg = c.yellow },
    StorageClass = { fg = c.orange },
    Structure = { fg = c.cyan },
    Typedef = { fg = c.yellow },

    Special = { fg = c.orange },
    SpecialChar = { fg = c.cyan },
    Tag = { fg = c.blue },
    Delimiter = { fg = c.fg3 },
    Debug = { fg = c.orange },

    Underlined = { fg = c.blue, underline = config.underline },
    Ignore = { fg = c.bg3 },
    Error = { fg = c.red, bold = config.bold },
    Todo = { fg = c.bg0, bg = c.yellow, bold = config.bold },

    -- Diff
    DiffAdd = { bg = '#1E3828' },
    DiffChange = { bg = '#1E2838' },
    DiffDelete = { bg = '#381E28' },
    DiffText = { fg = c.bg0, bg = c.yellow },
    diffAdded = { link = 'DiffAdd' },
    diffRemoved = { link = 'DiffDelete' },
    diffChanged = { link = 'DiffChange' },
    diffFile = { fg = c.orange },
    diffNewFile = { fg = c.yellow },
    diffOldFile = { fg = c.orange },
    diffLine = { fg = c.blue },
    diffIndexLine = { link = 'diffChanged' },

    -- Spelling
    SpellBad = { link = 'CobaltNeonRedUnderline' },
    SpellCap = { link = 'CobaltNeonBlueUnderline' },
    SpellLocal = { link = 'CobaltNeonCyanUnderline' },
    SpellRare = { link = 'CobaltNeonMagentaUnderline' },

    -- LSP Diagnostics
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.warning },
    DiagnosticInfo = { fg = c.info },
    DiagnosticHint = { fg = c.hint },
    DiagnosticOk = { fg = c.ok },

    DiagnosticSignError = { link = 'CobaltNeonRedSign' },
    DiagnosticSignWarn = { link = 'CobaltNeonOrangeSign' },
    DiagnosticSignInfo = { link = 'CobaltNeonBlueSign' },
    DiagnosticSignHint = { link = 'CobaltNeonCyanSign' },
    DiagnosticSignOk = { link = 'CobaltNeonGreenSign' },

    DiagnosticUnderlineError = { link = 'CobaltNeonRedUnderline' },
    DiagnosticUnderlineWarn = { link = 'CobaltNeonOrangeUnderline' },
    DiagnosticUnderlineInfo = { link = 'CobaltNeonBlueUnderline' },
    DiagnosticUnderlineHint = { link = 'CobaltNeonCyanUnderline' },
    DiagnosticUnderlineOk = { link = 'CobaltNeonGreenUnderline' },

    DiagnosticVirtualTextError = { fg = c.error },
    DiagnosticVirtualTextWarn = { fg = c.warning },
    DiagnosticVirtualTextInfo = { fg = c.info },
    DiagnosticVirtualTextHint = { fg = c.hint },
    DiagnosticVirtualTextOk = { fg = c.ok },

    DiagnosticFloatingError = { fg = c.error },
    DiagnosticFloatingWarn = { fg = c.warning },
    DiagnosticFloatingInfo = { fg = c.info },
    DiagnosticFloatingHint = { fg = c.hint },
    DiagnosticFloatingOk = { fg = c.ok },

    DiagnosticDeprecated = { strikethrough = true },

    -- LSP references
    LspReferenceText = { bg = c.bg2 },
    LspReferenceRead = { bg = c.bg2 },
    LspReferenceWrite = { bg = c.bg2 },
    LspReferenceTarget = { link = 'Visual' },
    LspCodeLens = { fg = c.comment },
    LspSignatureActiveParameter = { link = 'Search' },
    LspInlayHint = { fg = c.comment, italic = true },

    -- Treesitter
    ['@variable'] = { fg = c.fg1, italic = config.italic.variables },
    ['@variable.builtin'] = { fg = c.orange },
    ['@variable.parameter'] = { fg = c.fg2 },
    ['@variable.member'] = { fg = c.fg1 },

    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = { fg = c.orange },
    ['@constant.macro'] = { link = 'Define' },

    ['@string'] = { link = 'String' },
    ['@string.regexp'] = { fg = c.cyan },
    ['@string.escape'] = { fg = c.cyan },
    ['@string.special'] = { fg = c.cyan },
    ['@string.special.symbol'] = { fg = c.magenta },
    ['@string.special.url'] = { fg = c.blue, underline = config.underline },
    ['@string.special.path'] = { fg = c.blue, underline = config.underline },

    ['@character'] = { link = 'Character' },
    ['@character.special'] = { link = 'SpecialChar' },

    ['@boolean'] = { link = 'Boolean' },
    ['@number'] = { link = 'Number' },
    ['@number.float'] = { link = 'Float' },

    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = { fg = c.orange },
    ['@function.call'] = { fg = c.green },
    ['@function.macro'] = { link = 'Macro' },
    ['@function.method'] = { fg = c.green },
    ['@function.method.call'] = { fg = c.green },

    ['@constructor'] = { fg = c.cyan },
    ['@parameter'] = { fg = c.fg2 },

    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.function'] = { fg = c.red, italic = config.italic.keywords },
    ['@keyword.operator'] = { fg = c.red },
    ['@keyword.return'] = { fg = c.red, italic = config.italic.keywords },
    ['@keyword.conditional'] = { link = 'Conditional' },
    ['@keyword.repeat'] = { link = 'Repeat' },
    ['@keyword.import'] = { link = 'Include' },
    ['@keyword.exception'] = { link = 'Exception' },
    ['@keyword.storage'] = { link = 'StorageClass' },
    ['@keyword.directive'] = { link = 'PreProc' },
    ['@keyword.directive.define'] = { link = 'Define' },
    ['@keyword.debug'] = { link = 'Debug' },

    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = { fg = c.yellow },
    ['@type.definition'] = { link = 'Typedef' },
    ['@type.qualifier'] = { fg = c.red },

    ['@attribute'] = { fg = c.cyan },
    ['@property'] = { fg = c.fg1 },

    ['@punctuation.delimiter'] = { fg = c.fg3 },
    ['@punctuation.bracket'] = { fg = c.fg3 },
    ['@punctuation.special'] = { fg = c.orange },

    ['@comment'] = { link = 'Comment' },
    ['@comment.error'] = { fg = c.bg0, bg = c.red },
    ['@comment.warning'] = { fg = c.bg0, bg = c.orange },
    ['@comment.todo'] = { fg = c.bg0, bg = c.yellow },
    ['@comment.note'] = { fg = c.bg0, bg = c.blue },

    ['@markup.heading'] = { fg = c.green, bold = config.bold },
    ['@markup.heading.1'] = { fg = c.green, bold = config.bold },
    ['@markup.heading.2'] = { fg = c.green, bold = config.bold },
    ['@markup.heading.3'] = { fg = c.yellow, bold = config.bold },
    ['@markup.heading.4'] = { fg = c.yellow },
    ['@markup.heading.5'] = { fg = c.yellow },
    ['@markup.heading.6'] = { fg = c.yellow },
    ['@markup.strong'] = { bold = config.bold },
    ['@markup.italic'] = { italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { underline = config.underline },
    ['@markup.link'] = { fg = c.blue, underline = config.underline },
    ['@markup.link.label'] = { fg = c.cyan },
    ['@markup.link.url'] = { fg = c.magenta, underline = config.underline },
    ['@markup.raw'] = { fg = c.cyan },
    ['@markup.raw.block'] = { fg = c.cyan },
    ['@markup.list'] = { fg = c.fg3 },
    ['@markup.list.checked'] = { fg = c.green },
    ['@markup.list.unchecked'] = { fg = c.fg4 },
    ['@markup.quote'] = { fg = c.fg3, italic = true },
    ['@markup.math'] = { fg = c.magenta },
    ['@markup.environment'] = { fg = c.cyan },
    ['@markup.environment.name'] = { fg = c.yellow },

    ['@tag'] = { fg = c.blue },
    ['@tag.attribute'] = { fg = c.cyan },
    ['@tag.delimiter'] = { fg = c.fg3 },

    ['@diff.plus'] = { link = 'diffAdded' },
    ['@diff.minus'] = { link = 'diffRemoved' },
    ['@diff.delta'] = { link = 'diffChanged' },

    ['@module'] = { fg = c.fg1 },
    ['@namespace'] = { fg = c.fg1 },
    ['@symbol'] = { fg = c.magenta },

    ['@none'] = {},
    ['@preproc'] = { link = 'PreProc' },
    ['@define'] = { link = 'Define' },
    ['@operator'] = { link = 'Operator' },

    -- LSP semantic tokens
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.comment'] = { link = '@comment' },
    ['@lsp.type.decorator'] = { link = '@attribute' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.macro'] = { link = '@function.macro' },
    ['@lsp.type.method'] = { link = '@function.method' },
    ['@lsp.type.namespace'] = { link = '@namespace' },
    ['@lsp.type.parameter'] = { link = '@parameter' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.struct'] = { link = '@type' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.typeParameter'] = { link = '@type.definition' },
    ['@lsp.type.variable'] = { link = '@variable' },

    -- Git signs
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.orange },
    GitSignsDelete = { fg = c.red },
    GitSignsAddNr = { fg = c.green },
    GitSignsChangeNr = { fg = c.orange },
    GitSignsDeleteNr = { fg = c.red },
    GitSignsAddLn = { link = 'DiffAdd' },
    GitSignsChangeLn = { link = 'DiffChange' },
    GitSignsDeleteLn = { link = 'DiffDelete' },
    GitSignsCurrentLineBlame = { fg = c.comment, italic = true },

    -- Telescope
    TelescopeNormal = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    TelescopeBorder = { fg = c.fg3, bg = config.transparent_mode and nil or c.bg1 },
    TelescopeTitle = { fg = c.green, bold = config.bold },
    TelescopePromptNormal = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    TelescopePromptBorder = { fg = c.fg3, bg = config.transparent_mode and nil or c.bg1 },
    TelescopePromptPrefix = { fg = c.purple },
    TelescopeResultsNormal = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    TelescopeResultsBorder = { fg = c.fg3, bg = config.transparent_mode and nil or c.bg1 },
    TelescopePreviewNormal = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    TelescopePreviewBorder = { fg = c.fg3, bg = config.transparent_mode and nil or c.bg1 },
    TelescopeSelection = { bg = c.bg2 },
    TelescopeSelectionCaret = { fg = c.purple },
    TelescopeMatching = { fg = c.orange, bold = config.bold },
    TelescopeMultiSelection = { fg = c.fg3 },

    -- Mini.nvim
    MiniStatuslineModeNormal = { fg = c.bg0, bg = c.fg1, bold = config.bold },
    MiniStatuslineModeInsert = { fg = c.bg0, bg = c.blue, bold = config.bold },
    MiniStatuslineModeVisual = { fg = c.bg0, bg = c.green, bold = config.bold },
    MiniStatuslineModeReplace = { fg = c.bg0, bg = c.red, bold = config.bold },
    MiniStatuslineModeCommand = { fg = c.bg0, bg = c.yellow, bold = config.bold },
    MiniStatuslineModeOther = { fg = c.bg0, bg = c.cyan, bold = config.bold },
    MiniStatuslineDevinfo = { link = 'StatusLine' },
    MiniStatuslineFileinfo = { link = 'StatusLine' },
    MiniStatuslineFilename = { link = 'StatusLineNC' },
    MiniStatuslineInactive = { link = 'StatusLineNC' },

    MiniDiffSignAdd = { fg = c.green },
    MiniDiffSignChange = { fg = c.cyan },
    MiniDiffSignDelete = { fg = c.red },
    MiniDiffOverAdd = { link = 'DiffAdd' },
    MiniDiffOverChange = { link = 'DiffText' },
    MiniDiffOverContext = { link = 'DiffChange' },
    MiniDiffOverDelete = { link = 'DiffDelete' },

    MiniSurround = { link = 'IncSearch' },
    MiniTrailspace = { bg = c.red },

    MiniIconsAzure = { fg = c.blue },
    MiniIconsBlue = { fg = c.blue },
    MiniIconsCyan = { fg = c.cyan },
    MiniIconsGreen = { fg = c.green },
    MiniIconsGrey = { fg = c.fg2 },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsPurple = { fg = c.magenta },
    MiniIconsRed = { fg = c.red },
    MiniIconsYellow = { fg = c.yellow },

    MiniIndentscopeSymbol = { fg = c.fg4 },
    MiniCursorword = { underline = config.underline },
    MiniCursorwordCurrent = { underline = config.underline },

    MiniFilesBorder = { link = 'FloatBorder' },
    MiniFilesBorderModified = { fg = c.warning },
    MiniFilesCursorLine = { bg = c.bg2 },
    MiniFilesDirectory = { link = 'Directory' },
    MiniFilesFile = { fg = c.fg1 },
    MiniFilesNormal = { link = 'NormalFloat' },
    MiniFilesTitle = { link = 'FloatTitle' },
    MiniFilesTitleFocused = { fg = c.orange, bold = config.bold },

    MiniPickBorder = { link = 'FloatBorder' },
    MiniPickBorderBusy = { fg = c.warning },
    MiniPickBorderText = { link = 'FloatTitle' },
    MiniPickIconDirectory = { link = 'Directory' },
    MiniPickIconFile = { link = 'MiniPickNormal' },
    MiniPickHeader = { fg = c.hint },
    MiniPickMatchCurrent = { bg = c.bg2 },
    MiniPickMatchMarked = { link = 'Visual' },
    MiniPickMatchRanges = { fg = c.orange, bold = config.bold },
    MiniPickNormal = { link = 'NormalFloat' },
    MiniPickPreviewLine = { link = 'CursorLine' },
    MiniPickPreviewRegion = { link = 'IncSearch' },
    MiniPickPrompt = { fg = c.purple },

    -- Neogit
    NeogitDiffAdd = { link = 'DiffAdd' },
    NeogitDiffDelete = { link = 'DiffDelete' },
    NeogitDiffChange = { link = 'DiffChange' },
    NeogitDiffAddHighlight = { fg = c.green, bg = '#1E3828' },
    NeogitDiffDeleteHighlight = { fg = c.red, bg = '#381E28' },
    NeogitHunkHeader = { fg = c.fg3, bg = c.bg2 },
    NeogitHunkHeaderHighlight = { fg = c.fg1, bg = c.bg3 },
    NeogitDiffContext = { bg = c.bg0 },
    NeogitDiffContextHighlight = { bg = c.bg1 },

    -- Blink.cmp
    BlinkCmpLabel = { fg = c.fg1 },
    BlinkCmpLabelDeprecated = { fg = c.fg4, strikethrough = true },
    BlinkCmpLabelMatch = { fg = c.blue, bold = config.bold },
    BlinkCmpLabelDetail = { fg = c.fg4 },
    BlinkCmpLabelDescription = { fg = c.fg4 },
    BlinkCmpKindText = { fg = c.orange },
    BlinkCmpKindMethod = { fg = c.blue },
    BlinkCmpKindFunction = { fg = c.blue },
    BlinkCmpKindConstructor = { fg = c.yellow },
    BlinkCmpKindField = { fg = c.blue },
    BlinkCmpKindVariable = { fg = c.orange },
    BlinkCmpKindClass = { fg = c.yellow },
    BlinkCmpKindInterface = { fg = c.yellow },
    BlinkCmpKindModule = { fg = c.blue },
    BlinkCmpKindProperty = { fg = c.blue },
    BlinkCmpKindUnit = { fg = c.blue },
    BlinkCmpKindValue = { fg = c.orange },
    BlinkCmpKindEnum = { fg = c.yellow },
    BlinkCmpKindKeyword = { fg = c.magenta },
    BlinkCmpKindSnippet = { fg = c.green },
    BlinkCmpKindColor = { fg = c.magenta },
    BlinkCmpKindFile = { fg = c.blue },
    BlinkCmpKindReference = { fg = c.magenta },
    BlinkCmpKindFolder = { fg = c.blue },
    BlinkCmpKindEnumMember = { fg = c.cyan },
    BlinkCmpKindConstant = { fg = c.orange },
    BlinkCmpKindStruct = { fg = c.yellow },
    BlinkCmpKindEvent = { fg = c.magenta },
    BlinkCmpKindOperator = { fg = c.orange },
    BlinkCmpKindTypeParameter = { fg = c.yellow },
    BlinkCmpSource = { fg = c.fg4 },
    BlinkCmpGhostText = { fg = c.bg4 },

    -- Neo-tree
    NeoTreeNormal = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    NeoTreeNormalNC = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    NeoTreeDirectoryIcon = { fg = c.green },
    NeoTreeDirectoryName = { fg = c.green, bold = config.bold },
    NeoTreeRootName = { fg = c.fg1, bold = config.bold, italic = true },
    NeoTreeFileName = { fg = c.fg1 },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitModified = { fg = c.orange },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitUntracked = { fg = c.orange, italic = true },
    NeoTreeIndentMarker = { fg = c.bg4 },
    NeoTreeFloatBorder = { fg = c.fg3 },
    NeoTreeTitleBar = { fg = c.fg1, bg = c.bg2 },

    -- Which-key
    WhichKey = { fg = c.purple },
    WhichKeyGroup = { fg = c.blue },
    WhichKeyDesc = { fg = c.fg1 },
    WhichKeySeparator = { fg = c.fg4 },
    WhichKeyValue = { fg = c.fg3 },
    WhichKeyFloat = { bg = c.bg1 },

    -- Trouble
    TroubleText = { fg = c.fg1 },
    TroubleCount = { fg = c.purple, bg = c.bg2 },
    TroubleNormal = { fg = c.fg1, bg = c.bg1 },
    TroubleIndent = { fg = c.bg4 },
    TroubleLocation = { fg = c.fg4 },

    -- Todo-comments
    TodoBgFIX = { fg = c.bg0, bg = c.red, bold = config.bold },
    TodoBgHACK = { fg = c.bg0, bg = c.orange, bold = config.bold },
    TodoBgNOTE = { fg = c.bg0, bg = c.blue, bold = config.bold },
    TodoBgTODO = { fg = c.bg0, bg = c.cyan, bold = config.bold },
    TodoBgWARN = { fg = c.bg0, bg = c.yellow, bold = config.bold },
    TodoBgPERF = { fg = c.bg0, bg = c.magenta, bold = config.bold },
    TodoFgFIX = { fg = c.red },
    TodoFgHACK = { fg = c.orange },
    TodoFgNOTE = { fg = c.blue },
    TodoFgTODO = { fg = c.cyan },
    TodoFgWARN = { fg = c.yellow },
    TodoFgPERF = { fg = c.magenta },
    TodoSignFIX = { fg = c.red },
    TodoSignHACK = { fg = c.orange },
    TodoSignNOTE = { fg = c.blue },
    TodoSignTODO = { fg = c.cyan },
    TodoSignWARN = { fg = c.yellow },
    TodoSignPERF = { fg = c.magenta },

    -- Snacks
    SnacksNormal = { fg = c.fg1, bg = c.bg1 },
    SnacksPicker = { fg = c.fg1 },
    SnacksPickerBorder = { link = 'SnacksPicker' },
    SnacksPickerMatch = { fg = c.orange },
    SnacksPickerPrompt = { fg = c.purple },
    SnacksPickerTitle = { link = 'SnacksPicker' },
    SnacksPickerDir = { fg = c.comment },
    SnacksPickerPathHidden = { fg = c.comment },
    SnacksPickerPathIgnored = { fg = c.bg3 },
    SnacksPickerGitStatusUntracked = { fg = c.comment },
    SnacksPickerListCursorLine = { link = 'CursorLine' },
    SnacksPickerPreviewCursorLine = { link = 'CursorLine' },
    SnacksIndent = { fg = c.bg2 },
    SnacksIndentScope = { fg = c.fg4 },

    -- HTML
    htmlTag = { fg = c.cyan, bold = config.bold },
    htmlEndTag = { fg = c.cyan, bold = config.bold },
    htmlTagName = { fg = c.blue },
    htmlArg = { fg = c.orange },
    htmlSpecialChar = { fg = c.red },
    htmlLink = { fg = c.fg4, underline = config.underline },

    -- Markdown (legacy vim syntax)
    markdownH1 = { fg = c.green, bold = config.bold },
    markdownH2 = { fg = c.green, bold = config.bold },
    markdownH3 = { fg = c.yellow, bold = config.bold },
    markdownH4 = { fg = c.yellow },
    markdownH5 = { fg = c.yellow },
    markdownH6 = { fg = c.yellow },
    markdownCode = { fg = c.cyan },
    markdownCodeBlock = { fg = c.cyan },
    markdownCodeDelimiter = { fg = c.cyan },
    markdownBlockquote = { fg = c.fg3 },
    markdownListMarker = { fg = c.fg3 },
    markdownOrderedListMarker = { fg = c.fg3 },
    markdownRule = { fg = c.fg3 },
    markdownHeadingRule = { fg = c.fg3 },
    markdownUrl = { fg = c.magenta },
    markdownLinkText = { fg = c.fg3, underline = config.underline },
    markdownHeadingDelimiter = { fg = c.orange },

    -- JSON
    jsonKeyword = { fg = c.green },
    jsonQuote = { fg = c.green },
    jsonBraces = { fg = c.fg1 },
    jsonString = { fg = c.fg1 },

    -- YAML
    yamlKey = { fg = c.green },
    yamlBlockMappingKey = { fg = c.green },

    -- Copilot
    CopilotAnnotation = { fg = c.comment, italic = true },
    CopilotSuggestion = { fg = c.comment, italic = true },

    -- TreesitterContext
    TreesitterContext = { link = 'Folded' },
    TreesitterContextLineNumber = { fg = c.yellow, bg = c.bg1 },
    TreesitterContextSeparator = { fg = c.bg3 },
    TreesitterContextBottom = { underline = config.underline, sp = c.bg3 },

    -- Diffview
    DiffviewNormal = { fg = c.fg1, bg = config.transparent_mode and nil or c.bg1 },
    DiffviewFilePanelTitle = { fg = c.blue, bold = config.bold },
    DiffviewFilePanelCounter = { fg = c.magenta, bold = config.bold },
    DiffviewFilePanelFileName = { fg = c.fg1 },
    DiffviewFilePanelPath = { fg = c.comment },
    DiffviewFilePanelRootPath = { link = 'DiffviewFilePanelTitle' },
    DiffviewFilePanelSelected = { fg = c.yellow },
    DiffviewFilePanelInsertions = { fg = c.green, bold = config.bold },
    DiffviewFilePanelDeletions = { fg = c.red, bold = config.bold },
    DiffviewFilePanelConflicts = { fg = c.orange },
    DiffviewFolderName = { link = 'Directory' },
    DiffviewFolderSign = { fg = c.cyan },
    DiffviewHash = { fg = c.magenta },
    DiffviewReference = { fg = c.green },
    DiffviewReflogSelector = { fg = c.cyan },
    DiffviewStatusAdded = { fg = c.green },
    DiffviewStatusUntracked = { fg = c.green },
    DiffviewStatusModified = { fg = c.orange },
    DiffviewStatusRenamed = { fg = c.orange },
    DiffviewStatusCopied = { fg = c.orange },
    DiffviewStatusTypeChange = { fg = c.orange },
    DiffviewStatusUnmerged = { fg = c.orange },
    DiffviewStatusUnknown = { fg = c.red },
    DiffviewStatusDeleted = { fg = c.red },
    DiffviewStatusBroken = { fg = c.red },
    DiffviewStatusIgnored = { fg = c.comment },
    DiffviewDim1 = { fg = c.comment },
    DiffviewPrimary = { fg = c.green },
    DiffviewSecondary = { fg = c.orange },

    -- RainbowDelimiters
    RainbowDelimiterRed = { fg = c.red },
    RainbowDelimiterOrange = { fg = c.orange },
    RainbowDelimiterYellow = { fg = c.yellow },
    RainbowDelimiterGreen = { fg = c.green },
    RainbowDelimiterBlue = { fg = c.blue },
    RainbowDelimiterViolet = { fg = c.magenta },
    RainbowDelimiterCyan = { fg = c.cyan },

    -- nvim-cmp (compatibility for users not on blink.cmp)
    CmpItemAbbr = { fg = c.fg1 },
    CmpItemAbbrDeprecated = { fg = c.fg4, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.blue, bold = config.bold },
    CmpItemAbbrMatchFuzzy = { link = 'CobaltNeonBlueUnderline' },
    CmpItemMenu = { fg = c.comment },
    CmpItemKindText = { fg = c.orange },
    CmpItemKindMethod = { fg = c.blue },
    CmpItemKindFunction = { fg = c.blue },
    CmpItemKindConstructor = { fg = c.yellow },
    CmpItemKindField = { fg = c.blue },
    CmpItemKindVariable = { fg = c.orange },
    CmpItemKindClass = { fg = c.yellow },
    CmpItemKindInterface = { fg = c.yellow },
    CmpItemKindModule = { fg = c.blue },
    CmpItemKindProperty = { fg = c.blue },
    CmpItemKindUnit = { fg = c.blue },
    CmpItemKindValue = { fg = c.orange },
    CmpItemKindEnum = { fg = c.yellow },
    CmpItemKindKeyword = { fg = c.magenta },
    CmpItemKindSnippet = { fg = c.green },
    CmpItemKindColor = { fg = c.magenta },
    CmpItemKindFile = { fg = c.blue },
    CmpItemKindReference = { fg = c.magenta },
    CmpItemKindFolder = { fg = c.blue },
    CmpItemKindEnumMember = { fg = c.cyan },
    CmpItemKindConstant = { fg = c.orange },
    CmpItemKindStruct = { fg = c.yellow },
    CmpItemKindEvent = { fg = c.magenta },
    CmpItemKindOperator = { fg = c.orange },
    CmpItemKindTypeParameter = { fg = c.yellow },

    -- Mason
    MasonHighlight = { fg = c.cyan },
    MasonHighlightBlock = { fg = c.bg0, bg = c.blue },
    MasonHighlightBlockBold = { fg = c.bg0, bg = c.blue, bold = config.bold },
    MasonHighlightSecondary = { fg = c.yellow },
    MasonHighlightBlockSecondary = { fg = c.bg0, bg = c.yellow },
    MasonHighlightBlockBoldSecondary = { fg = c.bg0, bg = c.yellow, bold = config.bold },
    MasonHeader = { link = 'MasonHighlightBlockBoldSecondary' },
    MasonHeaderSecondary = { link = 'MasonHighlightBlockBold' },
    MasonMuted = { fg = c.fg4 },
    MasonMutedBlock = { fg = c.bg0, bg = c.fg4 },
    MasonMutedBlockBold = { fg = c.bg0, bg = c.fg4, bold = config.bold },

    -- Illuminate
    IlluminatedWordText = { link = 'LspReferenceText' },
    IlluminatedWordRead = { link = 'LspReferenceRead' },
    IlluminatedWordWrite = { link = 'LspReferenceWrite' },
  }

  -- Apply user overrides
  for group, hl in pairs(config.overrides) do
    if groups[group] then
      groups[group].link = nil
    end
    groups[group] = vim.tbl_extend('force', groups[group] or {}, hl)
  end

  return groups
end

---@param opts CobaltNeonConfig?
function M.setup(opts)
  M.config = vim.deepcopy(default_config)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

function M.load()
  if vim.version().minor < 8 then
    vim.notify_once 'cobalt-neon.nvim: requires Neovim 0.8 or higher'
    return
  end

  if vim.g.colors_name then
    vim.cmd.hi 'clear'
  end

  vim.g.colors_name = 'cobalt-neon'
  vim.o.termguicolors = true

  local groups = get_groups()

  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return M
