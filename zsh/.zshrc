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

# Takumi guard
export PIP_INDEX_URL=https://pypi.flatt.tech/simple/
export UV_INDEX_URL=https://pypi.flatt.tech/simple/

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
# alias todo="zim ~/todo.md"
alias todo="ztodo"
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

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/zztkm/.lmstudio/bin"
# End of LM Studio CLI section


claude-lm() {
    export ANTHROPIC_BASE_URL=http://localhost:1234
    export ANTHROPIC_AUTH_TOKEN=lmstudio
    export CLAUDE_CODE_MAX_TOOL_USE_CONCURRENCY="2"
    export CLAUDE_CODE_NO_FLICKER="0"
    export ANTHROPIC_MODEL="gemma-4-26b-a4b"
    export CLAUDE_CODE_AUTO_COMPACT_WINDOW="48000"
    export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE="90"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="google/gemma-4-26b-a4b"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="google/gemma-4-26b-a4b"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="google/gemma-4-26b-a4b"
    export CLAUDE_CODE_SUBAGENT_MODEL="google/gemma-4-26b-a4b"
    export API_TIMEOUT_MS="30000000"
    export BASH_DEFAULT_TIMEOUT_MS="2400000"
    export BASH_MAX_TIMEOUT_MS="2500000"
    export CLAUDE_CODE_MAX_OUTPUT_TOKENS="8000"
    export CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS="8000"
    export CLAUDE_CODE_ATTRIBUTION_HEADER="0"
    export CLAUDE_CODE_DISABLE_1M_CONTEXT="1"
    export CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING="1"
    claude "$@"
}

# .env ファイルを読み込んで export する関数
load_env() {
  local env_file="${1:-.env}"
  if [ -f "$env_file" ]; then
    # コメント行と空行を除外して export
    export $(grep -v '^#' "$env_file" | xargs)
    echo "Loaded environment variables from $env_file"
  else
    echo "Error: $env_file not found."
    return 1
  fi
}

# cargo check の警告やエラーを収集し、エディターで開くリストにするやつ
cargo-check-fzf() {
    local selected target_file line_num col_num

    # 1. message-format=short で1行出力にし、警告とエラーのみを抽出してfzfに渡す
    # ($@ を渡しているので -p などのオプションもそのまま引き継げます)
    selected=$(cargo check "$@" --message-format=short 2>&1 | grep -E "warning:|error:" | fzf --ansi --no-sort --prompt="Select warning > ")

    # fzfで選択されずにキャンセル(Esc)された場合は終了
    if [ -z "$selected" ]; then
        return 0
    fi

    # 2. 選択された文字列から「ファイルパス」「行番号」「列番号」を切り出す
    # (例: crates/wwwiki-server/src/auth.rs:73:8: warning: ...)
    target_file=$(echo "$selected" | cut -d':' -f1)
    line_num=$(echo "$selected" | cut -d':' -f2)
    col_num=$(echo "$selected" | cut -d':' -f3)

    # ==========================================
    # 3. お好みのエディタで開く (いずれかを選んでください)
    # ==========================================

    # 【VS Code を使う場合】
    # code -g "${target_file}:${line_num}:${col_num}"

    # 【Vim / Neovim を使う場合】(VS Codeの行をコメントアウトしてこちらを使う)
    nvim "${target_file}" "+${line_num}"

    # 【IntelliJ / RustRover などの場合】
    # idea --line "${line_num}" "${target_file}"
}


# 自作の TODO 管理ツールのラッパー
todo-edit() {
    local id
    id=$(ztodo llm "$@" | fzf --header "Enter: 編集" | awk -F'\t' '{print $1}')
    [ -n "$id" ] && print -z "ztodo edit $id"
}
todo-done() {
    ztodo llm | fzf -m --header "Tab: 選択  Enter: 完了" | awk '{print $1}' | xargs -I{} ztodo done {}
}
todo-reopne() {
    ztodo llm --done | fzf -m --header "Tab: 選択  Enter: re-open" | awk '{print $1}' | xargs -I{} ztodo reopen {}
}
todo-clean() {
    ztodo llm --done | fzf -m --header "Tab: 選択  Enter: 削除" | awk '{print $1}' | xargs -I{} ztodo rm {}
}

