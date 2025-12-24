# Neovim プラグイン統合・DAP導入分析

## 概要

Snacks.nvim + blink.cmp を中心としたプラグイン統合の実現可能性と、nvim-dap導入コストの分析。

---

## 1. Snacks.nvim による統合可能性

### 1.1 Snacks.nvim の提供機能

Snacks.nvimは単一プラグインで以下の機能を提供：

| モジュール | 機能 | 代替対象 |
|-----------|------|---------|
| **picker** | ファジーファインダー | telescope.nvim |
| **diagnostics** | 診断表示・ジャンプ | trouble.nvim (部分的) |
| **terminal** | ターミナル統合 | toggleterm.nvim |
| **dashboard** | スタート画面 | mini-starter |
| **indent** | インデントガイド | indent-blankline.nvim |
| **notifier** | 通知システム | noice.nvim (部分的) |
| **git** | Git操作 | lazygit連携 |
| **words** | カーソル下の単語ハイライト | - |
| **zen** | Zenモード | - |

### 1.2 代替可能性の詳細分析

#### ✅ Telescope.nvim → Snacks.picker【完全代替可能】

```lua
-- 現在のtelescopeキーマップ対応表
-- telescope                    → snacks.picker
-- builtin.find_files           → Snacks.picker.files()
-- builtin.live_grep            → Snacks.picker.grep()
-- builtin.buffers              → Snacks.picker.buffers()
-- builtin.help_tags            → Snacks.picker.help()
-- builtin.keymaps              → Snacks.picker.keymaps()
-- builtin.diagnostics          → Snacks.picker.diagnostics()
-- builtin.lsp_definitions      → Snacks.picker.lsp_definitions()
-- builtin.lsp_references       → Snacks.picker.lsp_references()
-- builtin.lsp_document_symbols → Snacks.picker.lsp_symbols()
-- builtin.colorscheme          → Snacks.picker.colorschemes()
```

**メリット**:
- 依存関係ゼロ（plenary.nvim不要）
- Normal Modeサポート
- 高速な非同期処理
- Frecency（使用頻度）内蔵

**結論**: ✅ 完全移行可能

---

#### ⚠️ Trouble.nvim → Snacks.picker【部分的代替可能】

| Trouble機能 | Snacks代替 | 評価 |
|------------|-----------|------|
| diagnostics | `Snacks.picker.diagnostics()` | ✅ 代替可能 |
| symbols | `Snacks.picker.lsp_symbols()` | ✅ 代替可能 |
| lsp references | `Snacks.picker.lsp_references()` | ✅ 代替可能 |
| quickfix list | `Snacks.picker.qflist()` | ✅ 代替可能 |
| location list | `Snacks.picker.loclist()` | ✅ 代替可能 |

**Troubleの独自機能**:
- 固定ウィンドウでの診断リスト表示（常時表示）
- ファイルごとのグループ化UI
- `<leader>xx`でのトグル表示

**Snacksとの違い**:
- Snacks pickerはポップアップ形式（一時的）
- Troubleは固定サイドパネル形式（常時表示可能）

**結論**: 
- ⚠️ ワークフロー次第で代替可能
- 診断を「検索→ジャンプ」するならSnacksで十分
- 「常時監視パネル」が必要ならTrouble維持

**推奨**: Troubleは軽量なので**維持推奨**。Snacksと併用しても競合しない。

---

#### ✅ Toggleterm.nvim → Snacks.terminal【代替可能】

```lua
-- Snacks.terminal設定例
Snacks.terminal.toggle(nil, {
  win = {
    position = "float",  -- or "bottom", "right"
    width = 0.8,
    height = 0.8,
  }
})
```

| 機能 | Toggleterm | Snacks.terminal | Neovim標準 |
|------|-----------|-----------------|-----------|
| フローティング | ✅ | ✅ | ❌（手動設定要） |
| 水平/垂直split | ✅ | ✅ | ✅ |
| 永続セッション | ✅ | ✅ | ✅ |
| 複数ターミナルID | ✅ | ⚠️ 限定的 | ❌ |
| lazygit統合 | 別途設定 | ✅ 内蔵 | ❌ |

