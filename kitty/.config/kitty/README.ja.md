# Kitty ターミナル設定

このディレクトリには、Kitty ターミナルエミュレータの設定ファイルと、動的なテーマ切り替え機能が含まれています。

## 📁 ディレクトリ構成

```
kitty/.config/kitty/
├── README.md                      # 英語版ドキュメント
├── README.ja.md                   # 日本語版ドキュメント（このファイル）
├── THEMES.md                      # テーマ情報と帰属表示
├── kitty.conf                     # メインの Kitty 設定ファイル
├── current-theme.conf             # アクティブテーマへのシンボリックリンク（自動生成、Git管理外）
├── themes/                        # 利用可能なカラースキーム（12テーマ）
│   ├── ayu.conf
│   ├── catppuccin.conf
│   ├── earthsong.conf
│   ├── everforest.conf
│   ├── flatland.conf
│   ├── gruvbox.conf
│   ├── night-owl.conf
│   ├── nord.conf
│   ├── palenight.conf
│   ├── shades-of-purple.conf
│   ├── solarized.conf
│   └── tokyo-night.conf
└── scripts/                       # テーマ管理ユーティリティ
    ├── switch-theme.sh            # テーマ切り替えスクリプト（初回実行時に自動初期化）
    └── list-themes.sh             # 利用可能なテーマを一覧表示
```

## 🎨 利用可能なテーマ

Waybar のテーマコレクションと統一されており、**拡張子を除いたファイル名が完全に一致**しています：

- **Ayu** - オレンジとブルーのアクセントが特徴的。高コントラストで視認性が高く、コーディング作業に最適（デフォルト: Earthsong）
- **Catppuccin** - ラベンダーとピンクのパステル調。目に優しく長時間作業でも疲れにくい、柔らかな印象
- **Earthsong** - ベージュとブラウンの自然な色合い。落ち着いた雰囲気で集中作業に向いた温かみのある配色（デフォルト）
- **Everforest** - 緑を基調とした森林のような配色。低コントラストで目の負担が少なく、長時間のターミナル作業に最適
- **Flatland** - グレーベースのミニマルデザイン。装飾を抑えた洗練された印象で、ビジネス用途にも適している
- **Gruvbox** - 黄色・オレンジ・緑の暖色系レトロ配色。高コントラストで視認性が高く、プログラミング環境で人気
- **Night Owl** - 深い青紫の背景に明るいアクセント。夜間作業向けに設計され、ブルーライトを抑えた配色
- **Nord** - 青とグレーの寒色系カラーパレット。クールで落ち着いた印象、冬の北欧をイメージした統一感のある配色
- **Palenight** - 紫とピンクのMaterial Design調。モダンで洗練された印象、デザイン作業にも合う配色
- **Shades of Purple** - 鮮やかな紫を大胆に使用。個性的で印象的、クリエイティブな作業環境に適している
- **Solarized** - 科学的に設計された16色パレット。コントラスト比を最適化し、長時間使用でも目の疲労を軽減
- **Tokyo Night** - 深い紺とネオンカラーの組み合わせ。夜の東京の雰囲気を表現した、モダンでスタイリッシュな配色

> **注記**: Waybar には追加で `original` テーマがありますが、Kitty には対応するテーマがありません。

## 🚀 使い方

### 方法1: インタラクティブモード（fuzzel使用）

引数なしでスクリプトを実行すると、fuzzelでテーマを選択できます：

```bash
~/.config/kitty/scripts/switch-theme.sh
```

これにより、`themes/` ディレクトリ内のすべてのテーマがfuzzelのdmenuで表示されます。選択するとデスクトップ通知でテーマ変更が確認できます。

**注記**: 初回実行時、`switch-theme.sh` は自動的に `current-theme.conf` を作成し、デフォルトのテーマ（Earthsong）で初期化されます。

### 方法2: コマンドライン引数

テーマ名を直接指定して切り替えることもできます：

