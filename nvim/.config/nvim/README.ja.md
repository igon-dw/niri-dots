# Neovim Configuration

このドキュメントは `niri-dots` リポジトリ内の `nvim/.config/nvim` 配下だけを対象にした詳細ガイドです。  
リポジトリ全体の導入方法や Wayland デスクトップ全体の説明はルートの `README.md` / `README.ja.md` を参照してください。ここでは Neovim 設定そのものの設計、依存、運用、拡張方法に絞って説明します。

## 概要

この設定は、Neovim の組み込み機能を軸にしつつ、UI と日常操作をプラグインで補強する構成です。狙っているのは次の 4 点です。

- 起動直後から使える実用的な開発環境であること
- ファイル検索、LSP、Git、Markdown を軽量な操作で回せること
- 外部 CLI ツールを活かし、GUI に依存しすぎないこと
- AI 補助やブラウザプレビューのような拡張を必要なときだけ有効にできること

現行構成は `Snacks.nvim` を中心に、`lazy.nvim` でプラグイン管理、`mason.nvim` で LSP/formatter/debugger の導入を補助する形です。

## 想定環境

この設定は以下の前提で管理しています。

- Neovim `0.12.1` で確認
- Linux デスクトップ環境
- true color を扱えるターミナル
- Nerd Font が使えるフォント環境
- `git` が利用可能

古い Neovim では API 差分により一部設定が動かない可能性があります。特に Tree-sitter、`vim.iter`、LSP 周りは最近の Neovim 前提です。

### ターミナル要件

この設定は単に「Neovim が起動する」だけではなく、端末側にもいくつか前提があります。

- true color 対応
- Nerd Font 対応
- `Alt` / `Meta` キーが Neovim にそのまま渡ること
- ポップアップや分割 UI を見やすく表示できる十分な画面幅

`Alt` キーが重要なのは、Copilot の主要キーバインドが `Alt+Y`, `Alt+W`, `Alt+L`, `Alt+[`, `Alt+]` に割り当てられているためです。端末エミュレータや WM 側がこれらを奪うと、そのままでは使えません。

## ディレクトリ構成

```text
nvim/.config/nvim/
├── init.lua
├── lazy-lock.json
├── .stylua.toml
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── markdown_preview.lua
│   │   └── options.lua
│   └── plugins/
│       ├── *.lua
│       └── lsp/
│           ├── blink.lua
│           ├── lazydev.lua
│           └── lspconfig.lua
└── testdata/
    └── markdown-preview-mermaid.md
```

構成の役割は次の通りです。

- `init.lua`: 起動時のエントリポイント
- `lua/config/`: 基本設定、キーマップ、autocmd、ローカル helper
- `lua/plugins/`: plugin spec 単位の設定
- `lua/plugins/lsp/`: LSP と補完関連の設定
- `lazy-lock.json`: plugin version lock
- `testdata/`: Markdown ブラウザプレビューの確認用ファイル

## 起動シーケンス

起動時の読み込み順はかなり単純です。

1. `init.lua` が `options.lua`, `lazy.lua`, `keymaps.lua`, `autocmds.lua` を順番に読む
2. `lazy.lua` が `lazy.nvim` を bootstrap し、leader を設定する
3. `lazy.nvim` が `lua/plugins` と `lua/plugins/lsp` の spec を読み込む
4. plugin ごとの `event`, `ft`, `cmd`, `keys` 条件に従って遅延読み込みする

このため、設定を追うときはまず `init.lua` と `lua/config/` を見れば全体像を掴めます。

## 設計上の特徴

### 1. Telescope ではなく Snacks ベース

検索、picker、dashboard、notification、explorer などの中核操作は `Snacks.nvim` に寄せています。主な理由は以下です。

- picker と UI の一体感がある
- dashboard、notification、scratch、zen まで同じ系統で揃えられる
- LSP picker との繋がりが良い

### 2. autoread を切り、外部変更は明示 diff

`autocmds.lua` では `autoread` を無効にしています。  
この設定では「勝手に再読込して差分を見失う」より、「外部変更を検知したら警告し、必要なら diff を見る」方を優先しています。

外部更新が入ったときは通知が出て、`<leader>fd` でバッファ内容とディスク上の内容を `delta` で比較できます。

### 3. Markdown 表示は常時 render しない

`render-markdown.nvim` は入っていますが、初期状態では `enabled = false` です。  
インライン描画が欲しいときだけ `<leader>mt` でトグルします。

一方で、ブラウザベースの単発プレビューも用意しており、`<leader>mp` または `:MarkdownPreview` で既定ブラウザに HTML を生成して開けます。Mermaid 記法もこちらで扱います。

### 4. 外部 CLI の価値を前提にしている

