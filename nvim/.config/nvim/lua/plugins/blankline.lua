-- indent-blankline.nvim プラグインの設定テーブルを返します
return {
  -- プラグインのリポジトリ名（GitHub: lukas-reineke/indent-blankline.nvim）
  'lukas-reineke/indent-blankline.nvim',
  -- プラグインのメインモジュール名
  main = 'ibl',
  ---@module "ibl"  -- Neovim の型アノテーション
  ---@type ibl.config -- ibl の設定型
  opts = {
    indent = {
      -- インデントごとに色分けするハイライトグループ
      highlight = {
        'RainbowRed',    -- 赤色のインデント
        'RainbowYellow', -- 黄色のインデント
        'RainbowBlue',   -- 青色のインデント
        'RainbowOrange', -- オレンジ色のインデント
        'RainbowGreen',  -- 緑色のインデント
        'RainbowViolet', -- 紫色のインデント
        'RainbowCyan',   -- シアン色のインデント
      },
    },
  },
  -- プラグインのセットアップ関数
  config = function(_, opts)
    -- ibl.hooks モジュールを読み込み
    local hooks = require 'ibl.hooks'
    -- ハイライト設定のフックを登録
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- 各ハイライトグループに色を割り当て
      vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
      vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
      vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
      vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
      vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
    end)
    -- プラグインのセットアップを実行
    require('ibl').setup(opts)
  end,
}
