# niri-dots

Arch系Linuxディストリビューションで統合的なNiriデスクトップ環境を構築するための包括的なドットファイルリポジトリです。Niri、Waybar、Fuzzel、Kittyなどの設定ファイルと導入ガイドを提供します。

**niri-dots** は、生産性重視のNiriベースのデスクトップ環境をスムーズに導入するための設定ファイル、自動化スクリプト、および詳細なインストール手順を提供します。

---

## 目次

- [概要](#概要)
- [リポジトリ構成](#リポジトリ構成)
- [クイックスタート](#クイックスタート)
- [インストール](#インストール)
  - [前提条件](#前提条件)
  - [パッケージのインストール](#パッケージのインストール)
  - [ドットファイルの配置](#ドットファイルの配置)
- [コンポーネント設定](#コンポーネント設定)
  - [Niri](#niri)
  - [Waybar](#waybar)
  - [Kitty](#kitty)
  - [Fuzzel](#fuzzel)
- [自動化スクリプト](#自動化スクリプト)
  - [f2_launcher](#f2_launcher)
- [インストール後の設定](#インストール後の設定)
- [カスタマイズ](#カスタマイズ)
- [トラブルシューティング](#トラブルシューティング)
- [ライセンス](#ライセンス)

---

## 概要

**Niri** は、生産性を重視して設計された最新のWaylandコンポジタです。このリポジトリは、以下を含む完全な統合セットアップを提供します：

- **Niriコンポジタ**: メインのウィンドウマネージャー
- **Waybar**: システム情報表示とクイックアクション、動的テーマ切り替えが可能なステータスバー
- **Kitty**: 高性能ターミナルエミュレータ（複数テーマ対応）
- **Fuzzel**: アプリケーションランチャー
- **自動化スクリプト**: ファイル開き支援などの設定管理ツール
- **システム統合**: システム監視、ファイル管理、開発ツール用ユーティリティ

これらの設定は互いにシームレスに機能するよう設計されており、生産性と使いやすさに最適化された統合的なデスクトップ環境を提供します。
しかし最終的にはあなた自身が一から設定を構築できるような、学習リソースになることが究極の目的です。

## このdotfilesリポジトリの特徴

- Vimキーバインドのようなキーボード中心の操作を志向するユーザーに最適化された設定。
- Niriにはじめて触れるユーザー向けの詳細なドキュメントとガイド。（PC自体に不慣れな場合には、KDE PlasmaやGNOMEなどの統合デスクトップ環境を推奨します）
- Fuzzelを通した少し便利なツール群の提供。

---

## リポジトリ構成

```
niri-dots/
├── README.md                      # メインドキュメント（英語版）
├── README.ja.md                   # 日本語版ドキュメント
├── LICENSE                        # MITライセンス
├── .gitignore                     # Git除外設定
├── setup.sh                       # セットアップオーケストレータ
├── scripts/
│   ├── install-packages.sh        # パッケージインストールスクリプト
│   ├── setup-docker.sh            # Docker設定スクリプト
│   └── setup_gnome_settings.sh    # GNOME設定スクリプト
│
├── niri/                          # Niriコンポジタの設定
│   └── .config/
│       └── niri/
│           ├── config.kdl         # メインのNiri設定ファイル
│           └── scripts_for_niri/
│               ├── f2_launcher.sh           # ファイル開きスクリプト
│               ├── f2_launcher.toml         # ファイルオープナー設定
│               ├── wallpaper_selector.sh    # 壁紙選択スクリプト
│               ├── wallpaper_selector_tui.sh
│               ├── niri-window-picker.sh
│               └── change-all-themes.sh     # 全テーマ一括変更
│
├── waybar/                        # Waybarステータスバーの設定
│   └── .config/waybar/
│       ├── README.md              # Waybar詳細ドキュメント
│       ├── README.ja.md           # Waybar詳細ドキュメント（日本語）
│       ├── config.jsonc           # Waybarモジュールとレイアウト
│       ├── base.css               # Waybarテーマ非依存スタイル
│       ├── style.css.template     # Waybarスタイルテンプレート
│       ├── scripts_for_waybar/
│       │   ├── switch-theme.sh    # Waybarテーマ切り替えスクリプト
│       │   ├── get-current-theme.sh
│       │   ├── get-mpris.sh
│       │   └── pomo.sh
│       └── themes/                # Waybarテーマ集
│           ├── ayu.css
│           ├── catppuccin.css
│           ├── earthsong.css
│           ├── everforest.css
│           ├── flatland.css
│           ├── gruvbox.css
│           ├── night-owl.css
│           ├── nord.css
│           ├── original.css
│           ├── palenight.css
│           ├── shades-of-purple.css
│           ├── solarized.css
│           └── tokyo-night.css
│
├── kitty/                         # Kittyターミナル設定
│   └── .config/kitty/
│       ├── README.md              # Kitty詳細ドキュメント
│       ├── README.ja.md           # Kitty詳細ドキュメント（日本語）
│       ├── kitty.conf             # メインKitty設定
│       ├── scripts_for_kitty/
│       │   ├── switch-theme.sh    # Kittyテーマ切り替え
│       │   └── list-themes.sh     # テーマ一覧表示
│       └── themes/                # Kittyテーマ集
│           ├── ayu.conf
│           ├── catppuccin.conf
│           ├── earthsong.conf
│           ├── everforest.conf
│           ├── flatland.conf
│           ├── gruvbox.conf
│           ├── nord.conf
│           ├── original.conf
│           ├── palenight.conf
│           ├── solarized.conf
│           └── tokyo-night.conf
│
├── ghostty/                       # Ghosttyターミナル設定
│   └── .config/ghostty/
│       ├── ghostty.config         # Ghostty設定ファイル
│       └── scripts_for_ghostty/
│           ├── switch-theme.sh
│           └── list-themes.sh
│
├── fuzzel/                        # fuzzelアプリケーションランチャー設定
│   └── .config/fuzzel/
│       └── fuzzel.ini
│
├── fish/                          # Fish shell設定
│   └── .config/fish/
│       ├── config.fish
│       ├── functions/
│       └── templates/
│
├── starship/                      # Starshipプロンプト設定
│   └── .config/starship.toml
│
├── new_nvim/                      # Neovim設定（現行版、OSSコア）
│   └── .config/nvim/
│       ├── init.lua               # エントリーポイント
│       └── lua/
│           ├── config/            # コア設定
│           └── plugins/           # プラグイン設定
│
├── legacy_nvim/                   # Neovim設定（レガシー版、参考用）
│   ├── docs/
│   │   ├── DESIGN_PHILOSOPHY.md
│   │   ├── DESIGN_PHILOSOPHY_ja.md
│   │   └── README_KEYMAPS.md
│   └── .config/nvim/
│
├── nvim-copilot/                  # Neovim AIアドオン（オプション、GitHub Copilotサブスクリプション必要）
│   └── .config/nvim/
│       └── lua/plugins/
│           ├── copilot.lua        # GitHub Copilot連携
│           └── copilotchat.lua    # CopilotChat連携
│
├── lazygit/                       # Lazygit設定
│   └── .config/lazygit/
│
├── fastfetch/                     # Fastfetch設定
│   └── .config/fastfetch/
│
├── mako/                          # Mako通知設定
│   └── .config/mako/
│
└── misc/                          # その他の設定とユーティリティ
    ├── .config/
    │   └── (その他の設定ファイル)
    └── .local/bin/
        └── update-arch            # Archシステムアップデートスクリプト
```

---

## クイックスタート

経験者向けの最小限のセットアップ手順です：

```bash
# 1. リポジトリのクローン
git clone https://github.com/igon-dw/niri-dots.git
cd niri-dots

# 2. 必要なパッケージのインストール
sudo bash scripts/install-packages.sh

# 3. 設定ファイルの配置
# GNU Stowを使用する方法（推奨）：
stow niri waybar kitty fuzzel misc

# 4. Niriの起動
# ログアウトして、ログインマネージャー（SDDM/GDMなど）の
# セッション選択画面で「Niri」を選択してログイン
```

---

## インストール

### 前提条件

- **ディストリビューション**: Arch Linux またはArch系ディストリビューション（Manjaro、EndeavourOS等）
- **AURヘルパー**: `paru` または `yay`（AURパッケージのインストール用）
- **基本システム**: 最新の状態に更新されたシステムと必須ビルドツール
- **ログインマネージャー**: SDDM または GDM（Niriセッションの起動に必要）

#### 前提条件の確認

```bash
# Arch系システムの確認
cat /etc/os-release

# paruまたはyayの確認
which paru
which yay

# ログインマネージャーの確認
systemctl status sddm    # または gdm
```

### パッケージのインストール

`install-packages.sh` スクリプトがすべての依存パッケージと推奨ツールをインストールします：

```bash
sudo bash scripts/install-packages.sh
```

**インストール内容:**

- **デスクトップ環境**: `niri`、`xwayland-satellite`、`waybar`、`fuzzel`、`wlogout`、`wl-clipboard`、`networkmanager`、`nemo`
- **ターミナルとシェル**: `kitty`（ターミナルエミュレータ）、`starship`（シェルプロンプトカスタマイズツール）、`zoxide`（高速ディレクトリジャンプツール）
- **開発ツール**: `neovim`、`zed`、`mousepad`、`git`、`github-cli`、`go`
- **CLIユーティリティ**: `eza`、`fd`、`fzf`、`ripgrep`、`delta`、`lazygit`、`go-yq`、`chafa`
- **システムユーティリティ**: `docker`、`snapper`、`flatpak`、`gnome-keyring`、`stow`、`xdg-user-dirs`、`xdg-utils`
- **マルチメディア**: `kdenlive`、`obs-studio`、`steam`、Proton関連
- **フォント・入力方式**: `fcitx5-mozc-ut`（日本語入力）、Nerd Fonts

**注記**: AURからインストールされるパッケージが含まれています。実行前にスクリプトを確認し、必要に応じて `yay` を使用するよう修正してください。

### ドットファイルの配置

#### 方法1: GNU Stowを使用（推奨）

GNU Stowは設定ファイルをホームディレクトリにシンボリックリンクで配置するため、gitでの更新が簡単です：

```bash
# Stowがインストールされていない場合
sudo pacman -S stow

# すべての設定を配置
cd niri-dots
stow niri waybar kitty fuzzel misc

# 個別のコンポーネントのみ配置
stow niri          # Niriのみ
stow waybar        # Waybarのみ
stow kitty         # Kittyのみ
stow fuzzel        # Fuzzelのみ
stow fish          # Fish shellのみ
stow starship      # Starshipのみ
stow misc          # その他のユーティリティとコマンド
```

#### 方法2: 手動配置

```bash
# ホームディレクトリに設定ファイルをコピー
mkdir -p ~/.config ~/.local/bin
cp -r niri/.config/niri ~/.config/
cp -r waybar/.config/waybar ~/.config/
cp -r kitty/.config/kitty ~/.config/
cp -r fuzzel/.config/fuzzel ~/.config/
cp -r misc/.config/* ~/.config/ 2>/dev/null || true
cp -r misc/.local/bin/* ~/.local/bin/ 2>/dev/null || true
chmod +x ~/.config/*/scripts/*.sh ~/.local/bin/* 2>/dev/null || true
```

---

## コンポーネント設定

### Niri

Niriはこのセットアップの中心となるWaylandコンポジタおよびウィンドウマネージャーです。

**設定ファイル**: `~/.config/niri/config.kdl`

**主な機能**:

- タイリングおよびフローティングウィンドウレイアウト
- カスタムキーバインディング
- アプリケーションごとのウィンドウルール（透明度、サイズなど）
- モニターと解像度の設定
- フォーカスリングとボーダーのカスタマイズ

**はじめ方**:

1. このリポジトリのデフォルト設定を確認
2. キーバインディングを自分の好みに合わせてカスタマイズ
3. アプリケーションごとのウィンドウルール（透明度、デフォルト幅など）を調整
4. 複数ディスプレイを使用している場合、output設定を確認

**詳細**: [Niri GitHub](https://github.com/YaLTeR/niri)

### Waybar

Waybarはシステム情報を表示し、一般的な機能への素早いアクセスを提供するステータスバーです。

**設定ファイル**: `~/.config/waybar/config.jsonc`, `~/.config/waybar/style.css`

**テーマシステム**: Catppuccin、Gruvbox、Nord、Solarized、Tokyo Night など複数のテーマをサポート。

```bash
# テーマを切り替え（インタラクティブ）
~/.config/waybar/scripts_for_waybar/switch-theme.sh

# 特定のテーマを指定
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
```

**詳細**: [Waybar設定ガイド](./waybar/.config/waybar/README.md)

### Kitty

Kittyは高性能でテーマ対応のターミナルエミュレータです。

**設定ファイル**: `~/.config/kitty/kitty.conf`

**テーマシステム**: 12以上のテーマをサポート。自動初期化機能あり。

```bash
# テーマを切り替え（インタラクティブ）
~/.config/kitty/scripts_for_kitty/switch-theme.sh

# 特定のテーマを指定
~/.config/kitty/scripts_for_kitty/switch-theme.sh tokyo-night

# テーマ一覧を表示
~/.config/kitty/scripts_for_kitty/list-themes.sh
```

**詳細**: [Kitty設定ガイド](./kitty/.config/kitty/README.md)

### Fuzzel

Fuzzelはモダンなアプリケーションランチャーです。

**設定ファイル**: `~/.config/fuzzel/fuzzel.ini`

**詳細**: [Fuzzel GitHub](https://codeberg.org/dnkl/fuzzel)

### Neovim

lazy.nvimプラグインマネージャー、LSPサポート、モジュラーアーキテクチャを備えたモダンなNeovim設定です。

**設定ファイル**: `~/.config/nvim/init.lua`

**主な機能**:

- lazy.nvimによるモジュラープラグインアーキテクチャ
- 自動インストール対応のLSPサポート（Mason）
- ファジー検索のためのTelescope
- シンタックスハイライトのためのTreesitter
- キーバインド発見のためのWhich-key

**デプロイ方法**:

#### パターン1: OSSコアのみ（推奨・シンプル）

```bash
cd niri-dots
stow new_nvim
```

#### パターン2: OSSコア + GitHub Copilot（推奨・安全な方法）

```bash
cd niri-dots
stow new_nvim nvim-copilot  # 両方を同時にデプロイ
```

⚠️ **注意**: `stow new_nvim` を実行後に `stow nvim-copilot` を後付けする場合、stowが既存ディレクトリを検出してシンボリックリンクの構造を自動調整します。これは正常な動作ですが、確実を期すためには上記の同時デプロイを推奨します。

**AIアドオン（オプション）**:

`nvim-copilot`アドオンはGitHub Copilot連携を提供します。

**必要条件:**

- GitHub Copilotサブスクリプション
- GitHub CLIツール（`github-cli`パッケージ）
- GitHub CLI認証

**セットアップ手順:**

1. **GitHub CLIで認証（初回のみ）:**

```bash
gh auth login
# プロンプトに従って認証を完了
```

2. **nvim-copilotをデプロイ:**

```bash
cd niri-dots
stow new_nvim nvim-copilot  # OSSコアとCopilotアドオンの両方をデプロイ
```

3. **Neovimで認証トークンを確認:**

```bash
nvim
# :checkhealth copilot
```

**使用方法:**

| キーマップ   | 機能                            |
| ------------ | ------------------------------- |
| `Ctrl+y`     | Copilot提案を全て受け入れ       |
| `Ctrl+i`     | Copilot提案の次の単語を受け入れ |
| `<leader>ai` | CopilotChatを開く               |

**トラブルシューティング:**

```bash
# 認証状態を確認
gh auth status

# 再認証が必要な場合
gh auth logout
gh auth login
```

**シンボリックリンクの管理:**

```bash
# デプロイ状況を確認
stow -d niri-dots -n new_nvim
stow -d niri-dots -n nvim-copilot

# nvim-copilotを後から追加する場合
cd niri-dots
stow nvim-copilot

# nvim-copilotを削除（OSSコアは保持）
stow -D nvim-copilot

# new_nvim全体を削除
stow -D new_nvim nvim-copilot

# 完全にリセットする場合
stow -D new_nvim
stow -D nvim-copilot
# その後、必要に応じて再度デプロイ
stow new_nvim
```

**詳細ドキュメント**: [Neovim設計思想](./legacy_nvim/docs/DESIGN_PHILOSOPHY_ja.md)

---

## 自動化スクリプト

### f2_launcher

Advanced Fuzzy File Launcher with MIME-type support。MIMEタイプに基づいてファイルを開くアプリケーションを選択できます。

**場所**: `~/.config/niri/scripts_for_niri/f2_launcher.sh`

**設定ファイル**: `~/.config/niri/scripts_for_niri/f2_launcher.toml`

**特徴**:

- **MIMEタイプベースのアプリケーション選択**: ファイルのMIMEタイプに応じて複数の候補アプリを設定可能
- **CLIとGUIの自動判別**: `nvim`、`nano`などのCLIアプリは自動的に端末で起動。`zeditor`などのGUIアプリは直接起動
- **ユーザー選択ダイアログ**: Fuzzelで複数候補から選択可能
- **設定ファイルベース**: TOMLフォーマットで容易にカスタマイズ可能

**使用方法**:

```bash
# スクリプトを実行
~/.config/niri/scripts_for_niri/f2_launcher.sh

# Niriのキーバインディングに登録（例）
"Mod+o" = "spawn" "~/.config/niri/scripts_for_niri/f2_launcher.sh";
```

**設定例**:

```toml
[app_metadata]
nvim = "cli"
nano = "cli"
zeditor = "gui"
code = "gui"

[mime_types]
"text/plain" = ["zeditor", "code", "nvim"]
"text/x-shellscript" = ["zeditor", "code", "nano"]
"text/x-python" = ["zeditor", "code", "nvim"]
```

**動作フロー**:

1. `fd`と`fuzzel`でファイルを選択
2. `file`コマンドでMIMEタイプを判定
3. 設定ファイルから該当するアプリケーション候補を取得
4. インストール済みのアプリをフィルタリング
5. Fuzzelで候補を表示（複数の場合）
6. 選択されたアプリがCLIかGUIかを判別
   - **CLI**: 端末（foot/kitty/alacritty/xterm）で起動
   - **GUI**: 直接起動

---

## インストール後の設定

設定をデプロイした後、以下の追加セットアップステップを実施してください：

### 1. Niriの起動

```bash
# ログインマネージャー経由（推奨、現在SDDM/GDMで動作確認済み）
# ログアウトして、ログイン画面のセッション選択で「Niri」を選択してからログイン
```

### 2. ディスプレイの設定（マルチモニターセットアップ）

`~/.config/niri/config.kdl` を編集してディスプレイ設定を指定：

```kdl
output "HDMI-A-1" {
    position x=0 y=0
}

output "DP-1" {
    position x=2560 y=0
}
```

必要に応じて `mode` オプションで解像度とリフレッシュレートを指定できます。

### 3. Waybarの自動起動設定

Niri設定ファイルにWaybarの自動起動を追加：

```kdl
spawn-at-startup "waybar"
```

### 4. キーボード設定

`~/.config/niri/config.kdl` でキーボード設定をカスタマイズ：

```kdl
input {
    keyboard {
        xkb {
            # layout "us"  # レイアウトを指定する場合
            # layout "jp"  # 日本語の場合
            options "ctrl:nocaps"  # CapsLockをCtrlに変更
        }
    }
}
```

### 5. 日本語入力の設定（オプション）

fcitx5-mozc-utをインストールして日本語入力を使用する場合、環境変数を設定してNiri設定で自動起動：

```bash
# 環境変数の設定
echo 'export GTK_IM_MODULE=fcitx' >> ~/.bashrc
echo 'export QT_IM_MODULE=fcitx' >> ~/.bashrc
echo 'export XMODIFIERS=@im=fcitx' >> ~/.bashrc
```

Niri設定ファイル（`~/.config/niri/config.kdl`）では既に以下が設定されています：

```kdl
spawn-at-startup "fcitx5" "-d"
```

### 6. Niriキーバインディングのカスタマイズ

`~/.config/niri/config.kdl` のキーバインディングを編集。デフォルトで以下のような設定があります：

```bash
binds {
    Mod+Return { spawn "kitty"; }                    # ターミナル起動
    Alt+Space { spawn "fuzzel"; }                    # アプリケーションランチャー
    Mod+Q { close-window; }                          # ウィンドウを閉じる
    Mod+Shift+W { spawn "kitty" "--class" "kitty-floating" "-e" "bash" "-c" "$HOME/.config/niri/scripts_for_niri/wallpaper_selector_tui.sh"; }
    Mod+T { spawn-sh "~/.config/waybar/scripts_for_waybar/switch-theme.sh"; }
    Mod+Alt+T { spawn-sh "~/.config/kitty/scripts_for_kitty/switch-theme.sh"; }
}
```

---

## カスタマイズ

### テーマの変更

#### Waybarテーマの変更

詳細は [Waybar README](./waybar/.config/waybar/README.md) を参照してください。

```bash
# インタラクティブに選択
~/.config/waybar/scripts_for_waybar/switch-theme.sh

# 直接指定
~/.config/waybar/scripts_for_waybar/switch-theme.sh nord

# Niriキーバインド（デフォルト: Mod+T）で起動可能
```

#### Kittyテーマの変更

詳細は [Kitty README](./kitty/.config/kitty/README.md) を参照してください。

```bash
# インタラクティブに選択
~/.config/kitty/scripts_for_kitty/switch-theme.sh

# 直接指定
~/.config/kitty/scripts_for_kitty/switch-theme.sh palenight

# テーマ一覧を表示
~/.config/kitty/scripts_for_kitty/list-themes.sh

# Niriキーバインド（デフォルト: Mod+Alt+T）で起動可能
```

#### 初回テーマの初期化

```bash
# Waybarテーマを初期化
~/.config/waybar/scripts_for_waybar/switch-theme.sh

# Kittyテーマを初期化（自動初期化機能あり）
~/.config/kitty/scripts_for_kitty/switch-theme.sh
```

### Waybarモジュールの調整

`~/.config/waybar/config.jsonc` を編集してモジュールの追加、削除、または並び替え。

### Niriのレイアウト設定

`~/.config/niri/config.kdl` でレイアウトをカスタマイズ：

```kdl
layout {
    gaps 5

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }

    default-column-width { proportion 0.5; }

    focus-ring {
        width 3.2
        active-color "violet"
        inactive-color "#505050"
    }
}
```

---

## トラブルシューティング

### Waybarが表示されない

```bash
# Waybarが実行中か確認
pgrep waybar

# Waybarを手動起動
waybar

# ログを確認
journalctl -u waybar -n 50
```

### Niriがクラッシュするか起動しない

```bash
# Niriのログを確認
journalctl -u niri -n 50

# 設定ファイルの構文を検証
niri validate-config

# 最小限の設定で試す（バックアップを作成してから）
mv ~/.config/niri/config.kdl ~/.config/niri/config.kdl.bak
niri  # デフォルト設定が使用されます
```

### 入力方式の問題

```bash
# fcitx5を再起動
killall fcitx5
fcitx5 &

# fcitx5の状態を確認
fcitx5-diagnose
```

### Kittyテーマが反映されない

```bash
# スクリプトが実行可能か確認
ls -la ~/.config/kitty/scripts_for_kitty/switch-theme.sh

# 手動で再初期化
~/.config/kitty/scripts_for_kitty/switch-theme.sh earthsong
```

---

## 謝辞

このプロジェクトはプロジェクト管理者によって開発され、**GitHub Copilot** の支援を受けています。GitHub Copilot はコード補完と生成を行うAI駆動ツールです。プロジェクト管理、アーキテクチャの決定、全体的な構成はプロジェクト管理者自身によって設計・計画されています。GitHub Copilot が具体的にサポートした作業は以下の通りです：

- コード補完と改善
- 小さな単位での処理と実装詳細
- ドキュメントコンテンツの改善と組織化
- コミットメッセージの作成

AI支援によるすべての成果物は、プロジェクト管理者による徹底的なレビュー、修正、検証を経ています。プロジェクト管理者はプロジェクトの方向性、品質基準、技術的決定に対する完全な統制権を保持しています。このAIツールとの協働は、AI ツールが生産性を向上させる一方で、人間のプロジェクト管理者が最終成果物の正確性、完全性、品質保証に対する全責任を保持する、現代的で実用的な開発アプローチを表しています。

---

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています。詳細は [LICENSE](LICENSE) ファイルを参照してください。

**リソースとドキュメント**

- [Niri GitHub リポジトリ](https://github.com/YaLTeR/niri)
- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Kitty ドキュメント](https://sw.kovidgoyal.net/kitty/)
- [Fuzzel Codeberg](https://codeberg.org/dnkl/fuzzel)
- [Arch Linux Wiki](https://wiki.archlinux.org/)
- [Wayland ドキュメント](https://wayland.freedesktop.org/)

---

## サポート

問題や質問がある場合：

1. [トラブルシューティング](#トラブルシューティング) セクションを確認
2. 各コンポーネントの詳細ドキュメント（Waybar、Kitty）を確認
3. 詳細なセットアップ情報と問題の説明を含めて GitHub に Issue を開く
