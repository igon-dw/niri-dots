local keymap = vim.keymap

-- Clear search highlights
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Window navigation
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })

-- Buffer navigation
keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'Next buffer' })
keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
