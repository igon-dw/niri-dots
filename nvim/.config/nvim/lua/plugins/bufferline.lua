-- bufferline.nvim プラグインの設定テーブルを返します
return {
  -- プラグインのリポジトリ名（GitHub: akinsho/bufferline.nvim）
  'akinsho/bufferline.nvim',
  -- 利用するバージョン（*は最新版を意味します）
  version = '*',
  -- 依存プラグイン（アイコン表示用）
  dependencies = 'nvim-tree/nvim-web-devicons',
  -- プラグインのセットアップ関数
  config = function()
    require('bufferline').setup {}
  end,
}
