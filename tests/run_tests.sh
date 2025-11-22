#!/bin/bash

# Test runner script for bats tests

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running git-remote-web tests...${NC}"
echo ""

# Run bats tests
if bats /app/tests/test_git_remote_web.bats; then
    echo ""
    echo -e "${GREEN}✓ All tests passed${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}✗ Tests failed${NC}"
    exit 1
fi
