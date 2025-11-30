-- lazy.nvim用プラグイン定義リスト
return {
  {
    -- プラグイン名 (GitHubリポジトリ)
    'akinsho/toggleterm.nvim',
    -- バージョン指定 ('*'は最新安定版)
    version = '*',
    -- 読み込みタイミングの指定 (VeryLazyによる遅延読み込み)
    -- 起動高速化のため、関連コマンド実行時まで読み込みを遅延
    event = 'VeryLazy',
    -- プラグイン読み込みのトリガーとなるコマンド
    cmd = 'Toggleterm',
    -- プラグインのオプション設定
    opts = {
      -- ターミナルのデフォルトシェル指定
      shell = '/bin/fish',
    },
    -- プラグイン用のキーマップ定義
    keys = {
      -- フローティング形式でのターミナル起動
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggleterm (float)' },
      -- 水平分割でのターミナル起動
      { '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', desc = 'Toggleterm (horizontal)' },
      -- 垂直分割でのターミナル起動
      {
        '<leader>tv',
        -- 動的なサイズ計算のためのLua関数
        function()
          -- 画面幅の半分を計算 (整数化)
          local size = math.floor(vim.o.columns / 2)
          -- 計算したサイズをコマンドに結合
          vim.cmd('ToggleTerm direction=vertical size=' .. size)
        end,
        desc = 'Toggleterm (vertical 50%)',
      },
    },
  },
}

