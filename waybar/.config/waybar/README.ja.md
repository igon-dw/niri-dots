# Waybar テーマ切り替え

このディレクトリには、Waybarのテーマを簡単に切り替えるための設定が含まれています。

## 📁 ディレクトリ構成

```
waybar/.config/waybar/
├── config.jsonc           # Waybarモジュールとレイアウト設定
├── base.css               # テーマ非依存のスタイル定義
├── style.css              # メインCSSファイル（動的生成、Git管理外）
├── style.css.template     # CSSテンプレート（Git管理）
├── scripts_for_waybar/    # Waybar用スクリプト
│   ├── switch-theme.sh    # テーマ切り替えスクリプト
│   ├── get-current-theme.sh  # 現在のテーマ名取得
│   └── get-mpris.sh       # メディアプレイヤー情報取得
└── themes/                # テーマ定義ディレクトリ
    ├── ayu.css
    ├── catppuccin.css
    ├── earthsong.css
    ├── everforest.css
    ├── flatland.css
    ├── gruvbox.css
    ├── night-owl.css
    ├── nord.css
    ├── original.css
    ├── palenight.css
    ├── shades-of-purple.css
    ├── solarized.css
    └── tokyo-night.css
```

## 🎨 利用可能なテーマ

- **Ayu** - オレンジとブルーのアクセントが特徴的。高コントラストで視認性が高く、コーディング作業に最適
- **Catppuccin (Mocha)** - ラベンダーとピンクのパステル調。目に優しく長時間作業でも疲れにくい、柔らかな印象
- **Earthsong** - ベージュとブラウンの自然な色合い。落ち着いた雰囲気で集中作業に向いた温かみのある配色
- **Everforest** - 緑を基調とした森林のような配色。低コントラストで目の負担が少なく、長時間のターミナル作業に最適
- **Flatland** - グレーベースのミニマルデザイン。装飾を抑えた洗練された印象で、ビジネス用途にも適している
- **Gruvbox** - 黄色・オレンジ・緑の暖色系レトロ配色。高コントラストで視認性が高く、プログラミング環境で人気
- **Night Owl** - 深い青紫の背景に明るいアクセント。夜間作業向けに設計され、ブルーライトを抑えた配色
- **Nord** - 青とグレーの寒色系カラーパレット。クールで落ち着いた印象、冬の北欧をイメージした統一感のある配色
- **Original** - このリポジトリ独自の配色。バランスの取れた汎用的なテーマ
- **Palenight** - 紫とピンクのMaterial Design調。モダンで洗練された印象、デザイン作業にも合う配色
- **Shades of Purple** - 鮮やかな紫を大胆に使用。個性的で印象的、クリエイティブな作業環境に適している
- **Solarized Dark** - 科学的に設計された16色パレット。コントラスト比を最適化し、長時間使用でも目の疲労を軽減
- **Tokyo Night** - 深い紺とネオンカラーの組み合わせ。夜の東京の雰囲気を表現した、モダンでスタイリッシュな配色

## 🎯 デザイン特性

Waybarは白っぽい背景画像でも視認性を維持するため、以下の工夫が施されています：

- **統一バー設計**: バー全体が一体感のある背景色を持ち、視認性を確保
- **モジュール識別**: 各モジュール（CPU、メモリ等）は微妙に濃い背景色により、左右対称な視覚的境界が形成される
- **丸みのあるデザイン**: すべてのモジュールに統一された8pxの角丸を採用し、洗練された外観を実現
- **タスクバー強調表示**: アクティブウィンドウは黄色のハイライトで視認性が高く、非アクティブウィンドウとの区別が明確

## 🚀 使い方

### 方法1: インタラクティブモード（fuzzel使用）

