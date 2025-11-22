#!/usr/bin/env bash
set -e

PROGNAME="git-remote-web"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PATH="${HOME}/.local/bin"

echo "Installing ${PROGNAME}..."

# Create ~/.local/bin if it doesn't exist
mkdir -p "${INSTALL_PATH}"

# Create symlink to the main script
ln -sf "${SCRIPT_DIR}/git-remote-web" "${INSTALL_PATH}/git-remote-web"
chmod +x "${SCRIPT_DIR}/git-remote-web"

echo "✓ Symlinked to ${INSTALL_PATH}/git-remote-web"
echo "  (pointing to ${SCRIPT_DIR}/git-remote-web)"

# Check if ~/.local/bin is in PATH
if [[ ":${PATH}:" != *":${INSTALL_PATH}:"* ]]; then
    echo ""
    echo "⚠ Warning: ${INSTALL_PATH} is not in your PATH"
    echo "Add this line to your shell config (~/.bashrc, ~/.zshrc, etc.):"
    echo "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
    echo ""
fi

# Set up git alias
read -p "Do you want to set up git alias 'git web'? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git config --global alias.web "!${SCRIPT_DIR}/git-remote-web"
    echo "✓ Git alias 'web' configured"
    echo "  You can now use: git web"
fi

echo ""
echo "Installation complete!"
