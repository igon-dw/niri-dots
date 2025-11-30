-- nvim-autopairs プラグインの設定テーブルを返します
return {
  -- プラグインのリポジトリ名（GitHub: windwp/nvim-autopairs）
  'windwp/nvim-autopairs',
  -- Insert モードに入った時にプラグインを読み込むイベント
  event = 'InsertEnter',
  -- デフォルト設定を有効化（true で setup 関数を自動実行）
  config = true,
  -- プラグインの追加オプション（空テーブルでデフォルト設定）
  opts = {},
}
