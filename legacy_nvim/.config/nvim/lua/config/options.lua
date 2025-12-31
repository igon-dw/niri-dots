local opt = vim.opt

-- [[ 表示関連 ]]
opt.number = true -- 行番号の表示
opt.cursorline = true -- カーソル行のハイライト
opt.signcolumn = 'yes' -- サインカラムの常時表示（LSPの警告やGitの差分表示用）

-- [[ インデント・タブ設定 ]]
opt.shiftwidth = 2 -- 自動インデントの幅
opt.expandtab = true -- タブのスペースへの変換
opt.softtabstop = 2 -- Tabキーを押した際のインデント幅
opt.breakindent = true -- 折り返し時のインデント維持
opt.tabstop = 2 -- ファイル内でのタブの幅

-- [[ 検索設定 ]]
opt.ignorecase = true -- 検索時の大文字・小文字の非区別
opt.smartcase = true -- 検索文字列に大文字が含まれる場合の区別

-- [[ UI/UX設定 ]]
opt.list = true -- 不可視文字の表示
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- 不可視文字の表示形式
opt.splitright = true -- 垂直分割時の新規ウィンドウ右側配置
opt.splitbelow = true -- 水平分割時の新規ウィンドウ下側配置
opt.mouse = 'a' -- 全モードでのマウス有効化
opt.timeoutlen = 500 -- キー入力の待機時間（ms）。0だとマッピングの解決が速すぎる場合あり

-- [[ コマンド・その他 ]]
opt.inccommand = 'split' -- コマンドプレビューの分割ウィンドウ表示

-- [[ LSPの診断メッセージのアイコン設定 ]]
-- '', '', '', '󰌵' のようなアイコンを表示するには、Nerd Fontの導入が必要
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '', -- エラー
      [vim.diagnostic.severity.WARN] = '', -- 警告
      [vim.diagnostic.severity.INFO] = '', -- 情報
      [vim.diagnostic.severity.HINT] = '󰌵', -- ヒント
    },
  },
}
