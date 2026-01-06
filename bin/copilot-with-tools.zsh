#!/usr/bin/env zsh

# Copilot CLI wrapper with configurable allowed tools
# Usage: copilot-with-tools.zsh [--dry-run] [model] [preset] [--deny-tool <tool>...] [additional args...]
# model: haiku, sonnet, or empty for default
# preset: investigation, development, or empty for default
# Examples:
#   copilot-with-tools.zsh haiku investigation
#   copilot-with-tools.zsh --dry-run haiku development
#   copilot-with-tools.zsh sonnet development --deny-tool shell(git:push)
#   copilot-with-tools.zsh haiku --deny-tool write --deny-tool shell(bash)

set -e

# Check for --dry-run flag
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  shift
fi

# Config file location
CONFIG_FILE="$HOME/.config/copilot-tools/copilot-tools-config.json"

# Validate config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Config file not found at $CONFIG_FILE" >&2
  exit 1
fi

# Parse JSON config using jq
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required to parse JSON config" >&2
  exit 1
fi

# Get default preset
DEFAULT_PRESET=$(jq -r '.default' "$CONFIG_FILE")

# Parse MODEL and PRESET
MODEL="${1:-}"
PRESET=""

# Check if second argument is a valid preset
if [[ $# -ge 2 ]]; then
  if jq -e ".settings[\"$2\"]" "$CONFIG_FILE" > /dev/null 2>&1; then
    PRESET="$2"
    shift 2
  else
    shift
  fi
elif [[ $# -eq 1 ]]; then
  shift
fi

# Use default preset if not specified
PRESET="${PRESET:-$DEFAULT_PRESET}"

# Extract tools from preset
TOOLS_JSON=$(jq -r ".settings[\"$PRESET\"].allowTools[]" "$CONFIG_FILE")

# Extract deny-tools from preset (if present)
DENY_TOOLS_FROM_CONFIG=$(jq -r ".settings[\"$PRESET\"].denyTools[]?" "$CONFIG_FILE" 2>/dev/null || true)

# Build arguments array (using proper array syntax)
declare -a ARGS

# Add model if specified
if [[ -n "$MODEL" ]]; then
  case "$MODEL" in
    haiku)
      ARGS+=(--model "claude-haiku-4.5")
      ;;
    sonnet)
      ARGS+=(--model "claude-sonnet-4.5")
      ;;
    *)
      # Treat as full model name
      ARGS+=(--model "$MODEL")
      ;;
  esac
fi

# Add allowed tools
while IFS= read -r tool; do
  if [[ -n "$tool" ]]; then
    ARGS+=(--allow-tool "$tool")
  fi
done <<< "$TOOLS_JSON"

# Parse command-line deny-tool arguments and other remaining arguments
declare -a CLI_DENY_TOOLS
declare -a OTHER_ARGS

while [[ $# -gt 0 ]]; do
  case "$1" in
    --deny-tool)
      shift
      if [[ -z "$1" ]]; then
        echo "Error: --deny-tool requires an argument" >&2
        exit 1
      fi
      CLI_DENY_TOOLS+=("$1")
      shift
      ;;
    *)
      OTHER_ARGS+=("$1")
      shift
      ;;
  esac
done

# Add deny-tools from config first
while IFS= read -r tool; do
  if [[ -n "$tool" ]]; then
    ARGS+=(--deny-tool "$tool")
  fi
done <<< "$DENY_TOOLS_FROM_CONFIG"

# Add deny-tools from command-line (overrides/extends config)
for tool in "${CLI_DENY_TOOLS[@]}"; do
  ARGS+=(--deny-tool "$tool")
done

# Add other arguments
ARGS+=("${OTHER_ARGS[@]}")

# If dry-run, print the command instead of executing it
if [[ "$DRY_RUN" == true ]]; then
  echo "[DRY-RUN] Command would execute:"
  echo "copilot ${ARGS[@]}"
  exit 0
fi

# Execute copilot with constructed arguments
copilot "${ARGS[@]}"