この設定は Neovim だけで閉じていません。`rg`, `fd`, `git`, `delta`, `lazygit`, `tree-sitter`, ブラウザ、各種 formatter/linter が揃って初めて最大限機能します。

## 必須・推奨・任意の依存関係

### 最低限必要

最低限、以下がないと快適には使えません。

- `nvim` 0.12 系
- `git`
- `rg`
- `fd`
- Nerd Font

`git` は `lazy.nvim` の bootstrap に必要です。`rg` と `fd` は `Snacks` の file picker / grep 体験にほぼ必須です。

### 強く推奨

- `lazygit`
- `delta`
- `tree-sitter`
- `node`
- `python3`
- `go`

用途:

- `lazygit`: `<leader>gg`
- `delta`: `<leader>fd`
- `tree-sitter`: parser 導入と構文ベース処理
- `node`, `python3`, `go`: Mason 管理の各種ツールや LSP の実行基盤

### 機能別依存関係

| 機能 | 外部依存 | 備考 |
| --- | --- | --- |
| File picker / grep | `rg`, `fd` | `Snacks.picker` が利用 |
| Git UI | `git`, `lazygit` | `<leader>gg` で起動 |
| Delta diff | `git`, `delta` | `<leader>fd` で buffer vs disk |
| Markdown browser preview | `xdg-settings`, `gtk-launch` または `xdg-open`, 既定ブラウザ | Mermaid はブラウザ側で描画 |
| Markdown preview の Mermaid | インターネット接続 | `marked` と `mermaid` を CDN から取得 |
| Copilot | GitHub Copilot の認証済み環境 | `github/copilot.vim` を利用 |
| Agentic | `agentic.nvim` の `codex-acp` provider が利用可能であること | 別途セットアップが必要 |
| LSP / formatter / DAP | `mason.nvim` がインストールする各種ツール | 初回起動時にダウンロードあり |

### 注意が必要な依存

この設定には「参照はしているが、現行の `mason-tool-installer` で自動導入していないツール」があります。

- `isort`
- `kdlfmt`
- `prettierd`
- `flake8`
- `hadolint`

現状:

- Python formatter は `isort` + `black` の順で設定
- KDL formatter は `kdlfmt` を参照
- JavaScript / TypeScript は `prettierd` を優先
- Python lint は `flake8` を参照
- Dockerfile lint は `hadolint` を参照

これらが環境に無い場合、その filetype では formatter の挙動が部分的になります。README を見て導入するユーザー向けには、ここが最初に詰まりやすい点です。

## インストール

リポジトリルートから GNU Stow で展開します。

```bash
stow nvim
```

すると `~/.config/nvim` にこの設定が配置されます。

初回起動:

```bash
nvim
```

初回起動時に起こること:

- `lazy.nvim` が必要な plugin を取得
- Tree-sitter parser を必要に応じて導入
- Mason が LSP や formatter/debugger の一部を導入

セットアップ確認に便利なコマンド:

```vim
:Lazy
:Mason
:checkhealth
```

## コア設定

### options.lua

基本方針は「見やすく、過剰ではない」設定です。

- 行番号表示を有効化
- `cursorline` を有効化
- `signcolumn=yes`
- `ignorecase` + `smartcase`
- `listchars` を有効化
- vertical split は右、horizontal split は下
- `inccommand=split`
- 終了時の確認を `confirm=true`

インデントは少し意図的です。

- `tabstop=4`
- `shiftwidth=2`
- `expandtab=true`

つまり表示上のタブ幅は 4 ですが、通常のインデントは 2 スペースです。Go はタブ文化が強いため、言語や formatter に委ねる場面もあります。

### keymaps.lua

グローバルで定義している基本操作は少なめです。

- `<Esc>`: 検索ハイライト解除
- `<C-h/j/k/l>`: window 移動
- `<leader>bd`, `<leader>bn`, `<leader>bp`: buffer 操作
- `<leader>w=`: window 幅を 25 / 50 / 75% で循環
- `<leader>mp`: Markdown browser preview
- `:MarkdownPreview`: 同上
- terminal mode で `<Esc><Esc>`: normal mode に戻る

### autocmds.lua

重要なのは以下です。

- `autoread` を無効化
- `FileChangedShell` で外部変更を通知
- `:DeltaLive` コマンドを追加
- `<leader>fd` で現在 buffer とディスク上のファイル差分を新規 tab で表示

これは、生成物や他プロセス編集が絡む環境で「何が変わったか」を視認したいという意図です。

## プラグイン構成

### UI / 操作系

