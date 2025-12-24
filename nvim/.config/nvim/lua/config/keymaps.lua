-- keymaps.lua
-- 主要なキーマッピングを設定
-- vim.keymap.set(mode, lhs, rhs, opts)
-- mode: 'n' (Normal), 'i' (Insert), 'v' (Visual), 't' (Terminal)など
-- lhs: 割り当てるキー
-- rhs: 実行するコマンドや関数
-- opts: { desc = '説明' } などのオプション

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- [[ 基本的な操作 ]]
-- ノーマルモードでEscを押すとハイライトを消去
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights', silent = true })

-- [[ ウィンドウ操作 ]]
-- Ctrl + hjkl でウィンドウ間を移動
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Leaderキーに続けて b, bn, bp を入力
keymap.set('n', '<leader>bc', '<cmd>bw<CR>', { desc = 'Close current buffer' })
keymap.set('n', '<leader>bn', '<cmd>bn<CR>', { desc = 'Move to next buffer' })
keymap.set('n', '<leader>bp', '<cmd>bp<CR>', { desc = 'Move to previous buffer' })

-- [[ ターミナル操作 ]]
-- Escキー2回でターミナルモードを抜ける
-- <C-\><C-n> はVimの標準的なターミナル離脱コマンド
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

