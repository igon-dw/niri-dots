# Neovim設定リファクタリング計画

## 1. 現状分析

### 環境情報
- **Neovimバージョン**: v0.11.5
- **プラグインマネージャ**: lazy.nvim
- **構成**: `nvim` + `nvim-copilot` ディレクトリをstowでリンク

### 現在のプラグイン構成

| プラグイン | 用途 | ステータス |
|-----------|------|-----------|
| comment.lua | コメントトグル | ❌ **削除可能** |
| autopairs.lua | 括弧自動補完 | ⚠️ 要検討 |
| oil.lua | ファイルナビゲータ | ✅ 維持 |
| todo-comments.lua | TODOハイライト | ✅ 維持 |
| which-key.lua | キーマップヘルプ | ✅ 維持 |
| blankline.lua | インデントガイド | ✅ 維持 |
| csvview.lua | CSV表示 | ✅ 維持 |
| lualine.lua | ステータスライン | ✅ 維持 |
| outline.lua | シンボルアウトライン | ⚠️ 要検討 |
| toggleterm.lua | ターミナル統合 | ⚠️ 要検討 |
| bufferline.lua | バッファタブ | ⚠️ 要検討 |
| gitsigns.lua | Git差分表示 | ✅ 維持 |
| mini-starter.lua | スタート画面 | ✅ 維持 |
| render-markdown.lua | MDプレビュー | ✅ 維持 |
| treesitter.lua | 構文ハイライト | ✅ 維持 |
| colorscheme.lua | カラースキーム | ✅ 維持 |
| hlslens.lua | 検索強化 | ✅ 維持 |
| noice.lua | UI通知 | ✅ 維持 |
| telescope.lua | ファジーファインダー | 🔄 **移行候補** |
| trouble.lua | 診断リスト | ✅ 維持 |
| **LSP関連** | | |
| nvim-lspconfig | LSP設定 | 🔄 **簡素化可能** |
| mason.nvim | LSPインストーラ | ✅ 維持 |
| nvim-cmp | 補完エンジン | 🔄 **移行候補** |
| LuaSnip | スニペット | 🔄 **blink.cmpで代替可能** |
| fidget.nvim | LSP進捗表示 | ✅ 維持 |
| **Copilot** | | |
| copilot.lua | AI補完 | ✅ 維持 |
| copilotchat.lua | AIチャット | ✅ 維持 |

---

## 2. 現状認識の検証結果

### ✅ 正しい認識

1. **comment.lua（numToStr/Comment.nvim）**
   - Neovim 0.10+で`gc`コメント機能が標準搭載
   - **結論**: 削除可能（ただし完全互換ではないため挙動確認推奨）

2. **oil.nvim**
   - 代替なし、バッファスタイルのファイル操作は独自
   - **結論**: 維持

3. **todo-comments.lua**
   - 標準機能なし
   - **結論**: 維持

4. **which-key.lua**
   - 標準機能なし、Neovimの学習曲線を下げる必須プラグイン
   - **結論**: 維持

5. **lualine.lua, gitsigns.lua, render-markdown.lua, treesitter.lua, colorscheme.lua, hlslens.lua, noice.lua, trouble.lua, mini-starter.lua**
   - すべて現時点で代替なし、用途明確
   - **結論**: 維持

### ⚠️ 検討が必要な認識

1. **autopairs.lua**
   - 標準機能には**まだ含まれていない**
   - しかし、blink.cmpには`auto_brackets`機能が内蔵されており、LSP補完時の自動括弧挿入をカバー
   - **推奨**: 手動入力時の括弧補完も欲しい場合は維持、そうでなければ削除しblink.cmpで代替

2. **outline.lua（hedyhli/outline.nvim）**
   - Telescope + LSP(`lsp_document_symbols`)で同等機能を提供可能
   - trouble.nvimの`symbols`機能（`<leader>cs`）でも代替可能
   - **推奨**: trouble.nvimのsymbols機能に統合し、outline.nvimは削除

