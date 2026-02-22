autoload -U compinit
compinit

export EDITOR="nvim"

# ローカル設定 (OS 特有の設定や PATH 登録) があれば読み込む
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# zprompt settings
export ZPROMPT_ICON="🌏"
export ZPROMPT_DIR_COLOR="bright_blue"
export ZPROMPT_GIT_COLOR="green"
setopt promptsubst
PROMPT='$(zprompt)'

# fzf (ripgrep と bat が必要)
# export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
# fzf の見た目とプレビュー設定
export FZF_DEFAULT_OPTS='--height 50% --border --preview "bat --style=numbers --color=always --line-range :500 {}"'


# ghq のリポジトリ検索 + 移動
function fzf-src () {
# FZF_DEFAULT_OPTS= とすることで環境変数に設定したソースコード検索用のオプションを無効化する
local selected_dir=$(ghq list -p | FZF_DEFAULT_OPTS= fzf --reverse --prompt="Repo >")
if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
fi
}
zle -N fzf-src
bindkey '^]' fzf-src

# alias
alias nv="nvim"

## git
# alias pull="git pull origin $(git branch --show-current)"
# alias push="git push origin $(git branch --show-current)"
alias gs="git status"
## gh
alias ghb="gh browse"
alias ghpr="gh pr create -w"

## .conf ファイルのコメントアウトされていない行を表示する
alias confdiff="grep -v -e '^\s*#' -e '^\s*$'"

## 日常
alias todo="zim ~/todo.md"
alias memo="zim ~/memo.md"
alias yolo="claude --dangerously-skip-permissions"

## Copilot CLI aliases with tool management
alias copilot-haiku='copilot-with-tools.zsh haiku investigation'
alias copilot-sonnet='copilot-with-tools.zsh sonnet investigation'
alias copilot-haiku-dev='copilot-with-tools.zsh haiku development'

## codex
alias codex-fullauto="codex --full-auto"
alias codex-fullauto-network="codex --full-auto -c sandbox_workspace_write.network_access=true"
alias codex-yolo="codex --dangerously-bypass-approvals-and-sandbox"

# この設定がないと gpg 鍵で commit の署名ができない (なんで？
export GPG_TTY=$(tty)

function tkill() {
    # PATH が通ってる場所に配置されている前提
    tmux-kill.zsh
}
# Tmux Session Manager for Zsh
function tmux-session() {
  local session_name dir change

  # 1. 引数がある場合: その名前でセッション作成・移動
  if [[ -n "$1" ]]; then
    session_name="$1"
    # セッションがなければ作成 (カレントディレクトリで)
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -d -s "$session_name"
    fi

  # 2. 引数がない場合: ghq + fzf でリポジトリ選択
  else
    # ghq list -p でフルパスを取得し、fzfで選択
    dir=$(ghq list -p | FZF_DEFAULT_OPTS= fzf --reverse --prompt="Repo > ")

    # キャンセルされたら終了
    [[ -z "$dir" ]] && return 1

    # フルパスの "/" を "_" に変換してセッション名を決定
    session_name=${dir//\//_}

    # "." を含むとtmuxが嫌がる場合があるので "_" に置換（お好みで）
    session_name=${session_name//./_}

    # セッションがなければ作成 (選択したディレクトリで)
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      tmux new-session -d -c "$dir" -s "$session_name"
    fi
  fi

  # 3. tmux内なら switch-client、外なら attach-session
  if [[ -n "$TMUX" ]]; then
    change="switch-client"
  else
    change="attach-session"
  fi

  tmux $change -t "$session_name"
}

function zle-tmux-session() {
  BUFFER="tmux-session"
  zle accept-line
}
zle -N zle-tmux-session
# Ctrl + g
bindkey '^g' zle-tmux-session


# 開発中の zmux (tmux 置き換え目標) 用の関数
function zmux-session() {
  local session_name dir
  local ZMUX_BIN="${ZMUX_BIN:-$HOME/.cargo/bin/zmux}"

  # zmux が存在しない場合はエラー
  if [[ ! -x "$ZMUX_BIN" ]]; then
    echo "Error: zmux not found at $ZMUX_BIN" >&2
    return 1
  fi

  # ghq でリポジトリを選択
  dir=$(ghq list -p | fzf --reverse --prompt="Repo > ")
  [[ -z "$dir" ]] && return 1

  # セッション名を生成（サニタイズ）
  session_name=$dir
  session_name=${session_name//[.\/[:space:]]/_}

  if [[ -n "$ZMUX" ]]; then
    # ===== zmux 内にいる場合 =====
    # セッションが存在しない場合のみ作成（detach モード）
    if ! "$ZMUX_BIN" has-session "$session_name" 2>/dev/null; then
      "$ZMUX_BIN" new --name "$session_name" --path "$dir" --detach
    fi

    # セッション切り替え要求を送信
    # これは親の zmux TUI にセッション切り替えを指示する
    # （入れ子にならず、既存のセッションも破壊しない）
    "$ZMUX_BIN" switch "$session_name"
  else
    # ===== zmux 外にいる場合 =====
    if "$ZMUX_BIN" has-session "$session_name" 2>/dev/null; then
      # 既存セッションに接続
      "$ZMUX_BIN" attach "$session_name"
    else
      # 新規セッション作成（自動で attach される）
      "$ZMUX_BIN" new --name "$session_name" --path "$dir"
    fi
  fi
}

function zle-zmux-session() {
  BUFFER="zmux-session"
  zle accept-line
}
zle -N zle-zmux-session
bindkey '^z' zle-zmux-session

