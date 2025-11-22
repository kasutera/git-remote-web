#!/usr/bin/env bash

# Test setup script for git-remote-web

setup_test_repo() {
    local test_repo_dir=$1
    
    # Create temporary git repository
    mkdir -p "$test_repo_dir"
    cd "$test_repo_dir"
    
    # Initialize git repo
    git init
    git config --global user.email "test@example.com"
    git config --global user.name "Test User"
    git config --global init.defaultBranch main
    
    # Create initial commit
    touch README.md
    echo "# Test Repository" > README.md
    git add README.md
    git commit -m "Initial commit"
}

setup_github_remote() {
    local test_repo_dir=$1
    local remote_url=$2
    
    cd "$test_repo_dir"
    git remote add origin "$remote_url"
}

setup_ssh_remote() {
    local test_repo_dir=$1
    
    cd "$test_repo_dir"
    git remote add origin "git@github.com:testuser/testrepo.git"
}

setup_http_remote() {
    local test_repo_dir=$1
    
    cd "$test_repo_dir"
    git remote add origin "https://github.com/testuser/testrepo.git"
}

setup_bitbucket_remote() {
    local test_repo_dir=$1
    
    cd "$test_repo_dir"
    git remote add origin "https://bitbucket.org/testuser/testrepo.git"
}

create_test_branch() {
    local test_repo_dir=$1
    local branch_name=$2
    
    cd "$test_repo_dir"
    git checkout -b "$branch_name"
    echo "test" > test.txt
    git add test.txt
    git commit -m "Add test.txt"
}

set_upstream_branch() {
    local test_repo_dir=$1
    local remote=$2
    local branch=$3
    
    cd "$test_repo_dir"
    git branch -u "${remote}/${branch}"
}