3. **toggleterm.lua**
   - Kitty使用中であれば、ターミナルマルチプレクサ（kitty splits/tabs）で代替可能
   - Neovim内蔵`:terminal`も改善済み
   - **推奨**: ワークフロー次第。Neovim内で完結したい場合は維持、外部ターミナル活用なら削除

4. **bufferline.lua**
   - 複数バッファ管理に有用だが、telescope/snacks pickerのバッファ検索でも代替可能
   - 視覚的なタブ表示が不要なら削除可能
   - **推奨**: 好みによる。スリム化優先なら削除、視認性優先なら維持

---

## 3. 最新機能への移行提案

### 3.1 Picker: Telescope → Snacks.nvim Picker

| 項目 | Telescope | Snacks.nvim |
|------|-----------|-------------|
| 速度 | 中 | 高速 |
| 依存関係 | plenary + fzf-native + ui-select | なし（単一プラグイン） |
| Normal Mode | ❌ | ✅ |
| Frecency | 拡張必要 | 内蔵 |
| 開発者 | Telescope Team | Folke (LazyVim作者) |

**推奨理由**:
- 依存関係の大幅削減
- LazyVimで実績あり
- 高速でモダンなUI
- 現在のtelescopeキーマップを維持しつつ移行可能

### 3.2 補完: nvim-cmp → blink.cmp

| 項目 | nvim-cmp | blink.cmp |
|------|----------|-----------|
| 速度 | 良好 | 非常に高速（Rust backend） |
| 依存関係 | LuaSnip, cmp-path, cmp-lsp等 | 内蔵（snippets, path, lsp） |
| ファジーマッチ | 良好 | typo耐性あり、優秀 |
| auto-brackets | 外部依存 | 内蔵 |
| 設定複雑度 | 高い | 低い（sensible defaults） |

**推奨理由**:
- 依存関係を大幅削減（LuaSnip, cmp-luasnip, cmp-path, cmp-nvim-lsp, lspkind を統合可能）
- Neovim 0.11の高速化と相性が良い
- kickstart.nvimでも採用が検討されている

### 3.3 LSP設定: 簡素化

Neovim 0.11ではLSP設定がさらに簡素化されています：
- `vim.lsp.config`による設定が可能
- ただし、Masonとの連携やhandlers設定には引き続きnvim-lspconfigが有用

**推奨**: 現在の構成を維持しつつ、不要なコメントを削除してスリム化

---

## 4. 悩みへの提案

### 4.1 ブランチ分けか新ディレクトリか

**推奨: Git ブランチ方式**

| 方式 | メリット | デメリット |
|------|---------|----------|
| ブランチ分け | 履歴管理が容易、差分が明確 | 同時利用が面倒 |
| 新ディレクトリ | 並行利用が容易 | 重複管理、stow設定が複雑化 |

**具体的な提案**:
```bash
# 現在のmainブランチは保持
git checkout -b nvim-v2

# 開発完了後、mainにマージ
# 旧設定が必要な場合はgit stashやブランチ切り替えで対応
```

もしくは**ハイブリッド方式**:
- `nvim-legacy/` として旧設定を保存
- `nvim/` で新設定を開発
- 安定したらlegacyを削除

### 4.2 Telescope代替

**推奨: Snacks.nvim Picker**

理由:
- 依存ゼロ（plenary不要）
- Folke製でLazyVim/lazy.nvimとの親和性が高い
- Normal modeサポート
- 既存のキーマップ体系を維持可能

### 4.3 toggleterm.lua

**推奨: 削除**

理由:
- Kitty使用中であればターミナル側で十分
- `Ctrl+Shift+Enter`で新しいKittyウィンドウ/タブ/splitを開ける
- Neovimの起動速度向上に貢献

代替案として`:terminal`を活用する場合のキーマップ例:
```lua
vim.keymap.set('n', '<leader>tt', '<cmd>terminal<cr>', { desc = 'Open terminal' })
```

---

## 5. 実装フェーズ計画

### Phase 1: 準備（低リスク）
1. [ ] 新ブランチ`nvim-v2`を作成
2. [ ] comment.luaを削除（標準gc使用）
3. [ ] outline.luaを削除（trouble.nvimのsymbolsに統一）