引数なしでスクリプトを実行すると、fuzzelでテーマを選択できます：

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
```

これにより、`themes/` ディレクトリ内のすべてのテーマがfuzzelのdmenuで表示されます。選択するとデスクトップ通知でテーマ変更が確認できます。

### 方法2: コマンドライン引数

テーマ名を直接指定して切り替えることもできます：

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
~/.config/waybar/scripts_for_waybar/switch-theme.sh nord
~/.config/waybar/scripts_for_waybar/switch-theme.sh catppuccin
~/.config/waybar/scripts_for_waybar/switch-theme.sh tokyo-night
~/.config/waybar/scripts_for_waybar/switch-theme.sh ayu
~/.config/waybar/scripts_for_waybar/switch-theme.sh everforest
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

> **ヒント**: テーマ名は Waybar と Kitty で統一されているため（Waybarの`original`を除く）、ほとんどの場合は自動的に両方に適用されます。

### 方法4: Waybar上のテーマボタンから

`config.jsonc` で定義されている `custom/theme` モジュールをクリックすると、テーマ切り替えメニューが表示されます。現在のテーマ名も表示されます。

### 方法5: 手動編集（非推奨）

`style.css.template` の `@import` 行を編集して、テンプレートからstyle.cssを生成することもできますが、スクリプトの使用を推奨します。

```css
@import "themes/gruvbox.css"; /* この行を変更 */
@import "base.css";
```

## 🔧 テーマ切り替えの仕組み

1. **テンプレートベース**: `style.css.template` をベースに、選択したテーマに応じて `style.css` を動的生成
2. **自動再起動**: テーマ変更後、Waybarを自動的に再起動して変更を適用
3. **通知表示**: `notify-send` で変更完了を通知（mako通知デーモンが必要）
4. **Git管理**: `style.css` は `.gitignore` に含まれ、動的生成されるため競合しません

## 📦 Waybarモジュール

現在の設定には以下のモジュールが含まれています：

### 左側

- `custom/appmenu` - アプリケーションランチャー（fuzzel）
- `cpu` - CPU使用率
- `temperature` - CPU温度
- `disk` - ディスク使用量
- `memory` - メモリ使用量
- `custom/gpu` - GPU情報
- `wlr/taskbar` - タスクバー

### 中央

- `clock` - 時計
- `niri/workspaces` - ワークスペース
- `custom/makoDismiss` - 通知を全消去

### 右側

- `custom/mpris` - メディアプレイヤー情報
- `custom/theme` - 現在のテーマ表示とテーマ切り替え
- `niri/language` - キーボードレイアウト
- `tray` - システムトレイ
- `pulseaudio` - 音量コントロール
- `custom/wlogout` - ログアウトメニュー

## ➕ 新しいテーマの追加

1. `themes/` ディレクトリに新しい `.css` ファイルを作成
2. 既存のテーマファイルをテンプレートとして使用
3. すべての `@define-color` 変数を定義（下記リスト参照）
4. スクリプトが自動的に新しいテーマを検出します

### 必要な色変数（完全リスト）

新しいテーマには以下のすべての変数を定義する必要があります：

#### 基本色

```css
@define-color bar_bg                  /* バー全体の背景色 */
@define-color module_bg               /* モジュールの背景色 */
@define-color module_border           /* モジュールの枠線色 */
@define-color global_fg               /* 全体の文字色 */
@define-color tooltip_bg              /* ツールチップ背景 */
@define-color tooltip_border          /* ツールチップ枠線 */
```

#### アプリメニュー

```css
@define-color appmenu_fg              /* アプリメニュー文字色 */
@define-color appmenu_hover_fg        /* アプリメニューホバー文字色 */
```

#### システムモニタリングモジュール

```css
@define-color cpu_fg                  /* CPU文字色 */
@define-color temperature_fg          /* 温度文字色 */
@define-color disk_fg                 /* ディスク文字色 */
@define-color gpu_fg                  /* GPU文字色 */
@define-color memory_fg               /* メモリ文字色 */
```

#### タスクバー

```css
@define-color taskbar_btn_bg          /* タスクバーボタン背景 */
@define-color taskbar_btn_border      /* タスクバーボタン枠線 */
@define-color taskbar_btn_hover_bg    /* タスクバーホバー背景 */
@define-color taskbar_btn_hover_border /* タスクバーホバー枠線 */
@define-color taskbar_btn_active_bg   /* タスクバーアクティブ背景 */
@define-color taskbar_btn_active_border /* タスクバーアクティブ枠線 */
```

#### 時計

```css
@define-color clock_fg                /* 時計文字色 */
```

#### システムトレイ

```css
@define-color tray_hover_fg           /* トレイホバー文字色 */
```

#### ログアウトボタン

```css
@define-color logout_fg               /* ログアウト文字色 */
@define-color logout_hover_fg         /* ログアウトホバー文字色 */
```

#### メニューアイテム

```css
@define-color menuitem_fg             /* メニュー文字色 */
@define-color menuitem_bg             /* メニュー背景 */
@define-color menuitem_hover_bg       /* メニューホバー背景 */
@define-color menuitem_hover_fg       /* メニューホバー文字色 */
```

#### テーマボタン

```css
@define-color theme_fg                /* テーマボタン文字色 */
```

#### メディアプレイヤー

```css
@define-color mpris_fg                /* MPRIS文字色 */
```

## 🔧 依存関係

### 必須

- `sed` - テキスト処理（標準的なUnixツール）
- `pkill` - プロセス管理（標準的なUnixツール）
- `waybar` - ステータスバー本体

### 推奨

- `fuzzel` - インタラクティブなテーマ選択用
- `mako` または `dunst` - デスクトップ通知用（notify-send）
- `btop` または `htop` - システムモニター（モジュールクリック時に起動）
- `wlogout` - ログアウトメニュー用

fuzzelやmakoがインストールされていない場合でも、コマンドライン引数でテーマを切り替えることができます。

## 💡 ヒント

### Niriでのキーバインド設定

Niriの設定ファイル（`~/.config/niri/config.kdl`）で、テーマ切り替えをキーに割り当てることができます：

```kdl
binds {
    // Waybar 単体のテーマ切り替え
    Mod+Shift+T { spawn "sh" "-c" "~/.config/waybar/scripts_for_waybar/switch-theme.sh"; }

    // 統合テーマ切り替え（Waybar + Kitty + Niri）
    Mod+T { spawn "sh" "-c" "~/.config/niri/scripts_for_niri/change-all-themes.sh"; }
}
```

### 現在のテーマ名を取得

`get-current-theme.sh` スクリプトで現在適用されているテーマ名を取得できます：

```bash
~/.config/waybar/scripts_for_waybar/get-current-theme.sh
```

このスクリプトは `custom/theme` モジュールでも使用されています。

### rofiとの連携

fuzzelの代わりにrofiを使いたい場合は、`switch-theme.sh` スクリプト内の `fuzzel --dmenu` を `rofi -dmenu` に変更してください。

### 統合テーマ切り替えの詳細

統合スクリプトは以下の順序で動作します：

1. Waybar のテーマディレクトリから利用可能なテーマをリスト化
2. Fuzzel で選択
3. Waybar にテーマを適用（自動再起動）
4. 同じ名前の Kitty テーマファイルが存在するかチェック
5. 存在する場合は自動適用、存在しない場合は手動選択を促す
6. すべて成功したら統合通知を表示

**テーマ名の統一性：**

- Waybar: 13テーマ（ayu, catppuccin, earthsong, everforest, flatland, gruvbox, night-owl, nord, **original**, palenight, shades-of-purple, solarized, tokyo-night）
- Kitty: 12テーマ（上記から`original`を除く）
- ファイル名は拡張子を除いて完全に一致

## 📝 技術的な詳細

### CSS構成

- GTK互換の `@define-color` を使用して配色を管理
- `@import` ディレクティブでモジュール化された構成
- テーマファイル（`themes/*.css`）は色変数の定義のみ
- レイアウトとスタイル定義は `base.css` に集約
- テーマファイルは完全に独立しており、保守が容易

### スクリプトの動作

1. `style.css.template` をベースに使用
2. テーマ選択に応じて `@import` 行を置換
3. 新しい `style.css` を生成
4. Waybarを再起動して変更を適用
5. notify-sendで通知を表示

### テンプレート方式の利点

- Git競合が発生しない（style.cssは管理外）
- 新環境でのセットアップが容易
- バックアップファイル不要
- 冪等性が保証される

## 🐛 トラブルシューティング

### テーマが適用されない

Waybarを手動で再起動してみてください：

```bash
pkill -x waybar && waybar &
```

### fuzzelが動作しない

fuzzelがインストールされているか確認してください：

```bash
command -v fuzzel
```

インストールされていない場合は、コマンドライン引数でテーマを指定してください。

### スクリプトが実行権限を持たない

スクリプトが実行可能か確認して、必要に応じて権限を付与してください：

```bash
chmod +x ~/.config/waybar/scripts_for_waybar/*.sh
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

### style.cssが生成されない

テンプレートファイルが存在するか確認してください：

```bash
ls -la ~/.config/waybar/style.css.template
```

存在しない場合は、リポジトリから再取得してください。

### custom/themeモジュールが動作しない

`get-current-theme.sh` スクリプトが実行可能か確認してください：

```bash
~/.config/waybar/scripts_for_waybar/get-current-theme.sh
```

## 📚 リソース

- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar Configuration](https://github.com/Alexays/Waybar/wiki/Configuration)
- [Waybar Styling](https://github.com/Alexays/Waybar/wiki/Styling)
- [Niri Compositor](https://github.com/YaLTeR/niri)

## 🔗 統合テーマシステム

このWaybar設定は、niri-dotsリポジトリの統合テーマシステムの一部です。

### テーマの統一性

Waybar と Kitty のテーマは、**拡張子を除いたファイル名が統一**されています：

| テーマ名         | Waybar | Kitty |
| ---------------- | ------ | ----- |
| ayu              | ✓      | ✓     |
| catppuccin       | ✓      | ✓     |
| earthsong        | ✓      | ✓     |
| everforest       | ✓      | ✓     |
| flatland         | ✓      | ✓     |
| gruvbox          | ✓      | ✓     |
| night-owl        | ✓      | ✓     |
| nord             | ✓      | ✓     |
| original         | ✓      | ✗     |
| palenight        | ✓      | ✓     |
| shades-of-purple | ✓      | ✓     |
| solarized        | ✓      | ✓     |
| tokyo-night      | ✓      | ✓     |

### 新しいテーマの追加手順

統合テーマシステムに新しいテーマを追加する場合：

1. **Waybar テーマを作成**: `waybar/.config/waybar/themes/newtheme.css`
   - すべての必要な色変数を定義（上記の完全リスト参照）
2. **Kitty テーマを作成**: `kitty/.config/kitty/themes/newtheme.conf`
   - background, foreground, cursor, selection_background, color0-15を定義
3. **ファイル名を統一**: 拡張子を除いた名前を同じにする（例: `newtheme`）
4. **Git にコミット**: 両方のファイルをコミット
5. **統合スクリプトで確認**: `change-all-themes.sh` で動作確認

これにより、デスクトップ全体で一貫したカラーテーマを維持できます。

## 📄 ライセンス

この設定は [niri-dots](https://github.com/igon-dev/niri-dots) リポジトリの一部です。
