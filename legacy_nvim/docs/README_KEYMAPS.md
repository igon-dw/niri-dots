# Neovim キーマップ使用状況ガイド

このドキュメントでは、Neovim設定のキーマップ使用状況を確認する方法を説明します。

## キーマップの確認方法

### 1. Pythonスクリプトを使用

```bash
# ターミナルから実行
python3 ~/dotfiles/nvim/check_keymaps.py

# または、dotfilesディレクトリから
cd ~/dotfiles/nvim
./check_keymaps.py
```

このスクリプトは以下の情報を表示します：
- 現在のLeaderキー設定
- モード別のキーマップ一覧
- `<leader>` プレフィックス別グループ
- 利用可能なキーバインドの提案

### 2. Neovim内から確認

Neovim内で以下のコマンドを実行：

```vim
:Telescope keymaps
```

これでインタラクティブにキーマップを検索・確認できます。

### 3. 特定のモードのキーマップを確認

```vim
:map     " Normal, Visual, Select, Operator-pendingモード
:nmap    " Normalモード
:imap    " Insertモード
:vmap    " Visual/Selectモード
:tmap    " Terminalモード
```

## 現在の設定状況

### Leaderキー
- **Leader**: `<Space>` (スペースキー)
- **LocalLeader**: `\` (バックスラッシュ)

### 使用済みプレフィックス

| プレフィックス | 用途 | 個数 |
|---------------|------|------|
| `<leader>s*` | Search関連 (Telescope) | 12個 |
| `<leader>b*` | Buffer操作 | 3個 |
| `<leader>a*` | AI関連 (Copilot) ※オプション | 1個 |
| `<leader>l*` | その他 | 1個 |

### 利用可能なプレフィックス（推奨）

以下のプレフィックスはまだ使用されていません：

| プレフィックス | 推奨用途 |
|---------------|---------|
| `<leader>e*` | Edit/Error |
| `<leader>f*` | Files/Find |
| `<leader>g*` | Git |
| `<leader>h*` | Help/Hunk |
| `<leader>m*` | Mark/Macro |
| `<leader>n*` | Notes/New |
| `<leader>o*` | Open/Outline |
| `<leader>p*` | Project/Preview |
| `<leader>q*` | Quit/Quickfix |
| `<leader>t*` | Test/Tab/Toggle |
| `<leader>u*` | UI/Undo |
| `<leader>v*` | View/Version |
| `<leader>x*` | Execute |
| `<leader>y*` | Yank |
| `<leader>z*` | Fold |

### Ctrlキーの使用状況

**使用済み:**
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` - ウィンドウ間の移動

**利用可能:**
- `<C-n>`, `<C-p>` - 通常は補完候補の選択に使用
- `<C-u>`, `<C-d>` - 半画面スクロール（デフォルト）
- `<C-w>` - ウィンドウコマンドのプレフィックス（デフォルト）
- `<C-e>`, `<C-y>` - スクロール（デフォルト）
- その他多数

### Alt/Metaキー

現在、Alt/Metaキーの組み合わせはほとんど使用されていません。
以下のような用途に使用できます：

- `<M-j>`, `<M-k>` - バッファ間の移動
- `<M-h>`, `<M-l>` - タブ間の移動
- `<M-1>`～`<M-9>` - タブ番号で直接移動

## 新しいキーバインドを追加する際のベストプラクティス

1. **競合チェック**: このスクリプトを実行して既存のキーバインドと競合しないか確認
2. **グループ化**: 関連する機能は同じプレフィックスでまとめる
3. **説明追加**: `desc` パラメータで必ず説明を追加
4. **モード選択**: 適切なモードを選択（Normal, Insert, Visual等）

### 例：新しいキーバインドの追加

```lua
-- config/keymaps.lua または適切なプラグイン設定ファイルに追加

-- Gitコマンド用のキーバインド（<leader>g* プレフィックス）
vim.keymap.set('n', '<leader>gs', '<cmd>Git status<CR>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = '[G]it [C]ommit' })
vim.keymap.set('n', '<leader>gp', '<cmd>Git push<CR>', { desc = '[G]it [P]ush' })

-- Toggle機能（<leader>t* プレフィックス）
vim.keymap.set('n', '<leader>tn', '<cmd>set number!<CR>', { desc = '[T]oggle [N]umber' })
vim.keymap.set('n', '<leader>tr', '<cmd>set relativenumber!<CR>', { desc = '[T]oggle [R]elative number' })
```

## 参考リンク

- [Neovim キーマップドキュメント](https://neovim.io/doc/user/map.html)
- [Which-key.nvim](https://github.com/folke/which-key.nvim) - キーバインドのビジュアル表示プラグイン（導入検討）