```bash
~/.config/kitty/scripts/switch-theme.sh catppuccin
~/.config/kitty/scripts/switch-theme.sh tokyo-night
~/.config/kitty/scripts/switch-theme.sh nord
~/.config/kitty/scripts/switch-theme.sh gruvbox
~/.config/kitty/scripts/switch-theme.sh everforest
~/.config/kitty/scripts/switch-theme.sh ayu
```

### 方法3: 統合テーマ切り替え（推奨）

**Waybar、Kitty、Niriのテーマを一括で変更**する統合スクリプトを使用できます：

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

このスクリプトは：

1. Waybar のテーマリストから fuzzel でテーマを選択
2. Waybar のテーマを自動的に適用
3. 同じ名前の Kitty テーマが存在すれば自動的に適用
4. Kitty テーマが存在しない場合は、手動選択を促す
5. 完了時に通知を表示

> **ヒント**: テーマ名は Waybar と Kitty で統一されているため、ほとんどの場合は自動的に両方に適用されます。

### 方法4: テーマ一覧の確認

利用可能なテーマを確認するには：

```bash
# フォーマット済み出力（現在のテーマに*マークが付く）
~/.config/kitty/scripts/list-themes.sh

# シンプル出力（スクリプト用）
~/.config/kitty/scripts/list-themes.sh --simple
```

出力例（フォーマット済み）：

```
Available themes:

  * earthsong (current)
    flatland
    solarized
    gruvbox
    nord
    tokyo-night
    catppuccin
    ayu
    everforest
    night-owl
    palenight
    shades-of-purple
```

## 🔧 テーマ切り替えの仕組み

### Stow との連携したハイブリッドアプローチ

この設定は**ハイブリッドアプローチ**を採用し、シンボリックリンクと Kitty のリモートコントロール機能を組み合わせています：

1. **Stow 管理**: メイン設定ファイルを Stow で管理
   - `kitty.conf` → niri-dots からシンボリックリンク
   - `themes/*.conf` → niri-dots からシンボリックリンク
   - `scripts/*.sh` → niri-dots からシンボリックリンク

2. **動的テーマリンク**: `current-theme.conf` は相対シンボリックリンク
   - スクリプトによって作成（Git 管理外）
   - `./themes/<ThemeName>.conf` を指す
   - シンボリックリンクの連鎖：`current-theme.conf` → `themes/X.conf` → 実ファイル

3. **自動初期化**: 初回実行時に自動的に `current-theme.conf` を作成
   - Stow 後の手動セットアップは不要
   - デフォルトは Earthsong テーマ

4. **リアルタイム更新**: テーマを切り替えた時
   - `current-theme.conf` シンボリックリンクを更新
   - 実行中の Kitty インスタンスにリモートコントロール API で反映
   - 新しいウィンドウ/タブは新しいテーマを自動的に使用

5. **通知表示**: `notify-send` で変更完了を通知（mako または dunst が必要）

### シンボリックリンクの連鎖が機能する理由

```
~/.config/kitty/current-theme.conf (スクリプトが生成するシンボリックリンク)
    ↓
~/.config/kitty/themes/earthsong.conf (Stow が作成するシンボリックリンク)
    ↓
~/niri-dots/kitty/.config/kitty/themes/earthsong.conf (実際のファイル)
```

Linux はこの連鎖を透過的に処理します。Kitty は最終的なファイル内容を読み取ります。

## 📝 メイン設定

`kitty.conf` には以下の設定が含まれています：

- **フォント**: JetBrainsMono Nerd Font Mono（14pt）
- **透明度**: 背景透明度 0.8
- **テーマ**: `include ./current-theme.conf` で動的に読み込み
- **キーバインディング**:
  - `Shift+Ctrl+Return`: 新しいタブを開く
  - `Shift+Ctrl+H`: 前のタブに移動
  - `Shift+Ctrl+L`: 次のタブに移動
- **リモートコントロール**: ライブテーマ切り替えに対応

## ➕ 新しいテーマの追加

