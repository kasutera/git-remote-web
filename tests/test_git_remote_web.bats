#!/usr/bin/env bats

# Test helper functions and setup
setup() {
    # Create a temporary directory for each test
    TEST_REPO=$(mktemp -d)
    export TEST_REPO
    BRANCH_NAME="test-branch"
    export BRANCH_NAME
    
    # Create a test git repository
    cd "$TEST_REPO" || exit 1
    git init -q
    git checkout -q -b "$BRANCH_NAME"

    # Add the git-remote-web script to PATH
    export PATH="/app:$PATH"
    
    # Create a test file
    echo "test content" > README.md
    git add README.md
    git commit -q -m "Initial commit"
}

teardown() {
    # Clean up test repository
    if [ -d "$TEST_REPO" ]; then
        rm -rf "$TEST_REPO"
    fi
}

# Test: Show repository root URL
@test "Show repository root URL" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web)
    [[ "$result" == "https://github.com/kasutera/git-remote-web" ]]
}

# Test: Show branch URL with -b option
@test "Show branch URL with -b option" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web -b)
    [[ "$result" == "https://github.com/kasutera/git-remote-web/tree/${BRANCH_NAME}" ]]
}

# Test: Show file URL without options
@test "Show file URL for README.md" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web README.md)
    [[ "$result" == "https://github.com/kasutera/git-remote-web/blob/${BRANCH_NAME}/README.md" ]]
}

# Test: Show commit URL with -c option
@test "Show commit URL with -c option" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web -c README.md)
    [[ "$result" =~ ^https://github.com/kasutera/git-remote-web/blob/[a-f0-9]{40}/README.md$ ]]
}

# Test: Show commit URL without file
@test "Show commit URL without file" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web -c)
    [[ "$result" =~ ^https://github.com/kasutera/git-remote-web/commit/[a-f0-9]{40}$ ]]
}

# Test: Show pull requests URL with -p option
@test "Show pull requests URL with -p option" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web -p)
    echo "result: $result"
    [[ "$result" == "https://github.com/kasutera/git-remote-web/pull/new/${BRANCH_NAME}" ]]
}

# Test: SSH URL conversion for GitHub
@test "Convert SSH URL to HTTPS for GitHub" {
    cd "$TEST_REPO" || exit 1
    git remote add origin git@github.com:kasutera/git-remote-web.git
    
    result=$(git-remote-web)
    [[ "$result" == "https://github.com/kasutera/git-remote-web" ]]
}

# Test: Custom remote name
@test "Use custom remote name" {
    cd "$TEST_REPO" || exit 1
    git remote add upstream https://github.com/original/repo.git
    
    result=$(git-remote-web --remote=upstream -b)
    [[ "$result" =~ ^https://github.com/original/repo/tree/[a-zA-Z0-9_-]+$ ]]
}

# Test: Error on non-existent remote
@test "Error on non-existent remote" {
    cd "$TEST_REPO" || exit 1
    
    run git-remote-web --remote=nonexistent
    [ "$status" -ne 0 ]
    [[ "$output" =~ "not found" ]]
}

# Test: Error when not in git repository
@test "Error when not in git repository" {
    cd /tmp || exit 1
    
    run git-remote-web
    [ "$status" -ne 0 ]
}

# Test: File path with subdirectories
@test "File path with subdirectories" {
    cd "$TEST_REPO" || exit 1
    mkdir -p src/utils
    echo "utility code" > src/utils/helper.js
    git add src/utils/helper.js
    git commit -q -m "Add helper"
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    result=$(git-remote-web src/utils/helper.js)
    [[ "$result" =~ ^https://github.com/kasutera/git-remote-web/blob/[a-zA-Z0-9_-]+/src/utils/helper.js$ ]]
}

# Test: Multiple branches
@test "Show correct URL for different branches" {
    cd "$TEST_REPO" || exit 1
    git remote add origin https://github.com/kasutera/git-remote-web.git
    
    # Create and checkout a new branch
    git checkout -q -b develop
    
    result=$(git-remote-web -b)
    [[ "$result" =~ develop$ ]]
}
