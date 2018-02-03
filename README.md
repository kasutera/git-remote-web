git-remote-web
===

An external command for Git hosting service
```
$ git web --branch
https://github.com/kasutera/git-remote-web/tree/master
$ git web README.md
https://github.com/kasutera/git-remote-web/blob/master/README.md
$ git web --commit README.md
https://github.com/kasutera/git-remote-web/blob/a3375bf2f6decc247c3e7ef7ee6338efec1b0c70/README.md
```

## Requirement
* GitHub or BitBucket
* bash
* git
* macOS (for `-o` option)

## Usage
```
git web [-b] [-c] [-o] [--remote=<remote name>] [<path/to/file>]
git web [-p] [-o]
```

## Install
```
git clone https://github.com/kasutera/git-remote-web.git
cd git-remote-web
cp git-remote-web ~/bin/
cat << EOF >> ~/.gitconfig
[alias]
  web = !git-remote-web
EOF
```