1. `themes/` ディレクトリに新しい `.conf` ファイルを作成：

   ```sh
   # テーマファイルのフォーマット例
   cat > themes/myTheme.conf << EOF
   background            #282420
   foreground            #e5c6a8
   cursor                #f6f6ec
   selection_background  #111417
   color0                #111417
   color1                #f22c40
   color2                #5ab738
   color3                #d5911a
   color4                #407ee7
   color5                #6666ea
   color6                #00ad9c
   color7                #a8a19f
   color8                #766e6b
   color9                #f22c40
   color10               #5ab738
   color11               #d5911a
   color12               #407ee7
   color13               #6666ea
   color14               #00ad9c
   color15               #f1efee
   EOF
   ```

2. **Waybar との統合（推奨）**: 統合テーマ切り替えを使用する場合は、Waybar にも同じ名前のテーマを追加してください：

   ```bash
   # Waybar のテーマも作成（色変数は異なる形式）
   nano ~/niri-dots/waybar/.config/waybar/themes/myTheme.css
   ```

3. Git にコミット：

   ```sh
   git add themes/myTheme.conf
   git commit -m "Add myTheme color scheme"
   ```

4. 新しいテーマに切り替え：

   ```sh
   ~/.config/kitty/scripts/switch-theme.sh myTheme
   ```

### 必要なカラー設定

新しいテーマには以下の設定が必要です：

- `background` - 背景色
- `foreground` - 前景色（テキスト）
- `cursor` - カーソル色
- `selection_background` - 選択範囲の背景色
- `color0` ～ `color15` - 16色のパレット（ANSI カラー）

## 🔧 依存関係

### 必須

- `kitty` - ターミナルエミュレータ本体
- `ln` - シンボリックリンク作成（標準的なUnixツール）

### 推奨

- `fuzzel` - インタラクティブなテーマ選択用
- `mako` または `dunst` - デスクトップ通知用（notify-send）
- `pgrep` - プロセス確認用（標準的なUnixツール）

fuzzelやmakoがインストールされていない場合でも、コマンドライン引数でテーマを切り替えることができます。

## 💡 ヒント

### Niriでのキーバインド設定

Niriの設定ファイル（`~/.config/niri/config.kdl`）で、テーマ切り替えをキーに割り当てることができます：

```kdl
binds {
    // Kitty 単体のテーマ切り替え
    Mod+Shift+T { spawn "sh" "-c" "~/.config/kitty/scripts/switch-theme.sh"; }

    // 統合テーマ切り替え（Waybar + Kitty + Niri）
    Mod+T { spawn "sh" "-c" "~/.config/niri/scripts_for_niri/change-all-themes.sh"; }
}
```

### 現在のテーマを確認

```bash
readlink ~/.config/kitty/current-theme.conf
# 出力例: ./themes/earthsong.conf
```

または：

```bash
~/.config/kitty/scripts/list-themes.sh
```

### rofiとの連携

fuzzelの代わりにrofiを使いたい場合は、`switch-theme.sh` スクリプト内の `fuzzel --dmenu` を `rofi -dmenu` に変更してください。

### 設定の手動リロード

テーマがすぐに反映されない場合：

```bash
# 設定を手動で再読み込み
kitty @ load-config

# または Kitty を再起動
```

## 🔗 Stow との統合

この設定は GNU Stow とシームレスに動作するように設計されています：

1. **Stow 前**: ファイルは `~/niri-dots/kitty/.config/kitty/` にある
2. **Stow 後**: ファイルは `~/.config/kitty/` にシンボリックリンクされる
3. **生成ファイル**: `current-theme.conf` は初回テーマ切り替え時に自動作成（`.gitignore` で除外）

### Stow コマンド

```bash
# 設定を配置
cd ~/niri-dots
stow kitty

# テーマは初回使用時に自動初期化
~/.config/kitty/scripts/switch-theme.sh

# 設定を削除
cd ~/niri-dots
stow -D kitty
```

### Git 統合

動的に生成される `current-theme.conf` はルートの `.gitignore` ファイルで除外されています：

```gitignore
waybar/.config/waybar/style.css
kitty/.config/kitty/current-theme.conf
```

## 🐛 トラブルシューティング

### "current-theme.conf: No such file or directory"

スイッチスクリプトを実行すれば自動初期化されます：

