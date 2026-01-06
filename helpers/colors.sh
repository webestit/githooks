#!/bin/sh
# A set of helper functions for colored output

# --- Colors ---
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BOLD="\033[1m"
RESET="\033[0m"

# --- Indentation management ---
: "${GH_INDENT_SIZE:=2}"       # Spaces per level
: "${GH_INDENT_LEVEL:=0}"      # Current indentation level
export GH_INDENT_LEVEL         # Make visible to sourced scripts

# Internal: generate indentation string
_indent_str() {
  i=0
  str=""
  while [ "$i" -lt "$GH_INDENT_LEVEL" ]; do
    str="${str}$(printf '%*s' "$GH_INDENT_SIZE" '')"
    i=$((i + 1))
  done
  printf "%s" "$str"
}

# Increment/decrement indentation
indent_inc() {
  GH_INDENT_LEVEL=$((GH_INDENT_LEVEL + 1));
  export GH_INDENT_LEVEL;
}
indent_dec() {
  [ "$GH_INDENT_LEVEL" -gt 0 ] && GH_INDENT_LEVEL=$((GH_INDENT_LEVEL - 1));
  export GH_INDENT_LEVEL;
}

# --- Generic colored output ---
# Usage: colored "COLOR" "message" [bold]
colored() {
  # Disable colors if NO_COLOR=1
  if [ "${NO_COLOR:-0}" -ne 0 ]; then
    shift # Skip color
    if [ "$1" = "bold" ]; then shift; fi
    printf "%s%s\n" "$(_indent_str)" "$*"
    return
  fi

  color="$1"
  shift
  bold=""
  if [ "$1" = "bold" ]; then
    bold="$BOLD"
    shift
  fi

  printf "%b%s%s%b\n" "$bold$color" "$(_indent_str)" "$*" "$RESET"
}

# --- Convenience helpers ---
info()        { colored "$BLUE" "$@"; }
success()     { colored "$GREEN" "$@"; }
warn()        { colored "$YELLOW" "$@"; }
error()       { colored "$RED" "$@" 1>&2; }

info_bold()   { colored "$BLUE" bold "$@"; }
success_bold(){ colored "$GREEN" bold "$@"; }
warn_bold()   { colored "$YELLOW" bold "$@"; }
error_bold()  { colored "$RED" bold "$@" 1>&2; }

# --- Example usage ---
# info "Level 0"
# indent_inc
# warn "Level 1"
# indent_inc
# error_bold "Level 2"
# indent_dec
# success "Back to Level 1"
# indent_dec
# info_bold "Back to Level 0"
