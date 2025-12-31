-- CopilotChat プラグインの設定テーブルを返します
return {
  -- プラグインのリポジトリ指定
  'CopilotC-Nvim/CopilotChat.nvim',
  -- 依存プラグインの指定（plenary.nvimは多くのLuaプラグインで利用されます）
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- プラグインの設定処理
  config = function()
    -- CopilotChatプラグインのセットアップを実行
    require('CopilotChat').setup {}
    -- <leader>ai キーマップで CopilotChat を起動できるように設定
    vim.keymap.set('n', '<leader>ai', '<cmd>CopilotChat<CR>', { desc = 'CopilotChatを開く' })
  end,
}
