#!/bin/sh
# Pre-commit hook to enforce branch naming convention

# Load color helpers
. "$(git rev-parse --show-toplevel 2>/dev/null)/vendor/webestit/githooks/helpers/colors.sh"

# Print branch naming guidelines
print_branch_guidelines() {
    warn_bold "Branch names syntax"
    indent_inc
      warn "<type>/<short-description>"
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
    indent_dec

    echo

    info_bold "Examples"
    indent_inc
      info "feat/add-login-endpoint"
      info "fix/timeout-issue"
      info "docs/update-readme"
    indent_dec

    echo
}

# Get current branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# Branch name regex (Conventional Commit types)
BRANCH_REGEX='^(feat|fix|docs|style|refactor|test|chore|build|ci|perf)/[a-z0-9._-]+$'

# Validate branch name
if ! printf '%s' "$BRANCH_NAME" | grep -qE "$BRANCH_REGEX"; then
    error "❌ Branch name does not follow the expected naming convention."
    echo
    print_branch_guidelines
    exit 1
fi

success "✅ Branch name '$BRANCH_NAME' follows the expected convention."
exit 0