| プラグイン | 役割 |
| --- | --- |
| `folke/snacks.nvim` | dashboard, picker, explorer, notifier, zen, scratch |
| `folke/which-key.nvim` | leader key の可視化 |
| `folke/noice.nvim` | cmdline popup と LSP documentation UI |
| `nvim-lualine/lualine.nvim` | statusline / tabline |
| `echasnovski/mini.pairs` | 自動ペア入力 |
| `hat0uma/csvview.nvim` | CSV の整形表示 |

この設定では `Snacks` が中心です。picker、notification、dashboard を別々に組み合わせるより、全体の操作感を揃えることを優先しています。

補足として、`projects` source は `~/dev`, `~/projects`, `~/Projects` を探索対象にしています。ここはこの環境向けの前提なので、他環境へ持っていく場合は最初に見直す価値があります。

### 検索 / Git / 補助系

| プラグイン | 役割 |
| --- | --- |
| `lewis6991/gitsigns.nvim` | hunk 表示と Git 操作 |
| `folke/trouble.nvim` | diagnostics / symbols 表示 |
| `folke/todo-comments.nvim` | TODO 系コメントの強調 |

### シンタックス / 表示

| プラグイン | 役割 |
| --- | --- |
| `nvim-treesitter/nvim-treesitter` | parser と構文ベース機能 |
| `MeanderingProgrammer/render-markdown.nvim` | Markdown のインライン描画 |

Tree-sitter は次の parser を自動導入対象にしています。

- bash
- c
- diff
- html
- lua
- luadoc
- markdown
- markdown_inline
- query
- vim
- vimdoc
- python
- go
- javascript
- typescript
- yaml
- toml
- dockerfile

Ruby だけは `indentexpr` を明示的に無効化しています。

### AI / 補完

| プラグイン | 役割 |
| --- | --- |
| `saghen/blink.cmp` | 補完 UI |
| `github/copilot.vim` | AI 補完 |
| `carlos-algms/agentic.nvim` | エディタ内 AI セッション |
| `folke/lazydev.nvim` | Lua 開発時の補助型情報 |

補完 source は `lsp`, `path`, `snippets`, `buffer` を使用します。  
Copilot は `Tab` を奪わず、Alt 系に寄せています。

### LSP / Formatter / Linter / DAP

| プラグイン | 役割 |
| --- | --- |
| `neovim/nvim-lspconfig` | LSP 設定本体 |
| `williamboman/mason.nvim` | ツールインストール |
| `williamboman/mason-lspconfig.nvim` | Mason と LSP の橋渡し |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | 追加ツールの自動導入 |
| `stevearc/conform.nvim` | formatter 実行 |
| `mfussenegger/nvim-lint` | linter 実行 |
| `mfussenegger/nvim-dap` | debugger |
| `rcarriga/nvim-dap-ui` | DAP UI |
| `leoluz/nvim-dap-go` | Go debug 補助 |
| `j-hui/fidget.nvim` | LSP 進捗表示 |

## 言語サポート

現行で明示設定されている言語サポートは次の通りです。

| 言語 / filetype | LSP | Formatter | Linter | Debug |
| --- | --- | --- | --- | --- |
| Lua | `lua_ls` | `stylua` | - | - |
| Python | `pyright` | `isort`, `black` | `flake8` | `debugpy` |
| Shell | `bashls` | `shfmt` | - | `bash-debug-adapter` |
| TypeScript / JavaScript | `ts_ls` | `prettierd` or `prettier` | - | - |
| Go | `gopls` | LSP fallback | - | `delve` |
| YAML | `yamlls` | `prettier` | - | - |
| Markdown | `marksman` | `prettier` or `markdownlint` | `markdownlint` | - |
| Dockerfile | `dockerls` | - | `hadolint` | - |
| KDL | - | `kdlfmt` | - | - |

補足:

- Go は専用 formatter を指定しておらず、LSP fallback を使います
- `yamllint` は Mason の ensure list に入っていますが、`nvim-lint` 側にはまだ配線していません
- Python の formatter は `isort` が無いと片肺になります

## キーバインドの主要グループ

すべてを書き出すより、日常使用に必要な軸だけ押さえる方が実用的です。

### Snacks / 検索

| キー | 役割 |
| --- | --- |
| `<leader><space>` | smart file picker |
| `<leader>ff` | files |
| `<leader>fg` | git files |
| `<leader>/` | grep |
| `<leader>fb` | buffers |
| `<leader>fr` | recent files |
| `<leader>e` | explorer |
| `<leader>fp` | projects |
| `<leader>sh` | help |
| `<leader>sk` | keymaps |

### LSP

| キー | 役割 |
| --- | --- |
| `gd` | definition picker |
| `gr` | references picker |
| `gI` | implementations picker |
| `gD` | declaration |
| `<leader>D` | type definition |
| `<leader>rn` | rename |
| `<leader>ca` | code action |

### Git