**結論**: 
- ✅ 基本的なターミナル用途なら完全代替可能
- Kitty使用中なら外部ターミナル利用も選択肢
- 複数ターミナルを厳密にID管理するならToggletterm維持

---

#### ⚠️ Outline.nvim → Snacks.picker.lsp_symbols【代替可能】

```lua
-- 現在のoutline.lua
vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>')

-- Snacksでの代替
vim.keymap.set('n', '<leader>o', function()
  Snacks.picker.lsp_symbols()
end)
```

**違い**:
- Outline: サイドパネルに常時表示、ツリー形式
- Snacks: ポップアップでファジー検索、選択後ジャンプ

**結論**: ✅ ファジー検索でジャンプするワークフローなら代替可能

---

#### ⚠️ mini-starter → Snacks.dashboard【代替可能だが要検討】

| 機能 | mini-starter | Snacks.dashboard |
|------|-------------|-----------------|
| カスタマイズ性 | 高い | 高い |
| アスキーアート | ✅ | ✅ |
| 最近のファイル | ✅ | ✅ |
| セッション復元 | 手動設定 | ✅ 内蔵 |
| プロジェクト | 手動設定 | ✅ 内蔵 |

**結論**: ✅ 代替可能。ただし現在のmini-starterに愛着があれば維持も可。

---

#### ❌ Noice.nvim【代替不可】

Snacks.notifierは通知機能のみ提供。Noice.nvimの以下の機能は代替不可：
- コマンドラインUIのオーバーレイ
- メッセージエリアの改善
- LSP進捗表示のオーバーレイ

**結論**: ❌ Noice.nvimは維持

---

#### ❌ indent-blankline.nvim【Snacks.indentで代替可能だが...】

Snacks.indentはインデントガイドを提供するが、現在の`blankline.lua`の設定次第。

**結論**: ⚠️ 機能的には代替可能。現設定の確認が必要。

---

## 2. Blink.cmp による統合可能性

### 2.1 Blink.cmpの内蔵機能

| 機能 | 内蔵 | 代替対象 |
|------|------|---------|
| LSP補完 | ✅ | cmp-nvim-lsp |
| Path補完 | ✅ | cmp-path |
| スニペット | ✅ | LuaSnip + cmp_luasnip |
| Buffer補完 | ✅ | cmp-buffer |
| アイコン表示 | ✅ | lspkind-nvim |
| auto-brackets | ✅ | nvim-autopairs (部分的) |
| Fuzzy matching | ✅ (Rust backend) | - |

### 2.2 削除可能なプラグイン

blink.cmp導入により以下を削除可能：

```
❌ hrsh7th/nvim-cmp
❌ hrsh7th/cmp-nvim-lsp
❌ hrsh7th/cmp-path
❌ saadparwaiz1/cmp_luasnip
❌ L3MON4D3/LuaSnip
❌ onsails/lspkind-nvim
⚠️ windwp/nvim-autopairs (auto-bracketsで部分代替)
```

### 2.3 Autopairs について

| シナリオ | nvim-autopairs | blink.cmp auto-brackets |
|---------|---------------|------------------------|
| LSP補完後の括弧 | ✅ | ✅ |
| 手動入力`(`で`)` | ✅ | ❌ |
| 手動入力`[`で`]` | ✅ | ❌ |
| 手動入力`{`で`}` | ✅ | ❌ |
| クォート補完 | ✅ | ❌ |

**結論**: 
- 手動入力時の自動ペアが必要 → nvim-autopairs維持
- LSP補完時のみで十分 → 削除可能

---

## 3. 統合後の構成案

### 最小構成（積極的統合）

```
plugins/
├── lsp/
│   ├── lspconfig.lua      # LSP設定
│   ├── blink.lua          # 補完（nvim-cmp代替）
│   ├── format.lua
│   ├── lazydev.lua
│   └── nvim-lint.lua
├── snacks.lua             # picker, terminal, dashboard, indent
├── trouble.lua            # 診断パネル（維持推奨）
├── which-key.lua
├── gitsigns.lua
├── lualine.lua
├── treesitter.lua
├── colorscheme.lua
├── noice.lua
├── hlslens.lua
├── csvview.lua
├── render-markdown.lua
└── todo-comments.lua

nvim-copilot/
├── copilot.lua
└── copilotchat.lua
```

