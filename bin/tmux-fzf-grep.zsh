#!/usr/bin/env zsh

# --- 設定 ---
# プレビューコマンド (bat)
PREVIEW_CMD='bat --style=numbers --color=always --highlight-line {2} {1}'

# 検索の大小文字モード
# 既定: --smart-case
CASE_FLAG="--smart-case"

if [[ "$1" == "sensitive" || "$1" == "--case-sensitive" ]]; then
  CASE_FLAG="--case-sensitive"
fi

# --- 1. 検索ルートの特定と移動 ---
# 現在地がGitリポジトリ内ならルートへ、そうでなければそのまま
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  GIT_ROOT=$(git rev-parse --show-toplevel)
  cd "$GIT_ROOT"
fi

# --- 2. FZF実行 (Interactive Mode) ---
# --bind "change:reload:...": ユーザーが入力するたびに rg を再実行する
# {q}: 入力したクエリ
# output format: ファイル名:行番号:カラム:内容
SELECTED_LINE=$(fzf --ansi --disabled \
    --layout reverse \
    --border \
    --bind "start:reload:echo 'Type to search...'" \
    --bind "change:reload:rg --column --line-number --no-heading --color=always ${CASE_FLAG} {q} || true" \
    --delimiter : \
    --preview "$PREVIEW_CMD" \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --prompt="Grep > "
)

# キャンセル時は終了
if [[ -z "$SELECTED_LINE" ]]; then
    exit 0
fi

# --- 3. ファイルパスと行番号の分解 ---
# rg の出力 (file:line:col:text) から file と line を抽出
# cut コマンドで : 区切りの 1番目と2番目 を取得
REL_PATH=$(echo "$SELECTED_LINE" | cut -d: -f1)
LINE_NUM=$(echo "$SELECTED_LINE" | cut -d: -f2)

# Zsh の機能 (:A) を使って絶対パスに変換 (realpath コマンド依存を排除)
FULL_PATH=${REL_PATH:A}

# --- 4. ペイン判定とコマンド送信 ---
CURRENT_PANE_CMD=$(tmux display-message -p "#{pane_current_command}")

if [[ "$CURRENT_PANE_CMD" =~ "(n?vim|git)" ]]; then
    # Vim系: 保存(:update) してから、行指定(+行番号) で開く
    # "C-u" で入力行をクリアして安全性を確保
    tmux send-keys "Escape" ":" "C-u" "update | e +$LINE_NUM $FULL_PATH" "Enter"
else
    # シェル: エディタコマンド +行番号 ファイルパス
    EDITOR_CMD=${EDITOR:-vim}
    tmux send-keys "C-u" "$EDITOR_CMD +$LINE_NUM $FULL_PATH" "Enter"
fi