### Phase 2: Picker移行（中リスク）
4. [ ] Snacks.nvim pickerをインストール
5. [ ] キーマップをsnacks.picker形式に移行
6. [ ] Telescope関連プラグインを削除
   - telescope.nvim
   - plenary.nvim（他で使用していなければ）
   - telescope-fzf-native.nvim
   - telescope-ui-select.nvim

### Phase 3: 補完エンジン移行（中〜高リスク）
7. [ ] blink.cmpをインストール
8. [ ] nvim-cmp関連を削除
   - nvim-cmp
   - cmp-nvim-lsp
   - cmp-path
   - cmp-luasnip
   - LuaSnip
   - lspkind-nvim
9. [ ] lspconfig.luaの`capabilities`設定をblink.cmp用に更新

### Phase 4: 最適化（低リスク）
10. [ ] toggleterm.luaを削除（任意）
11. [ ] bufferline.luaを削除（任意）
12. [ ] autopairs.luaを削除（blink.cmpのauto_bracketsで代替、任意）

### Phase 5: 検証・安定化
13. [ ] 各言語でLSP動作確認（Lua, Python, TypeScript, Go, Bash, YAML, Docker）
14. [ ] Copilot/CopilotChat動作確認
15. [ ] 1週間程度の実運用テスト
16. [ ] 問題なければmainにマージ

---

## 6. 移行後の想定構成

```
nvim/.config/nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── autocmds.lua
│   └── plugins/
│       ├── lsp/
│       │   ├── lspconfig.lua    # 簡素化
│       │   ├── blink.lua        # 新規（nvim-cmp置換）
│       │   ├── format.lua
│       │   ├── lazydev.lua
│       │   └── nvim-lint.lua
│       ├── snacks.lua           # 新規（telescope置換）
│       ├── oil.lua
│       ├── which-key.lua
│       ├── trouble.lua
│       ├── gitsigns.lua
│       ├── lualine.lua
│       ├── treesitter.lua
│       ├── colorscheme.lua
│       ├── noice.lua
│       ├── hlslens.lua
│       ├── blankline.lua
│       ├── csvview.lua
│       ├── render-markdown.lua
│       ├── mini-starter.lua
│       └── todo-comments.lua

nvim-copilot/.config/nvim/lua/plugins/
├── copilot.lua
└── copilotchat.lua
```

### 削除されるプラグイン（計11個）
- comment.lua → 標準機能
- outline.lua → trouble.nvimに統合
- telescope.lua + 3依存 → snacks.nvim
- nvim-cmp + 5依存 → blink.cmp
- toggleterm.lua → Kitty使用（任意）
- bufferline.lua → 好みによる（任意）
- autopairs.lua → blink.cmpで代替（任意）

### プラグイン数の変化
- **現在**: 約25プラグイン
- **移行後**: 約16〜18プラグイン（依存含まず）

---

## 7. リスクと対策

| リスク | 対策 |
|-------|------|
| blink.cmpの安定性 | 0.11.5で動作確認済み、問題あればnvim-cmpに戻す |
| snacks.pickerの機能不足 | Telescopeのキーマップを互換レイヤーで維持可能 |
| 標準コメント機能の違い | `gc`/`gcc`の挙動を確認、不足あればmini.commentへ |
| Copilot連携 | blink.cmp-copilotソースが存在、連携可能 |

---

## 8. 参考リンク

- [Neovim 0.11 What's New](https://gpanders.com/blog/whats-new-in-neovim-0-11/)
- [blink.cmp GitHub](https://github.com/Saghen/blink.cmp)
- [Snacks.nvim (Folke)](https://github.com/folke/snacks.nvim)
- [LazyVim Snacks Picker](https://www.lazyvim.org/extras/editor/snacks_picker)
- [kickstart.nvim blink.cmp discussion](https://github.com/nvim-lua/kickstart.nvim/issues/1331)

---

## 9. 次のアクション

1. このドキュメントの内容を確認し、方針に同意するか判断してください
2. 同意の場合、Phase 1から順次実装を開始します
3. 各フェーズ完了後に動作確認を行い、問題があれば調整します

質問や追加要望があればお知らせください。
