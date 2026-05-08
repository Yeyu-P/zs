# zs

`zs` is a small `fzf` UI for managing Zellij sessions from Ghostty.

It opens a dedicated `_zs` manager session, lists active and killed sessions,
and lets you attach, resurrect, kill, delete, force-delete, and rename sessions
with single-key actions.

## Features

- `a`: attach to a running session or resurrect an exited one
- `k`: kill a session and keep it visible in `zs` as `(exited)`
- `d`: delete a session and remove it from the list
- `f`: force-delete a session, including stale Zellij server/cache state
- `r`: rename a session
- `/`: search mode
- `_zs` is hidden from the session list
- optional Ghostty auto-Zellij shell integration

## Requirements

- `bash`
- `zsh` for the optional shell integration
- `zellij`
- `ghostty`
- `fzf`
- `python3`
- standard tools: `timeout`, `setsid`, `realpath`, `awk`, `sed`, `grep`

## Install

```bash
git clone https://github.com/YOUR_USER/zs.git
cd zs
./install.sh --with-zshrc
```

Use `--with-zshrc` if you want new Ghostty windows to automatically attach to
or create a Zellij session. Omit it to install only the `zs` command:

```bash
./install.sh
```

Restart your shell after installing, or run:

```bash
source ~/.zshrc
```

## Usage

Inside any Zellij session:

```bash
zs
```

Keys:

```text
a  attach/resurrect selected session
k  kill selected session; keep it as exited
d  delete selected session
f  force-delete selected session and stale state
r  rename selected session
/  search
```

## Uninstall

```bash
./install.sh --uninstall
```

This removes `~/.local/bin/zs` and the managed zshrc block if it was installed.

## Prior Art

Zellij ships a built-in session manager, and there are other fzf-based Zellij
session helpers such as `ze-cli`, `zesh`, and shell snippets. This project is
focused on your Ghostty + Zellij workflow with a dedicated `_zs` manager window
and explicit kill/delete semantics.
