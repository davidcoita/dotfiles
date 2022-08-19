# dotfiles

zsh and Ghostty on macOS, managed with [chezmoi](https://chezmoi.io).

## Install

Needs [Homebrew](https://brew.sh) first, which also pulls in git:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>
brew bundle --file="$(chezmoi source-path)/Brewfile"
exec zsh
```

Prompts for git email, git name, where your repos live (`~/Code`), and the
personal and work workspace names. Stored in `~/.config/chezmoi/chezmoi.toml`.

## Git identity

One `.gitconfig.local` per workspace, not committed:

```sh
$EDITOR ~/Code/personal/.gitconfig.local
```

```ini
[user]
	email = me@example.com
	name  = Your Name
[core]
	sshCommand = "ssh -i ~/.ssh/id_personal"
```

## Commands

```sh
chezmoi edit --apply ~/.zshrc   # edit source, apply
chezmoi diff                    # what would change
chezmoi cd                      # shell into the source dir
chezmoi update                  # pull, then apply
```
