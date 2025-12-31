-- lazydev.nvim（Lua開発支援プラグイン）の設定テーブルを返します。
return {
  -- プラグイン本体を指定します。
  'folke/lazydev.nvim',
  -- Luaファイルを開いた時のみ有効化します。
  ft = 'lua',
  -- プラグインのオプション設定です。
  opts = {
    library = {
      -- vim.uvという単語が見つかった時にluvitの型定義を読み込みます。
      { path = 'luvit-meta/library', words = { 'vim%.uv' } },
    },
  },
}
