#!/bin/sh
# Installs oh-my-zsh if it isn't there yet.
#
# .zshrc sources $ZSH/oh-my-zsh.sh, and the four plugin/theme externals in
# .chezmoiexternal.toml land *inside* ~/.oh-my-zsh — so without this, a fresh
# machine gets a broken first shell even though `chezmoi apply` reported success.
#
# run_once_before_ means: run before chezmoi writes any file, and only ever once
# per machine (chezmoi records this script's hash in its state DB).
#
# Deliberately not the upstream curl|sh installer: that one rewrites ~/.zshrc
# and launches an interactive shell, both of which fight with chezmoi.

set -eu

OMZ="${ZSH:-$HOME/.oh-my-zsh}"

if [ -d "$OMZ/.git" ]; then
    exit 0
fi

if ! command -v git >/dev/null 2>&1; then
    echo "run_once_before_install-oh-my-zsh: git not found; install it and re-run 'chezmoi apply'" >&2
    exit 1
fi

echo "Installing oh-my-zsh into $OMZ ..."

# chezmoi's externals may already have created ~/.oh-my-zsh/custom/..., and
# git refuses to clone into a non-empty directory. Clone elsewhere, then merge
# in without disturbing whatever is already under custom/.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$tmp/omz"

mkdir -p "$OMZ"
# -R copies directory contents recursively; the trailing /. includes dotfiles
# (notably .git, without which oh-my-zsh's updater can't run).
cp -R "$tmp/omz/." "$OMZ/"

echo "oh-my-zsh installed."
