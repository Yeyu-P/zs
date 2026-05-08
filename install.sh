#!/usr/bin/env bash
set -euo pipefail

prefix="${PREFIX:-$HOME/.local}"
install_zshrc=0
uninstall=0

usage() {
    cat <<'EOF'
Usage: ./install.sh [--with-zshrc] [--uninstall]

Installs zs to ~/.local/bin/zs by default.

Options:
  --with-zshrc   Add the optional Ghostty auto-Zellij block to ~/.zshrc
  --uninstall    Remove zs and the managed ~/.zshrc block
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --with-zshrc) install_zshrc=1 ;;
        --uninstall) uninstall=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="$prefix/bin"
target="$bin_dir/zs"
zshrc="$HOME/.zshrc"
begin="# >>> zs ghostty auto-zellij >>>"
end="# <<< zs ghostty auto-zellij <<<"

remove_zshrc_block() {
    [[ -f "$zshrc" ]] || return 0
    awk -v begin="$begin" -v end="$end" '
        $0 == begin { skip = 1; next }
        $0 == end { skip = 0; next }
        !skip { print }
    ' "$zshrc" > "$zshrc.tmp"
    mv "$zshrc.tmp" "$zshrc"
}

if [[ "$uninstall" == 1 ]]; then
    rm -f -- "$target"
    remove_zshrc_block
    echo "uninstalled zs"
    exit 0
fi

for dep in zellij ghostty fzf python3 timeout setsid realpath; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        echo "missing dependency: $dep" >&2
        exit 1
    fi
done

mkdir -p "$bin_dir"
install -m 0755 "$repo_dir/bin/zs" "$target"

if [[ "$install_zshrc" == 1 ]]; then
    touch "$zshrc"
    remove_zshrc_block
    {
        printf '\n%s\n' "$begin"
        sed -n '1,$p' "$repo_dir/shell/zshrc.zsh"
        printf '%s\n' "$end"
    } >> "$zshrc"
fi

echo "installed $target"
if [[ "$install_zshrc" == 1 ]]; then
    echo "updated $zshrc"
fi
