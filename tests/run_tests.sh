#!/usr/bin/env bash
# Test runner for git-remote-web

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo "Error: bats is not installed"
    echo ""
    echo "Local installation:"
    echo "  brew install bats-core"
    echo ""
    echo "Or run tests in Docker:"
    echo "  docker-compose up"
    exit 1
fi

# Run tests
echo "Running tests..."
cd "$PROJECT_ROOT"
bats tests/*.bats

echo ""
echo "All tests passed!"