**削除されるプラグイン（計14個）**:
- telescope.nvim + plenary + fzf-native + ui-select (4)
- nvim-cmp + cmp-nvim-lsp + cmp-path + cmp_luasnip + LuaSnip + lspkind (6)
- toggleterm.nvim (1)
- outline.nvim (1)
- mini-starter (1)
- comment.nvim (1)

### バランス構成（推奨）

```
plugins/
├── lsp/
│   ├── lspconfig.lua
│   ├── blink.lua          # 補完
│   ├── format.lua
│   ├── lazydev.lua
│   └── nvim-lint.lua
├── snacks.lua             # picker, terminal
├── trouble.lua            # 診断（維持）
├── which-key.lua
├── gitsigns.lua
├── lualine.lua
├── treesitter.lua
├── colorscheme.lua
├── noice.lua
├── hlslens.lua
├── blankline.lua          # 維持（Snacks.indentより安定）
├── csvview.lua
├── render-markdown.lua
├── mini-starter.lua       # 維持（カスタマイズ済み）
├── autopairs.lua          # 維持（手動入力対応）
└── todo-comments.lua
```

**削除されるプラグイン（計12個）**:
- telescope関連 (4)
- nvim-cmp関連 (6)
- toggleterm (1)
- outline (1)

---

## 4. nvim-dap 導入コスト分析

### 4.1 基本構成

```lua
-- 必須プラグイン
{
  'mfussenegger/nvim-dap',           -- コアDAP
  -- 以下どちらか選択
  'rcarriga/nvim-dap-ui',            -- フル機能UI
  -- または
  'igorlfs/nvim-dap-view',           -- ミニマルUI
}
```

### 4.2 nvim-dap-ui vs nvim-dap-view

| 項目 | nvim-dap-ui | nvim-dap-view |
|------|------------|---------------|
| **依存関係** | nvim-dap, nvim-nio | nvim-dap のみ |
| **Neovim要件** | 0.9+ | 0.11+ ✅（現在0.11.5） |
| **UI構成** | 複数パネル（変数、スタック、ウォッチ等） | 単一統合ウィンドウ |
| **設定量** | 中〜多（レイアウト・要素の設定） | 少（ほぼデフォルトでOK） |
| **カスタマイズ** | 高い（アイコン、レイアウト自由自在） | 限定的 |
| **学習コスト** | 中（ドキュメント豊富） | 低（`g?`でヘルプ表示） |
| **用途** | IDE的フルデバッグ | シンプル・高速デバッグ |

### 4.3 設定コスト見積もり

#### nvim-dap-ui を選択した場合

```lua
-- plugins/lsp/dap.lua (約80-120行)
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      -- 言語別アダプター（必要に応じて）
      'mfussenegger/nvim-dap-python',      -- Python
      'leoluz/nvim-dap-go',                 -- Go
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      
      dapui.setup()
      
      -- 自動UI開閉
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      
      -- 言語別設定（Python例）
      require('dap-python').setup('python')
      
      -- Go例
      require('dap-go').setup()
    end,
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step Into' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'Step Over' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'Step Out' },
      { '<leader>dr', function() require('dap').repl.open() end, desc = 'Open REPL' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle DAP UI' },
    },
  },
}
```

**追加設定コスト**:
- 基本設定: 約1時間
- Python/Go等のアダプター設定: 言語ごとに約30分
- カスタムレイアウト: 追加1-2時間
- **合計: 2-4時間**

#### nvim-dap-view を選択した場合

```lua
-- plugins/lsp/dap.lua (約50-70行)
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'igorlfs/nvim-dap-view',
      -- 言語別アダプター
      'mfussenegger/nvim-dap-python',
      'leoluz/nvim-dap-go',
    },
    config = function()
      local dap = require('dap')
      
      -- dap-viewはほぼデフォルトでOK
      require('dap-view').setup()
      
      -- 言語別設定
      require('dap-python').setup('python')
      require('dap-go').setup()
    end,
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step Into' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'Step Over' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'Step Out' },
      { '<leader>dv', '<cmd>DapViewToggle<cr>', desc = 'Toggle DAP View' },
    },
  },
}
```