| キー | 役割 |
| --- | --- |
| `<leader>gg` | lazygit |
| `<leader>gl` | git log |
| `<leader>gs` | git status |
| `]h`, `[h` | hunk 移動 |
| `<leader>hs` | hunk stage |
| `<leader>hr` | hunk reset |
| `<leader>hp` | hunk preview |

### Debug

| キー | 役割 |
| --- | --- |
| `<F5>` | continue |
| `<F10>` | step over |
| `<F11>` | step into |
| `<F12>` | step out |
| `<leader>db` | breakpoint |
| `<leader>dB` | conditional breakpoint |
| `<leader>du` | DAP UI toggle |
| `<leader>dt` | Go test debug |

### AI

| キー | 役割 |
| --- | --- |
| `<leader>aa` | Agentic chat toggle |
| `<leader>ac` | file / selection を Agentic context に追加 |
| `<leader>an` | Agentic new session |
| `<leader>ar` | Agentic restore session |
| `<leader>ad` | 現在行の diagnostic を Agentic に追加 |
| `<leader>aD` | buffer diagnostics を Agentic に追加 |

Copilot:

- `Alt+Y`: suggestion accept
- `Alt+W`: word accept
- `Alt+L`: line accept
- `Alt+]`: next suggestion
- `Alt+[`: previous suggestion
- `Ctrl+]`: dismiss

### Markdown

| キー / コマンド | 役割 |
| --- | --- |
| `<leader>mt` | `render-markdown.nvim` のトグル |
| `<leader>mp` | browser preview |
| `:MarkdownPreview` | browser preview |

## Markdown プレビューの仕様

ブラウザプレビューは `lua/config/markdown_preview.lua` で実装しています。

挙動:

- 現在 buffer の内容から一時 HTML を生成
- 出力先は `stdpath('cache')/markdown-preview/`
- `xdg-settings get default-web-browser` が取れればそれを優先して起動
- 取れない場合は `xdg-open` にフォールバック
- Mermaid ブロックはブラウザ側で SVG に変換

制約:

- Mermaid と Markdown renderer は CDN 依存
- オフライン環境では Mermaid 表示が失敗する可能性がある

確認用サンプル:

- `testdata/markdown-preview-mermaid.md`

## 状態ファイルと生成物

この設定は実行時にいくつかのファイルを生成または更新します。

| パス | 用途 |
| --- | --- |
| `~/.local/share/nvim/lazy/` | lazy.nvim の plugin 本体 |
| `~/.local/share/nvim/mason/` | Mason 管理ツール |
| `stdpath('state')/colorscheme_state.txt` | 最後に使った colorscheme |
| `stdpath('cache')/markdown-preview/` | browser preview 用 HTML |
| `lazy-lock.json` | plugin version lock |

colorscheme は `ColorScheme` autocmd で自動保存されます。デフォルトは `everforest` です。

## メンテナンス

### plugin 更新

```vim
:Lazy
```

plugin を更新したら `lazy-lock.json` の変更も確認してください。

### LSP / formatter / debugger 管理

```vim
:Mason
```

設定上の `ensure_installed` だけではカバーしていないツールもあるため、必要に応じて追加導入します。

### Lua 整形

Lua のスタイルは `.stylua.toml` で管理しています。

```bash
stylua nvim/.config/nvim/lua
```

主な方針:

- 2 spaces
- Unix line endings
- single quote 寄り
- `call_parentheses = "None"`

## 既知の注意点

### 外部変更は自動再読込しない

これは仕様です。外部プロセスがファイルを書き換えた場合、勝手に読み直さず通知だけ出します。内容確認には `<leader>fd` を使ってください。

### Markdown preview は完全オフラインではない

Mermaid 対応を簡潔に保つため、ブラウザ側で CDN を読みます。オフライン完結にしたい場合は、ローカル bundle 化が別途必要です。

### Alt キーが効かない場合は terminal / WM を確認する

Copilot の操作は Alt 依存です。端末や WM のキーバインドが衝突しているとそのままでは動きません。

### `isort` と `kdlfmt` は環境差分が出やすい

README の利用者が Python や KDL を触るなら、ここは早めに明記しておくべきポイントです。現状の設定は参照していますが、自動導入の網には完全には入っていません。

## 拡張方針

この設定を拡張するときは、次のルールで触ると見通しが保ちやすくなります。

- 基本設定は `lua/config/`
- plugin 単位の追加は `lua/plugins/*.lua`
- LSP / completion 系は `lua/plugins/lsp/`
- 一時的な helper やローカル機能は `lua/config/` に寄せる

新しい plugin を増やす場合も、まずは既存の `Snacks`, `Trouble`, `Conform`, `Mason` で足りないかを先に検討する方が、構成全体の一貫性を保ちやすいです。
