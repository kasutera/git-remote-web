#!/usr/bin/env bats

setup() {
    # Create a temporary directory for test repos
    export TEST_TMPDIR="${BATS_TMPDIR}/git-remote-web-test-$$"
    mkdir -p "$TEST_TMPDIR"
    SCRIPT_PATH="$(dirname "${BATS_TEST_DIRNAME}")/git-remote-web"
    export SCRIPT_PATH
    TEST_REPO="$TEST_TMPDIR/test-repo"
    mkdir -p "$TEST_REPO"
    cd "$TEST_REPO" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git config init.defaultBranch main
}

teardown() {
    # Clean up test repos
    if [[ -d "$TEST_TMPDIR" ]]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

@test "judge_ssh_http detects HTTP URL" {
    git remote add origin "https://github.com/testuser/testrepo.git"
    
    bash -c "
        cd '$test_repo' || exit 1
        source '$SCRIPT_PATH' || exit 1
        result=\$(judge_ssh_http origin)
        [[ \"\$result\" == \"http\" ]]
    "
}

@test "judge_ssh_http detects SSH URL" {
    git remote add origin "git@github.com:testuser/testrepo.git"
    
    bash -c "
        cd '$test_repo' || exit 1
        source '$SCRIPT_PATH' || exit 1
        result=\$(judge_ssh_http origin)
        [[ \"\$result\" == \"ssh\" ]]
    "
}

@test "get_remote_ssh converts SSH to HTTPS" {
    git remote add origin "git@github.com:testuser/testrepo.git"
    
    bash -c "
        cd '$test_repo' || exit 1
        source '$SCRIPT_PATH' || exit 1
        result=\$(get_remote_ssh origin)
        [[ \"\$result\" == \"https://github.com/testuser/testrepo\" ]]
    "
}

@test "get_remote_http returns HTTP URL" {
    git remote add origin "https://github.com/testuser/testrepo.git"
    
    bash -c "
        cd '$test_repo' || exit 1
        source '$SCRIPT_PATH' || exit 1
        result=\$(get_remote_http origin)
        [[ \"\$result\" == \"https://github.com/testuser/testrepo\" ]]
    "
}

@test "get_remote_host extracts github from URL" {
    bash -c "
        source '$SCRIPT_PATH' || exit 1
        result=\$(get_remote_host \"https://github.com/testuser/testrepo\")
        [[ \"\$result\" == \"github\" ]]
    "
}

@test "get_remote_host extracts bitbucket from URL" {
    bash -c "
        source '$SCRIPT_PATH' || exit 1
        result=\$(get_remote_host \"https://bitbucket.org/testuser/testrepo\")
        [[ \"\$result\" == \"bitbucket\" ]]
    "
}

@test "fails when not in a git repository" {
    local test_dir="$TEST_TMPDIR/not-a-repo"
    mkdir -p "$test_dir"
    
    run bash -c "cd '$test_dir' && bash '$SCRIPT_PATH'"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"not a git repository"* ]]
}

@test "prints usage with --help option" {
    local test_repo="$TEST_TMPDIR/test-help"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://github.com/testuser/testrepo.git"
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' --help"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"Usage:"* ]]
}

@test "generates GitHub branch URL" {
    local test_repo="$TEST_TMPDIR/test-github-branch"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://github.com/testuser/testrepo.git"
    git checkout -b feature || return 1
    touch test.txt
    git add test.txt
    git commit -m "test" || return 1
    git branch -u origin/feature || return 1
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' -b"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"github.com"* ]]
    [[ "$output" == *"tree"* ]]
}

@test "generates GitHub commit URL" {
    local test_repo="$TEST_TMPDIR/test-github-commit"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://github.com/testuser/testrepo.git"
    touch README.md
    git add README.md
    git commit -m "Initial commit" || return 1
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' -c"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"github.com"* ]]
    [[ "$output" == *"commit"* ]]
}

@test "generates BitBucket branch URL" {
    local test_repo="$TEST_TMPDIR/test-bitbucket-branch"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://bitbucket.org/testuser/testrepo.git"
    git checkout -b feature || return 1
    touch test.txt
    git add test.txt
    git commit -m "test" || return 1
    git branch -u origin/feature || return 1
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' -b"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"bitbucket.org"* ]]
}

@test "generates file URL for GitHub" {
    local test_repo="$TEST_TMPDIR/test-github-file"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://github.com/testuser/testrepo.git"
    git checkout -b main || return 1
    echo "test content" > testfile.txt
    git add testfile.txt
    git commit -m "Add testfile" || return 1
    git branch -u origin/main || return 1
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' testfile.txt"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"github.com"* ]]
    [[ "$output" == *"blob"* ]]
    [[ "$output" == *"testfile.txt"* ]]
}

@test "fails when no upstream branch is set" {
    local test_repo="$TEST_TMPDIR/test-no-upstream"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://github.com/testuser/testrepo.git"
    git checkout -b detached || return 1
    touch test.txt
    git add test.txt
    git commit -m "test" || return 1
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' -b"
    [[ "$status" -eq 1 ]]
    [[ "$output" == *"no upstream"* ]]
}

@test "respects custom remote option" {
    local test_repo="$TEST_TMPDIR/test-custom-remote"
    mkdir -p "$test_repo"
    cd "$test_repo" || return 1
    git init || return 1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git remote add origin "https://github.com/testuser/testrepo.git"
    git remote add upstream "https://github.com/original/testrepo.git"
    git checkout -b feature || return 1
    touch test.txt
    git add test.txt
    git commit -m "test" || return 1
    git branch -u upstream/feature || return 1
    
    run bash -c "cd '$test_repo' && bash '$SCRIPT_PATH' --remote=upstream -b"
    [[ "$status" -eq 0 ]]
    [[ "$output" == *"original/testrepo"* ]]
}
