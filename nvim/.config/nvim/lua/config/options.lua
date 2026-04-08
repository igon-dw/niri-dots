local opt = vim.opt

-- Display
opt.number = true -- Show line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = 'yes' -- Always show sign column (prevents layout shift)

-- Indentation
opt.tabstop = 4 -- Tab display width (Go uses tabs)
opt.shiftwidth = 2 -- Use 2 spaces for indentation
opt.expandtab = true
opt.breakindent = true -- Maintain indent on wrapped lines

-- Search
opt.ignorecase = true -- Case-insensitive search...
opt.smartcase = true -- ...unless uppercase is used

-- UI/UX
opt.list = true -- Show whitespace characters
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.splitright = true -- Open vertical splits to the right
opt.splitbelow = true -- Open horizontal splits below
opt.mouse = 'a' -- Enable mouse support
opt.timeoutlen = 500 -- Timeout for key sequences (ms)

-- Commands
opt.inccommand = 'split' -- Preview substitutions live
opt.confirm = true -- Confirm to save changes before exiting modified buffer

-- Configure LSP diagnostic signs
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
}
