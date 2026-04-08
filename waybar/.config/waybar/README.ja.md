# Waybar 設定

このディレクトリには、このリポジトリで使っている Waybar 設定一式が入っています。テーマ切り替え、Kitty / Ghostty 向け config variant、Niri 連携用の custom module を含みます。

---

## 概要

現在の Waybar 構成は主に以下で成り立っています。

- タスクバー風の custom Niri window list
- Kitty / Ghostty 向けの端末別 config variant
- テンプレートベースの CSS テーマ切り替え
- クリック可能なテーマ表示モジュール
- MPRIS と通知操作の統合

主なファイル:

- `config.jsonc`
- `config.jsonc.kitty`
- `config.jsonc.ghostty`
- `base.css`
- `style.css.template`
- `themes/`
- `scripts_for_waybar/`

補足:

- `style.css` は実行時に生成されるファイルなので、直接編集する前提ではありません。
- `config.jsonc` は active な tracked config で、Kitty / Ghostty variant のどちらかを指す運用を想定しています。

---

## ディレクトリ構成

```text
waybar/.config/waybar/
|- config.jsonc
|- config.jsonc.kitty
|- config.jsonc.ghostty
|- base.css
|- style.css
|- style.css.template
|- themes/
|  |- ayu.css
|  |- catppuccin.css
|  |- earthsong.css
|  |- everforest.css
|  |- flatland.css
|  |- gruvbox.css
|  |- night-owl.css
|  |- nord.css
|  |- original.css
|  |- palenight.css
|  |- shades-of-purple.css
|  |- solarized.css
|  `- tokyo-night.css
`- scripts_for_waybar/
   |- switch-theme.sh
   |- get-current-theme.sh
   |- get-mpris.sh
   |- niri-taskbar.py
   |- niri-taskbar-watcher.sh
   `- pomo.sh
```

---

## Config Variants

このリポジトリでは Waybar に 2 種類の config variant を持っています。

- `config.jsonc.kitty`: 監視系モジュールが Kitty で補助ツールを開く
- `config.jsonc.ghostty`: 監視系モジュールが Ghostty で補助ツールを開く

active な `config.jsonc` は、これらのどちらかを指す形で運用します。リポジトリ側の切り替えは以下で行います。

```bash
bash niri/.config/niri/scripts_for_niri/switch-terminal.sh
```

切り替え後、必要に応じて Niri を再読み込みしてください。

```bash
niri msg action reload-config
```

---

## テーマ切り替え

### インタラクティブモード

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
```

