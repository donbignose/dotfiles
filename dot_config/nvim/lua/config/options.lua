local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Keep signs visible, prevent layout shifts
opt.signcolumn = "yes"

-- Keep context when navigating
opt.scrolloff = 8

-- Faster diagnostic updates
opt.updatetime = 250

-- Consistent split direction
opt.splitright = true
opt.splitbelow = true

-- Show trailing whitespace and tabs
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Persistent undo
opt.undofile = true

-- Indentation (4 spaces, no tabs)
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.wrap = false
opt.laststatus = 3

-- No swap, no backup (we have undofile + git)
opt.swapfile = false
opt.backup = false

-- Reduce noise
opt.shortmess:append("sI")

-- Diagnostics: signs only, no virtual text
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
