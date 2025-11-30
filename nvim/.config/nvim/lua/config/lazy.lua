-- lazy.nvimのパスを設定
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- lazy.nvimがインストールされていない場合、GitHubからクローン
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  -- --filter=blob:none と --branch=stable を使い、最小限のデータで安定版をクローン
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath) -- lazy.nvimをランタイムパスに追加

-- LeaderキーとLocal Leaderキーをlazy.nvim読み込み前に設定
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- lazy.nvimのセットアップ
require('lazy').setup {
  -- プラグインの仕様を記述する場所
  spec = {
    -- 'plugins' ディレクトリ内のLuaファイルをプラグインとしてインポート
    { import = 'plugins' },
    -- 'plugins.lsp' ディレクトリ内のLSP関連プラグインもインポート
    { import = 'plugins.lsp' },
  },
  -- デフォルト設定
  defaults = {
    lazy = false, -- プラグインの遅延読み込みをデフォルトで無効に
    version = false, -- バージョン指定を厳密にチェックしない
  },
  -- プラグインの更新を自動でチェック（通知はオフ）
  checker = { enabled = true, notify = false },
  -- パフォーマンス設定
  performance = {
    rtp = {
      -- 起動高速化のため、不要な標準プラグインを無効化
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}
