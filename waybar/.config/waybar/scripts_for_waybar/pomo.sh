#!/bin/bash

# --- 1. 設定セクション ---
# 作業時間（デバッグ用に短くしています。本番は25で）
DURATION_MIN=1
# プロセスIDを保存するファイル（後でシグナルを送る宛先になります）
PID_FILE="/tmp/pomo.pid"
# Waybar用のステータスファイル（まだ使いませんが定義だけ）
STATUS_FILE="/tmp/pomo_status.json"

# --- 2. 後始末関数 (Cleanup) ---
# スクリプトが終了する時（正常、エラー問わず）に必ず呼ばれます
cleanup() {
  echo "終了処理を行っています..."
  # ファイルが存在すれば削除
  rm -f "$PID_FILE" "$STATUS_FILE"
  exit 0
}

# --- 3. トラップ (Trap) の設定 ---
# "EXIT" シグナル（終了）を検知したら、cleanup関数を実行せよという命令
trap cleanup EXIT

# --- 4. 起動処理 ---
# 二重起動チェック（簡易版）
if [ -f "$PID_FILE" ]; then
  echo "既に起動しているようです。 (PIDファイルが存在します)"
  exit 1
fi

# 自分のPIDをファイルに書き込む
# $$ は「現在のプロセスのPID」を表す特殊変数です
echo $$ >"$PID_FILE"

echo "ポモドーロタイマーを起動しました (PID: $$)"

# --- 5. メイン処理 (カウントダウン) ---

# 分を秒に変換（算術式 $((...)) を使います）
# ※テスト用に短くしたい場合は DURATION_MIN=1 などのままにしてください
duration=$((DURATION_MIN * 60))
remaining=$duration

echo "カウントダウンを開始します: ${DURATION_MIN}分 (${duration}秒)"

# 残り時間が0になるまでループ
while [ $remaining -ge 0 ]; do
  # 1. 残り秒数を分:秒形式に変換して表示
  min=$((remaining / 60))
  sec=$((remaining % 60))

  time_fmt=$(printf "%02d:%02d" $min $sec)

done

echo "完了。"
# ここでスクリプトが終わると、自動的に cleanup が呼ばれます
