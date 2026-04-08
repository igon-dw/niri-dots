local keymap = vim.keymap

local function cycle_window_width_ratio()
  local ratios = { 0.25, 0.5, 0.75 }
  local current_width = vim.api.nvim_win_get_width(0)
  local total_width = vim.o.columns
  local current_ratio = current_width / total_width
  local next_ratio = ratios[1]

  for index, ratio in ipairs(ratios) do
    if current_ratio < ratio - 0.05 then
      next_ratio = ratio
      break
    end

    if index == #ratios then
      next_ratio = ratios[1]
    end
  end

  vim.cmd('vertical resize ' .. math.floor(total_width * next_ratio))
end

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

-- Window resizing
keymap.set('n', '<leader>w=', cycle_window_width_ratio, { desc = 'Cycle window width ratio' })

-- Terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
