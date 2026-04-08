# niri-dots

[![Beta](https://img.shields.io/badge/status-beta-orange)](https://github.com/igon-dw/niri-dots)

> ⚠️ **ベータ版について**: このプロジェクトは現在ベータ版です。機能、設定、スクリプトは大幅に変更される可能性があります。更新前に変更内容を確認してください。

Arch Linux 向けの Niri ベース Wayland デスクトップ環境を構築するための dotfiles と補助スクリプト集です。

このリポジトリは、Niri、Waybar、端末テーマ切り替え、Neovim、Fish、壁紙変更、ウィンドウ切り替え、MIME ベースのファイル起動といった日常運用向けワークフローをまとめて管理できるようにしています。

---

## 概要

このリポジトリに含まれる主な構成要素:

- **Niri**: コンポジタ本体、キーバインド、起動時処理、ウィンドウルール、壁紙/テーマ補助
- **Waybar**: タスクバー寄りのバー構成、端末プロファイル対応、テーマ切り替え
- **Kitty / Ghostty**: それぞれ別ワークフローで管理するターミナル設定
- **Fuzzel**: Niri 補助スクリプトやセレクタで利用するランチャー
- **Fish + Starship**: 対話シェル設定、abbreviation、プロンプト
- **Neovim**: 現行構成の `new_nvim`、参考用の `legacy_nvim`、任意追加の `nvim-copilot`
- **補助設定**: `fastfetch`、`lazygit`、`mako`、MIME 関連、ローカルコマンド
- **初期セットアップ用スクリプト**: パッケージ導入、Docker 設定、GNOME/libadwaita 関連設定
- **OpenCode 設定**: `opencode/` 以下のローカル設定

基本的には GNU Stow で `~/.config` と `~/.local/bin` に展開する前提です。

---

## リポジトリ構成

```text
niri-dots/
|- README.md
|- README.ja.md
|- setup.sh
|- scripts/
|  |- install-packages.sh
|  |- setup-docker.sh
|  `- setup_gnome_settings.sh
|- niri/
|  `- .config/niri/
|     |- config.kdl
|     |- config.kdl.kitty
|     |- config.kdl.ghostty
|     `- scripts_for_niri/
|- waybar/
|  `- .config/waybar/
|     |- config.jsonc
|     |- config.jsonc.kitty
|     |- config.jsonc.ghostty
|     |- style.css.template
|     |- themes/
|     `- scripts_for_waybar/
|- kitty/
|  `- .config/kitty/
|     |- kitty.conf
|     |- themes/
|     `- scripts_for_kitty/
|- ghostty/
|  `- .config/ghostty/
|     |- config
|     |- theme.conf
|     `- scripts_for_ghostty/
|- fuzzel/
|- fish/
|- starship/
|- new_nvim/
|- legacy_nvim/
|- nvim-copilot/
|- fastfetch/
|- lazygit/
|- mako/
|- misc/
|  |- .config/mimeapps.list
|  `- .local/bin/update-arch
`- opencode/
```

補足:

- `config.kdl` と `waybar/.config/waybar/config.jsonc` が現在の active profile です。
- 端末別の variant として `config.kdl.kitty`、`config.kdl.ghostty`、`config.jsonc.kitty`、`config.jsonc.ghostty` もあります。
- Ghostty は `theme.conf` を theme switcher が生成・更新します。
- Kitty は初回テーマ切り替え時に `current-theme.conf` をシンボリックリンクとして生成します。

---

## クイックスタート

```bash
git clone https://github.com/igon-dw/niri-dots.git
cd niri-dots

# 先に install スクリプトの内容を確認してください。
bash scripts/install-packages.sh

# 必要な設定だけ Stow で配置します。
stow niri waybar kitty ghostty fuzzel fish starship fastfetch lazygit mako misc

# Neovim を使う場合
stow new_nvim

# Copilot addon も使う場合
stow new_nvim nvim-copilot
```

その後ログアウトし、ディスプレイマネージャから Niri セッションを選んで再ログインします。

---

## インストール

### 前提条件

- Arch Linux または Arch 系ディストリビューション
- `paru` が `PATH` 上にあること（現行 install script は `paru` 前提）
- Niri セッションを起動できるディスプレイマネージャまたはセッション起動環境

**補足**: GNU Stow は `install-packages.sh` でインストールされるため、dotfiles を配置する前にパッケージインストールスクリプトを実行してください。

### Bootstrap スクリプト

`setup.sh` は以下の順序でセットアップを実行します。

1. `scripts/install-packages.sh`
2. `scripts/setup-docker.sh`
3. `scripts/setup_gnome_settings.sh`

まとめて流したい場合:

```bash
sh setup.sh
```

### パッケージインストールスクリプト

メインの導入スクリプトは `scripts/install-packages.sh` です。

通常実行:

```bash
bash scripts/install-packages.sh
```

オプション:

```bash
INSTALL_NIX=1 bash scripts/install-packages.sh
INSTALL_AMD_GPU=1 bash scripts/install-packages.sh
INSTALL_JAPANESE=1 bash scripts/install-packages.sh
```

主に導入するもの:

- Wayland デスクトップ関連: `niri`、`waybar`、`fuzzel`、`swayidle`、`wl-clipboard`、`cliphist`、`clipse`
- ターミナル/シェル関連: `kitty`、`ghostty`、`starship`、`zoxide`、`zk`、`sheldon`
- 開発関連: `neovim`、`zed`、`mousepad`、`go`、`git`、`github-cli`
- CLI ツール: `fd`、`fzf`、`ripgrep`、`git-delta`、`lazygit`、`fastfetch`、`trash-cli`、`jq`、`rclone`
- デスクトップアプリ/補助ツール: `mako`、`mpv`、`kdenlive`、`obs-studio`、`steam`、`vivaldi`、`geary`、`playerctl`、`brightnessctl`
- フォント: JetBrains Mono Nerd Font、FiraCode Nerd Font など

重要な点:

- 公式パッケージと AUR パッケージを `paru -Syu --needed ...` で導入します。
- `flatpak` が利用可能なら `org.upscayl.Upscayl` も導入します。
- Docker と GNOME 設定は Stow ではなく別スクリプトで処理します。

### Stow で dotfiles を配置する

推奨構成:

```bash
stow niri waybar kitty ghostty fuzzel fish starship fastfetch lazygit mako misc
```

Neovim を加える場合:

```bash
stow new_nvim
stow new_nvim nvim-copilot
```

個別に配置する場合の例:

```bash
stow niri
stow waybar
stow kitty
stow ghostty
stow fish
stow misc
```

---

## Terminal Profiles

このリポジトリには、端末を軸にした 2 種類のデスクトッププロファイルがあります。

- **Kitty profile**: メイン端末が Kitty、Waybar の監視系クリック動作も Kitty で開く
- **Ghostty profile**: メイン端末が Ghostty、Waybar の監視系クリック動作も Ghostty で開く

切り替えスクリプトは `niri/.config/niri/scripts_for_niri/switch-terminal.sh` です。

実行例:

```bash
bash niri/.config/niri/scripts_for_niri/switch-terminal.sh
```

このスクリプトが行うこと:

- `niri/.config/niri/config.kdl` を `config.kdl.kitty` または `config.kdl.ghostty` に切り替える
- `waybar/.config/waybar/config.jsonc` を `config.jsonc.kitty` または `config.jsonc.ghostty` に切り替える

切り替え後は Niri の設定を再読み込みしてください。

```bash
niri msg action reload-config
```

運用上の注意:

- このスクリプトはホーム側ではなくリポジトリ内のシンボリックリンクを更新します。Stow の参照元になっている checkout で実行してください。

---

## コンポーネントメモ

### Niri

メイン設定:

- `niri/.config/niri/config.kdl`

現在の active config で起動する主な常駐処理:

- `waybar`
- `niri-taskbar-watcher.sh`
- `fcitx5 -d`
- `swww-daemon` と `swww restore`
- `swayidle`
- `wl-paste --watch cliphist store`
- `clipse -listen`

代表的なキーバインド:

- `Mod+Return`: 端末起動
- `Alt+Space`: `fuzzel` 起動
- `Mod+W`: fuzzy window picker
- `Mod+A`: MIME ベースの file launcher
- `Mod+Shift+A`: フローティング端末で `fzf` quick opener 起動
- `Mod+Shift+W`: フローティング端末で壁紙セレクタ起動
- `Mod+T`: Waybar テーマ切り替え
- `Mod+Alt+T`: 端末テーマ切り替え
- `Mod+Ctrl+Alt+T`: Waybar と端末のテーマをまとめて切り替え
- `Mod+Semicolon`: `clipse` 起動
- `Print`、`Ctrl+Print`、`Alt+Print`: スクリーンショット

### Waybar

関連ファイル:

- `waybar/.config/waybar/config.jsonc`
- `waybar/.config/waybar/style.css.template`
- `waybar/.config/waybar/themes/`
- `waybar/.config/waybar/scripts_for_waybar/`

現在の Waybar 構成:

- `niri-taskbar.py` を使った taskbar 風のウィンドウ一覧
- MPRIS モジュール
- 通知一括 dismiss ボタン
- 現在テーマ表示とテーマ切り替え
- Kitty / Ghostty 向け variant config

テーマ切り替え:

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
```

### Kitty

関連ファイル:

- `kitty/.config/kitty/kitty.conf`
- `kitty/.config/kitty/themes/`
- `kitty/.config/kitty/scripts_for_kitty/`

Kitty 側の特徴:

- `kitty.conf` は `./current-theme.conf` を include します
- `current-theme.conf` は初回テーマ切り替え時に自動生成されます
- remote control を有効にしているので、実行中の Kitty にその場で反映できます

テーマ切り替え:

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh
~/.config/kitty/scripts_for_kitty/switch-theme.sh tokyo-night
~/.config/kitty/scripts_for_kitty/list-themes.sh
```

### Ghostty

関連ファイル:

- `ghostty/.config/ghostty/config`
- `ghostty/.config/ghostty/theme.conf`
- `ghostty/.config/ghostty/scripts_for_ghostty/`

Ghostty 側の特徴:

- `config` は `~/.config/ghostty/theme.conf` を読み込みます
- `theme.conf` は switcher script が生成・更新します
- テーマ名は `ghostty +list-themes` の結果に照合して検証します

テーマ切り替え:

```bash
~/.config/ghostty/scripts_for_ghostty/switch-theme.sh
~/.config/ghostty/scripts_for_ghostty/switch-theme.sh "Catppuccin Mocha"
~/.config/ghostty/scripts_for_ghostty/list-themes.sh
```

### Fish と Starship

Fish 設定は `fish/.config/fish/config.fish` にあり、主に以下を含みます。

- Starship 初期化
- Zoxide 初期化
- `eza`、`lazygit`、`opencode`、動画エンコード補助などの abbreviation
- `~/.local/bin` と Neovim Mason 配下の PATH 追加
- `fish/.config/fish/options.fish` による任意のローカル上書き

Starship 設定は `starship/.config/starship.toml` です。

### Neovim

現行構成:

- `new_nvim/.config/nvim/`: 現在使う Neovim 設定
- `legacy_nvim/.config/nvim/`: 旧構成の参考用
- `nvim-copilot/.config/nvim/`: 任意追加の Copilot addon overlay

現在の Neovim 構成には、LSP、Treesitter、formatting、linting、DAP、which-key、Snacks、Noice、Copilot Vim integration などが含まれます。

Copilot addon に関する補足:

- `stow new_nvim nvim-copilot` で導入
- addon 側で `copilot.lua` と `CopilotChat.nvim` を追加
- `CopilotChat` は `<leader>ai` に割り当て

### その他の設定

- `fastfetch/.config/fastfetch/config.jsonc`: Fastfetch 表示設定
- `lazygit/.config/lazygit/config.yml`: Lazygit 設定
- `mako/.config/mako/config`: 通知デーモン設定
- `misc/.config/mimeapps.list`: デフォルトアプリ関連付け
- `misc/.local/bin/update-arch`: 更新補助コマンド
- `opencode/opencode.jsonc`: OpenCode の model / formatter / permission 設定

---

## Workflow Scripts

### MIME ベースのファイルランチャー

関連ファイル:

- `niri/.config/niri/scripts_for_niri/f2_launcher/f2_launcher.sh`
- `niri/.config/niri/scripts_for_niri/f2_launcher/f2_launcher.toml`

動作概要:

1. `fd` で `$HOME` 配下からファイルを探す
2. `fuzzel` で候補を絞る
3. `file` で MIME type を判定する
4. TOML 設定から候補アプリを調べる
5. GUI アプリは直接起動する
6. CLI アプリは設定済み端末の中で起動する

直接実行する場合:

```bash
~/.config/niri/scripts_for_niri/f2_launcher/f2_launcher.sh
```

現行の TOML では、テキスト、Markdown、JSON、YAML、画像、音声、動画、ディレクトリ向けの関連付けが入っています。

### FZF quick opener

関連ファイル:

- `niri/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener.sh`
- `niri/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener_core.sh`
- `niri/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener_icons.sh`

動作概要:

1. フローティングの Kitty または Ghostty 端末内で起動する
2. `fd` で `$HOME` 配下の候補を列挙する
3. `fzf` でアイコン、種別ラベル、プレビュー付きで絞り込む
4. パス選択後に使用アプリをもう一度選ぶ
5. アプリ関連付けは `f2_launcher` と同じ TOML 設定を使う

直接実行する場合:

```bash
~/.config/niri/scripts_for_niri/fzf_quick_opener/fzf_quick_opener.sh
```

### Fuzzy window picker

関連ファイル:

- `niri/.config/niri/scripts_for_niri/niri-window-picker.sh`

このスクリプトは `niri msg --json` の結果を `jq` で整形し、`fuzzel` 経由で対象ウィンドウへフォーカスを移します。

### テーマ同期

関連ファイル:

- `niri/.config/niri/scripts_for_niri/change-all-themes.sh`

この補助スクリプトは:

- `fuzzel` で Waybar のテーマを一度だけ選び
- 同じテーマを Waybar に適用し
- 対応 `.conf` があれば Kitty にも同名テーマを適用し
- Ghostty 側は一致テーマがあれば適用、なければ Ghostty の対話セレクタへフォールバックします

実行例:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

### 壁紙選択

関連ファイル:

- `niri/.config/niri/scripts_for_niri/wallpaper_selector.sh`
- `niri/.config/niri/scripts_for_niri/wallpaper_selector_tui.sh`
- `niri/.config/niri/scripts_for_niri/wallpaper_selector_tui_chafa.sh`

現在の Niri キーバインドでは、フローティング端末内で TUI 版の壁紙セレクタを開きます。

---

## 運用メモ

### 日本語入力

active な Niri 設定では `fcitx5 -d` を自動起動します。

日本語入力環境を入れたい場合:

```bash
INSTALL_JAPANESE=1 bash scripts/install-packages.sh
```

### Docker

`scripts/setup-docker.sh` は systemd 経由で Docker を有効化・起動し、sudo 実行ユーザーを `docker` グループへ追加しようとします。

反映にはログアウト/再ログインが必要になる場合があります。

### GNOME / libadwaita 系バックエンド設定

`scripts/setup_gnome_settings.sh` は `gsettings` で以下のような設定を適用します。

- color scheme
- text scaling
- animation toggle
- sound theme と event sounds

これは主に portal / libadwaita 系の整合性向けであり、テーマやアイコンの見た目そのものは別手段で管理する前提です。

### スクリプトが前提にしている追加コマンド

このリポジトリのワークフローでは、以下のようなコマンドが存在する前提の箇所があります。

- `jq`
- `playerctl`
- `brightnessctl`
- `swaylock`
- `sensors`
- `python3`
- `btop`
- `notify-send`

キーバインドや Waybar モジュールが反応しない場合は、まず対応コマンドがインストールされているか確認してください。

---

## トラブルシューティング

### プロファイル切り替え後に Niri が反映しない

```bash
niri msg action reload-config
```

### Waybar が表示されない / 反映されない

```bash
pkill -x waybar
waybar
```

### Kitty のテーマが切り替わらない

```bash
~/.config/kitty/scripts_for_kitty/switch-theme.sh
kitty @ ls
```

### Ghostty のテーマが切り替わらない

```bash
ghostty +list-themes
~/.config/ghostty/scripts_for_ghostty/switch-theme.sh
```

### file launcher や window picker が失敗する

まず以下を確認してください。

```bash
command -v fd fuzzel file yq jq
```

---

## 謝辞

このプロジェクトはプロジェクト管理者が**GitHub Copilot**および**OpenCode**を使用して開発しています。プロジェクト管理、アーキテクチャの決定、全体的な構成はプロジェクト管理者自身によって設計・計画されています。これらの AI ツールはコード補完、実装詳細、ドキュメント改善、コミットメッセージ作成などに使用されています。AI 支援によるすべての成果物はプロジェクト管理者によるレビューと検証を経ており、プロジェクトの方向性、品質、技術的決定に対する全責任はプロジェクト管理者が保持しています。

---

## リソース

- [Niri GitHub リポジトリ](https://github.com/YaLTeR/niri)
- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Kitty ドキュメント](https://sw.kovidgoyal.net/kitty/)
- [Ghostty](https://ghostty.org/)
- [Fuzzel Codeberg](https://codeberg.org/dnkl/fuzzel)
- [Arch Linux Wiki](https://wiki.archlinux.org/)

---

## ライセンス

このプロジェクトは MIT License のもとで公開されています。詳細は `LICENSE` を参照してください。
