#!/bin/sh
# Pre-push hook to ensure the full test suite passes

# Load color helpers
. "$(git rev-parse --show-toplevel 2>/dev/null)/vendor/webestit/githooks/helpers/colors.sh"

info "🧪 Running PHPUnit tests..."

# Run tests
if ! php artisan test; then
    error "❌ Tests failed! Push aborted."
    exit 1
fi

success "✅ All tests passed."
exit 0