**追加設定コスト**:
- 基本設定: 約30分
- 言語アダプター: 言語ごとに約30分
- **合計: 1-2時間**

### 4.4 言語別アダプター設定

現在のLSP設定から推測される使用言語：

| 言語 | アダプター | 設定難易度 | 備考 |
|------|-----------|-----------|------|
| Python | nvim-dap-python | 低 | debugpyインストール要 |
| Go | nvim-dap-go | 低 | delveインストール要 |
| TypeScript/JS | nvim-dap-vscode-js | 中 | vscode-js-debug要 |
| Bash | bash-debug-adapter | 中 | 別途インストール要 |
| Lua (Neovim) | one-small-step-for-vimkind | 低 | - |

### 4.5 推奨

**nvim-dap-view を推奨**

理由:
1. Neovim 0.11.5で動作確認済み
2. 設定が最小限
3. 依存関係が少ない（nvim-nioが不要）
4. 統合UIで学習コストが低い
5. 必要に応じて後からnvim-dap-uiへ移行可能

---

## 5. 最終構成案とプラグイン数

### Before（現在）

```
プラグイン総数: 約28個

picker系:      4 (telescope + 依存3)
補完系:        7 (nvim-cmp + 依存6)
LSP系:         5 (lspconfig, mason系, fidget, lazydev)
UI系:          8 (lualine, bufferline, noice, which-key, blankline, mini-starter, oil, colorscheme)
Git系:         1 (gitsigns)
編集系:        4 (treesitter, autopairs, comment, todo-comments)
その他:        5 (toggleterm, outline, trouble, hlslens, render-markdown, csvview)
Copilot:       2
```

### After（推奨構成）

```
プラグイン総数: 約18個 + DAP3個 = 21個

Snacks:        1 (picker, terminal統合)
補完系:        1 (blink.cmp)
LSP系:         5 (lspconfig, mason系, fidget, lazydev)
UI系:          8 (lualine, noice, which-key, blankline, mini-starter, oil, colorscheme系5)
Git系:         1 (gitsigns)
編集系:        4 (treesitter, autopairs, todo-comments, render-markdown)
その他:        4 (trouble, hlslens, csvview, nvim-lint)
Copilot:       2
DAP:           3 (nvim-dap, dap-view, dap-python/go)
```

**削減**: 28 → 21 = **7プラグイン削減**（DAP追加込み）

---

## 6. 実装優先順位

### Phase 1: 低リスク（推定1時間）
1. comment.lua削除
2. outline.lua削除（trouble.nvimのsymbolsに統一）

### Phase 2: Picker移行（推定2時間）
3. Snacks.nvimインストール（picker + terminal）
4. キーマップ移行
5. Telescope関連削除

### Phase 3: 補完エンジン移行（推定2時間）
6. blink.cmpインストール
7. lspconfig.luaの`capabilities`更新
8. nvim-cmp関連削除

### Phase 4: DAP導入（推定2時間）
9. nvim-dap + nvim-dap-view設定
10. 必要な言語アダプター設定（Python, Go）

### Phase 5: 検証（推定1-2日）
11. 全機能の動作確認
12. 実運用テスト

**総推定時間: 7-8時間 + 検証1-2日**

---

## 7. 参考リンク

- [Snacks.nvim GitHub](https://github.com/folke/snacks.nvim)
- [Snacks.nvim Picker Docs](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)
- [Snacks.nvim Terminal Docs](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md)
- [blink.cmp GitHub](https://github.com/Saghen/blink.cmp)
- [blink.cmp Docs](https://cmp.saghen.dev/)
- [nvim-dap GitHub](https://github.com/mfussenegger/nvim-dap)
- [nvim-dap-view GitHub](https://github.com/igorlfs/nvim-dap-view)
- [nvim-dap-ui GitHub](https://github.com/rcarriga/nvim-dap-ui)
