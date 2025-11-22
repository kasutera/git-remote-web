# git-remote-web

An external command for Git hosting service

```console
$ git web --branch
https://github.com/kasutera/git-remote-web/tree/master
$ git web README.md
https://github.com/kasutera/git-remote-web/blob/master/README.md
$ git web --commit README.md
https://github.com/kasutera/git-remote-web/blob/a3375bf2f6decc247c3e7ef7ee6338efec1b0c70/README.md
```

## Requirements

* GitHub
* bash
* git
* macOS (for `-o` option)

## Usage

```bash
$ git web -h 
  Usage:  [OPTIONS...] path

  OPTIONS:
    -h, --help
    --remote=REMOTE             specify remote name (default: origin)
    -b, --branch                branch URL
    -c, --commit                commit URL of current HEAD
    -p, --pull-request          pull request URL into master
    -o, --open                  open URL with browser
```

## Install

### Quick Install (Recommended)

```bash
git clone https://github.com/kasutera/git-remote-web.git
cd git-remote-web
./install.sh
```

The installer will:

* Create a symlink to the script in `~/.local/bin/git-remote-web`
* Configure the `git web` alias automatically
* Verify your PATH configuration

Updates are automatic since the symlink points to the cloned repository.

### Manual Install

```bash
git clone https://github.com/kasutera/git-remote-web.git
cd git-remote-web

# Create symlink
ln -s "${PWD}/git-remote-web" ~/.local/bin/

# Add git alias
git config --global alias.web "!${PWD}/git-remote-web"
```

Make sure `~/.local/bin` (or `~/bin`) is in your `$PATH`:

```bash
export PATH="${HOME}/.local/bin:${PATH}"  # Add to ~/.bashrc or ~/.zshrc
```