```bash
~/.config/kitty/scripts/switch-theme.sh
```

### 実行中のインスタンスにテーマが反映されない

Kitty のリモートコントロールが有効か確認してください：

```bash
kitty @ ls
```

エラーが出る場合は、`kitty.conf` に以下を追加：

```conf
allow_remote_control yes
listen_on unix:/tmp/kitty
```

その後 Kitty を再起動してください。

### テーマファイルが見つからない

テーマディレクトリの内容を確認：

```bash
ls -la ~/.config/kitty/themes/
```

Stow でシンボリックリンクが正しく作成されているか確認：

```bash
ls -la ~/.config/kitty/
```

### 通知が表示されない

通知デーモンが起動しているか確認してください：

```bash
pgrep -x mako  # または pgrep -x dunst
```

**確認結果の見方：**

- **数字が表示される**（例：1234）→ 通知デーモンが起動しています ✓
- **何も表示されない** → 通知デーモンが起動していません ✗

通知デーモン（makoまたはdunst）の起動方法は、お使いのディストロやセットアップによって異なります。以下のリソースを参考に、自分の環境に合わせて起動してください：

- [Mako公式ドキュメント](https://github.com/emersion/mako)
- [Dunst公式ドキュメント](https://dunst-project.org/)

### スクリプトが実行権限を持たない

スクリプトが実行可能か確認して、必要に応じて権限を付与してください：

```bash
chmod +x ~/.config/kitty/scripts/*.sh
```

## 📚 リソース

- [Kitty 公式ドキュメント](https://sw.kovidgoyal.net/kitty/)
- [Kitty リモートコントロール](https://sw.kovidgoyal.net/kitty/remote-control/)
- [Kitty カラーテーマ](https://github.com/kovidgoyal/kitty-themes)
- [Niri Compositor](https://github.com/YaLTeR/niri)

## 🎓 テーマの帰属表示

すべてのテーマの詳細情報、出典、ライセンス、作者については [THEMES.md](./THEMES.md) を参照してください。

主なポイント：

- ほとんどのテーマは公式リポジトリまたは [kovidgoyal/kitty-themes](https://github.com/kovidgoyal/kitty-themes) コレクションから取得
- すべてのテーマのファイルヘッダーに出典/アップストリーム情報を記載
- 2つのテーマ（Palenight、Shades of Purple）は Waybar テーマカラーをベースにしたカスタム改変版
- すべてのテーマは MIT またはMIT互換のオープンソースライセンス

## 🔗 統合テーマシステム

このKitty設定は、niri-dotsリポジトリの統合テーマシステムの一部です：

### テーマの統一性

- **Waybar**: 13テーマ（ayu, catppuccin, earthsong, everforest, flatland, gruvbox, night-owl, nord, **original**, palenight, shades-of-purple, solarized, tokyo-night）
- **Kitty**: 12テーマ（上記から`original`を除く）
- **ファイル名の統一**: 拡張子を除いて完全に一致

### 統合スクリプトの動作

`change-all-themes.sh` は以下のように動作します：

1. Waybar のテーマリストを基準にする（13テーマ）
2. Fuzzel で選択したテーマを Waybar に適用
3. 同じ名前の Kitty テーマが存在する場合は自動適用
4. Kitty テーマが存在しない場合（`original`の場合）は、手動選択を促す
5. 両方の適用が成功したら、成功通知を表示

### 新しいテーマの追加手順

統合テーマシステムに新しいテーマを追加する場合：

1. **Waybar テーマを作成**: `waybar/.config/waybar/themes/newtheme.css`
2. **Kitty テーマを作成**: `kitty/.config/kitty/themes/newtheme.conf`
3. **ファイル名を統一**: 拡張子を除いた名前を同じにする
4. **Git にコミット**: 両方のファイルをコミット
5. **統合スクリプトで確認**: `change-all-themes.sh` で動作確認

これにより、デスクトップ全体で一貫したカラーテーマを維持できます。

## 📄 ライセンス

この設定は [niri-dots](https://github.com/igon-dev/niri-dots) リポジトリの一部です。
