#!/bin/sh
# A set of helper functions

# Sources
. "$(cd "$(dirname "$0")/.." && pwd)/helpers/colors.sh"

# Helper functions
root_dir() {
  (cd "$(dirname "$0")/.." && pwd)
}

hooks_dir() {
  printf '%s\n' "$(root_dir)/hooks"
}

project_root_dir() {
  printf '%s\n' "$(git rev-parse --show-toplevel 2>/dev/null)"
}

# shellcheck disable=SC2120
project_hooks_dir() {
  printf '%s\n' "$(project_root_dir)/.githooks${1:+/$1}"
}

project_git_dir() {
  validate_project_root_dir_exists
  printf '%s\n' "$(project_root_dir)/.git"
}

validate_project_root_dir_exists() {
  if [ -z "$(project_root_dir)" ]; then
    error "❌ Could not find project root."
    exit 1
  fi
}

validate_project_git_dir_exists() {
  if [ ! -d "$(project_git_dir)" ]; then
      warn "⚠️ Git not found in $(project_root_dir). Skipping hook installation."
      exit 0
  fi
}

skip_if_no_hooks() {
  HOOK_NAME="$1"

  if [ ! -d "$(project_hooks_dir "$HOOK_NAME")" ]; then
    # Silence if directory doesn't exist, as it's optional
    exit 0
  fi
}

run_hook_scripts() {
  HOOK_NAME="$1"
  shift

  if [ -d "$(project_hooks_dir "$HOOK_NAME")" ]; then
    for script in "$(project_hooks_dir "$HOOK_NAME")"/*; do
      # Skip if it's not a file (e.g. empty directory match in some shells)
      [ -f "$script" ] || continue

      # Get script name without extension
      SCRIPT_NAME=$(basename "$script")
      SCRIPT_NAME="${SCRIPT_NAME%.*}" # remove extension

      [ -x "$script" ] || {
        error "✋ Permission denied the script $SCRIPT_NAME. Make it executable."
        exit 1
      }

      info "🔹 Executing $SCRIPT_NAME..."
      indent_inc
      "$script" "$@" || {
        indent_dec
        error "❌ Hook $SCRIPT_NAME failed. Aborting $HOOK_NAME."
        exit 1
      }
      indent_dec
    done
  fi
}

configure_git_hooksPath() {
  validate_project_git_dir_exists

  info "🪝 Configuring Git hooks path to: $(hooks_dir)"
  git -C "$(project_root_dir)" config --local core.hooksPath "$(hooks_dir)" || return 1
}