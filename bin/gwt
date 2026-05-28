#!/usr/bin/env zsh

# gwt — git worktree wrapper
# Creates worktrees at <parentdir>/<reponame>_<branchname>
# where '/' in branch names is replaced with '-'

set -euo pipefail

# === helpers ===

_sanitize_branch() {
    # refs/heads/ プレフィックスを除去、/ を - に置換
    local b="${1#refs/heads/}"
    echo "${b//\//-}"
}

_derive_worktree_path() {
    local branch="$1"
    local repo_root
    repo_root=$(git rev-parse --show-toplevel)
    local parent_dir
    parent_dir=$(dirname "$repo_root")
    local reponame
    reponame=$(basename "$repo_root")
    local sanitized
    sanitized=$(_sanitize_branch "$branch")
    echo "${parent_dir}/${reponame}_${sanitized}"
}

_ensure_git_repo() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "gwt: not inside a git repository" >&2
        exit 1
    fi
}

# === subcommands ===

cmd_add() {
    local create_branch=false
    local branch=""
    local start_point=""

    # parse flags first
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b) create_branch=true; shift ;;
            --) shift; break ;;
            *)  break ;;
        esac
    done

    # remaining args: <branch> [<start-point>]
    if [[ $# -eq 0 ]]; then
        echo "gwt add: missing branch name" >&2
        echo "usage: gwt add [-b] <branch> [<start-point>]" >&2
        exit 1
    fi
    branch="$1"; shift
    if [[ $# -gt 0 ]]; then
        start_point="$1"; shift
    fi

    if [[ -z "$branch" ]]; then
        echo "gwt add: missing branch name" >&2
        echo "usage: gwt add [-b] <branch>" >&2
        exit 1
    fi

    _ensure_git_repo

    local worktree_path
    worktree_path=$(_derive_worktree_path "$branch")

    # check if path already exists
    if [[ -d "$worktree_path" ]]; then
        echo "gwt: worktree path already exists: $worktree_path" >&2
        echo "gwt: use 'gwt remove $branch' to remove it first" >&2
        exit 1
    fi

    if [[ "$create_branch" == true ]]; then
        if [[ -n "$start_point" ]]; then
            git worktree add -b "$branch" "$worktree_path" "$start_point"
        else
            git worktree add -b "$branch" "$worktree_path"
        fi
    else
        # verify branch exists
        if ! git rev-parse --verify --quiet "refs/heads/$branch" > /dev/null 2>&1; then
            echo "gwt: branch '$branch' does not exist" >&2
            echo "gwt: use 'gwt add -b $branch' to create and add" >&2
            exit 1
        fi
        git worktree add "$worktree_path" "$branch"
    fi

    echo "gwt: worktree created at $worktree_path"
}

cmd_remove() {
    local branch="$1"
    if [[ -z "$branch" ]]; then
        echo "gwt remove: missing branch name" >&2
        echo "usage: gwt remove <branch>" >&2
        exit 1
    fi

    _ensure_git_repo

    local worktree_path
    worktree_path=$(_derive_worktree_path "$branch")

    if [[ ! -d "$worktree_path" ]]; then
        echo "gwt: no worktree found for branch '$branch'" >&2
        echo "gwt: expected path: $worktree_path" >&2
        exit 1
    fi

    git worktree remove "$worktree_path"
    echo "gwt: worktree removed: $worktree_path"
}

usage() {
    cat <<'EOF'
gwt — git worktree wrapper

USAGE:
    gwt add <branch>                 Create worktree for existing branch
    gwt add -b <branch> [<start-point>]  Create new branch from <start-point>
    gwt remove <branch>              Remove worktree for branch
    gwt                              Show this help

Worktree directory naming:
    <parentdir>/<reponame>_<branchname>
    '/' in branch names is replaced with '-'
EOF
}

# === main ===

case "${1:-}" in
    add)    shift; cmd_add "$@" ;;
    remove) shift; cmd_remove "$@" ;;
    --help|-h)  usage ;;
    *)      usage ;;
esac