### テーマ名を直接指定

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh gruvbox
~/.config/waybar/scripts_for_waybar/switch-theme.sh tokyo-night
```

### 統合テーマ切り替え

端末側も含めてまとめて切り替える場合:

```bash
~/.config/niri/scripts_for_niri/change-all-themes.sh
```

このフローでは、Waybar のテーマを一度選ぶと、その名前に対応する Kitty / Ghostty テーマも可能な範囲で適用します。

### 仕組み

- `switch-theme.sh` が `style.css.template` を `style.css` としてコピーする
- `@import "themes/<name>.css";` の行を書き換える
- Waybar を再起動する
- 変更後のテーマ名を通知する

バー上に表示される現在テーマ名は `scripts_for_waybar/get-current-theme.sh` で取得しています。

---

## Custom Modules

### `custom/taskbar`

タスクバーは `scripts_for_waybar/niri-taskbar.py` で実装しています。

このスクリプトは:

- `niri msg -j windows`、`workspaces`、`outputs` を読む
- モニタ位置、workspace index、カラム位置でウィンドウを並べる
- Pango markup でコンパクトなアイコンタスクバーを描画する
- focused window を強調表示する

クリック時には Niri の fuzzy window picker を開きます。

```bash
~/.config/niri/scripts_for_niri/niri-window-picker.sh
```

### `niri-taskbar-watcher.sh`

この watcher は Niri の event stream を監視し、対象イベントが来た時に `SIGRTMIN+8` を Waybar へ送ります。

Niri の startup で起動しておくことで、短い polling だけに頼らず taskbar を更新できます。

### `custom/mpris`

このモジュールは `scripts_for_waybar/get-mpris.sh` を使い、プレイヤーアイコンと曲名を短く表示します。

操作:

- click: play/pause
- scroll up/down: `playerctl` による volume control

### `custom/theme`

現在テーマを表示し、クリックで theme selector を開きます。

### `custom/makoDismiss`

`makoctl dismiss -a` で通知を全消去します。

---

## 現在のモジュール配置

左側:

- `custom/appmenu`
- `cpu`
- `temperature`
- `disk`
- `memory`
- `custom/gpu`
- `custom/taskbar`

中央:

- `clock`
- `niri/workspaces`
- `custom/makoDismiss`

右側:

- `custom/mpris`
- `custom/theme`
- `tray`
- `pulseaudio`
- `custom/wlogout`

---

## 利用可能なテーマ

現在のテーマ一覧:

- `ayu` — オレンジとブルーのアクセント、高コントラストでコーディング向き
- `catppuccin` — ラベンダーとピンクのパステル調、長時間作業でも目に優しい
- `earthsong` — ベージュとブラウンの自然な色合い、落ち着いた集中作業向き
- `everforest` — 緑を基調とした森林パレット、低コントラストで目の負担が少ない
- `flatland` — グレーベースのミニマルデザイン、洗練されたプロフェッショナル向き
- `gruvbox` — 黄色・オレンジ・緑の暖色レトロ配色、プログラマーに人気
- `night-owl` — 深い青紫の背景に明るいアクセント、夜間作業向け
- `nord` — 青とグレーの寒色パレット、北欧の冬をイメージしたクールな配色
- `original` — このリポジトリ独自のカスタムテーマ、バランスの良い汎用配色
- `palenight` — 紫とピンクの Material Design 調、モダンで洗練された印象
- `shades-of-purple` — 鮮やかな紫を大胆に使用、個性的でクリエイティブ向き
- `solarized` — 科学的に設計された 16 色パレット、コントラスト比を最適化
- `tokyo-night` — 深い紺とネオンカラー、夜の東京の雰囲気を表現

大半のテーマ名は Kitty 側と揃っています。`original` は Waybar 専用です。

---

## 新しいテーマを追加する

1. `themes/` 配下に新しいファイルを追加する。例: `themes/my-theme.css`
2. `base.css` が期待する色変数をすべて定義する（下記リスト参照）
3. theme switcher を実行して新テーマを選ぶ
4. 統合テーマ切り替えも使いたい場合は、Kitty / Ghostty 側にも対応テーマを追加する

### 必要な色変数

新テーマでは以下の `@define-color` 変数をすべて定義する必要があります。既存テーマファイルをベースにするのが手軽です。

#### 基本色

```css
@define-color bar_bg           /* バー全体の背景色 */
@define-color module_bg        /* モジュール背景色 */
@define-color module_border    /* モジュール枠線色 */
@define-color global_fg        /* 全体の文字色 */
@define-color tooltip_bg       /* ツールチップ背景 */
@define-color tooltip_border; /* ツールチップ枠線 */
```

#### アプリメニュー

```css
@define-color appmenu_fg       /* アプリメニュー文字色 */
@define-color appmenu_hover_fg; /* アプリメニューホバー文字色 */
```

#### システムモニタリングモジュール

```css
@define-color cpu_fg           /* CPU 文字色 */
@define-color temperature_fg   /* 温度文字色 */
@define-color disk_fg          /* ディスク文字色 */
@define-color gpu_fg           /* GPU 文字色 */
@define-color memory_fg; /* メモリ文字色 */
```

#### タスクバー

```css
@define-color taskbar_btn_bg           /* ボタン背景 */
@define-color taskbar_btn_border       /* ボタン枠線 */
@define-color taskbar_btn_hover_bg     /* ホバー背景 */
@define-color taskbar_btn_hover_border /* ホバー枠線 */
@define-color taskbar_btn_active_bg    /* アクティブ背景 */
@define-color taskbar_btn_active_border; /* アクティブ枠線 */
```

#### 時計、トレイ、ログアウト

```css
@define-color clock_fg         /* 時計文字色 */
@define-color tray_hover_fg    /* システムトレイホバー文字色 */
@define-color logout_fg        /* ログアウトボタン文字色 */
@define-color logout_hover_fg; /* ログアウトボタンホバー文字色 */
```

#### メニューアイテム

```css
@define-color menuitem_fg       /* メニュー文字色 */
@define-color menuitem_bg       /* メニュー背景 */
@define-color menuitem_hover_bg /* メニューホバー背景 */
@define-color menuitem_hover_fg; /* メニューホバー文字色 */
```

#### テーマボタンとメディアプレイヤー

```css
@define-color theme_fg         /* テーマ表示文字色 */
@define-color mpris_fg; /* MPRIS モジュール文字色 */
```

---

## 依存関係

この Waybar 構成でよく使う runtime dependency:

- `waybar`
- `fuzzel`
- `niri`
- `python3`
- `playerctl`
- `makoctl`
- `notify-send`
- `btop`
- `nvtop`
- `sensors`
- `pavucontrol`
- `wlogout`

taskbar、theme button、MPRIS module が正しく動かない場合は、まず対応コマンドの有無を確認してください。

---

## トラブルシューティング

### テーマ変更が反映されない

```bash
~/.config/waybar/scripts_for_waybar/switch-theme.sh
pkill -x waybar
waybar
```

### taskbar が空になる / 更新されない

```bash
python3 ~/.config/waybar/scripts_for_waybar/niri-taskbar.py
pgrep -af niri-taskbar-watcher.sh
```

### MPRIS モジュールが空になる

```bash
playerctl metadata
playerctl status
```

---

## リソース

- [Waybar GitHub](https://github.com/Alexays/Waybar)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Waybar Styling Guide](https://github.com/Alexays/Waybar/wiki/Styling)
- [Niri Compositor](https://github.com/YaLTeR/niri)
