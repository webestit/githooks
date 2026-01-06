#!/bin/sh
# Commit-msg hook to enforce Conventional Commits

# Load color helpers
. "$(git rev-parse --show-toplevel 2>/dev/null)/vendor/webestit/githooks/helpers/colors.sh"

# Print commit instructions
print_commit_guidelines() {
    warn_bold "Commit message syntax"
    indent_inc
      warn "<type>(<optional scope>): <description>"
      warn "[optional body]"
      warn "[optional footer(s)]"
    indent_dec

    echo

    info_bold "Valid types"
    indent_inc
      info "feat:     A new feature"
      info "fix:      A bug fix"
      info "docs:     Documentation changes"
      info "style:    Code style changes (formatting, missing semicolons, etc.)"
      info "refactor: Code refactoring (neither fixes a bug nor adds a feature)"
      info "test:     Adding or updating tests"
      info "chore:    Routine tasks like updating dependencies or build tools"
      info "build:    Changes affecting the build system or external dependencies"
      info "ci:       Changes to CI configuration files or scripts"
      info "perf:     Performance improvements"
      info "revert:   Reverting a previous commit"
    indent_dec

    echo

    info_bold "Examples"
    indent_inc
      info "feat(auth): add login functionality"
      info "fix(api)!: resolve timeout issue"
      info "docs(readme): update installation instructions"
    indent_dec

    echo
}

COMMIT_MSG_FILE="$1"

# Skip automatic merge commits
if grep --quiet --extended-regexp "^Merge " "$COMMIT_MSG_FILE"; then
    exit 0
fi

# Read commit message
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Conventional commits regex
CONVENTIONAL_COMMIT_REGEX='^(feat|fix|docs|style|refactor|test|chore|build|ci|perf|revert)(\([a-zA-Z0-9_.-]+\))?(!)?:\s.*$'

# Validate commit message
if ! printf '%s' "$COMMIT_MSG" | grep -qE "$CONVENTIONAL_COMMIT_REGEX"; then
    error "❌ Commit message does not follow Conventional Commits format."
    echo
    print_commit_guidelines
    exit 1
fi

success "✅ Conventional commit message accepted."
exit 0
