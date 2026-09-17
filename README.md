# dotfiles

My zsh and Ghostty setup for **macOS on Apple Silicon**, managed with
[chezmoi](https://www.chezmoi.io/). Share this repo:
**https://github.com/davidcoita/dotfiles**.

## The terminal

- Ghostty with Tokyo Night light/dark themes and JetBrains Mono Nerd Font Mono.
- Powerlevel10k with Agnoster-style connected blocks: blue path, green clean Git
  branch, amber changed files, coral merge conflicts. Commands go on a second line.
- Branch names, staged/unstaged/untracked counts, ahead/behind arrows, and stashes.
- Autosuggestions, syntax highlighting, fzf tab completion, and fuzzy history.
- `eza`, `bat`, `fd`, `zoxide`, and `fnm` for navigation, files, and Node versions.

Git counters: `+N` staged, `!N` unstaged, `?N` untracked, `~N` conflicted,
`⇡N` ahead, `⇣N` behind, `*N` stashes. The command arrow turns coral on failure.

## Install the shared setup

Requires [Homebrew](https://brew.sh). These paths currently assume the Apple
Silicon prefix `/opt/homebrew`; Intel macOS and Linux need path adjustments.

Run this on the machine receiving the setup. `chezmoi diff` lets you review
changes to existing shell, Git, and Ghostty settings before applying them.

```sh
brew install chezmoi
chezmoi init https://github.com/davidcoita/dotfiles.git
brew bundle --file="$(chezmoi source-path)/Brewfile.terminal"
chezmoi diff
chezmoi apply
bat cache --build
exec zsh -l
```

Open Ghostty after installation. chezmoi installs Oh My Zsh, Powerlevel10k,
fzf-tab, autosuggestions, syntax highlighting, and the bat/delta colour theme.
No private repo or 1Password account is needed for this shared setup.

Initialization asks for **your own** Git name/email, code directory (default
`~/Code`), and personal/work workspace names. Leave a workspace blank to skip it.
Answers stay on your machine in `~/.config/chezmoi/chezmoi.toml`.

The full `Brewfile` is an optional inventory of my development machine, including
additional languages, databases, services, and GUI apps. `Brewfile.terminal`
contains the smaller set needed for the shared terminal.

For Node development, install the version your project needs with `fnm install`
in a repo with `.nvmrc`, or choose an initial default with `fnm install --lts`.
Docker, PHP, Kubernetes, and other development tools are optional; their helpers
become useful when those tools are installed.

## Just the Ghostty appearance

Install Ghostty and `font-jetbrains-mono-nerd-font`, then copy
[`dot_config/ghostty/config.ghostty`](dot_config/ghostty/config.ghostty) to
`~/.config/ghostty/config.ghostty`. Merge with existing settings if needed.
This changes the terminal appearance and shortcuts; the path/branch prompt is
configured separately in [`dot_p10k.zsh`](dot_p10k.zsh).

Useful Ghostty shortcuts: `Cmd+D` split right, `Cmd+Shift+D` split down,
`Cmd+Option+Arrow` move between splits, `Cmd+Shift+Enter` zoom a split,
and `Cmd+Shift+,` reload configuration.

## Personal settings

Keep machine-specific additions in:

- `~/.config/zsh/99-local.zsh` for local shell overrides.
- `~/.config/ghostty/local.ghostty` for local terminal settings.
- `<code directory>/<workspace>/.gitconfig.local` for a workspace Git identity.

For example, `~/Code/personal/.gitconfig.local` can contain:

```ini
[user]
    email = me@example.com
    name = Your Name
```

The optional private work overlay lives in `~/.config/zsh-private/` and is
loaded only when present. It is separate from this repository. Credentials,
private keys, shell history, and local overrides do not belong in the public repo.

## Edit and update

```sh
chezmoi edit --apply ~/.p10k.zsh   # edit the shared prompt
source ~/.p10k.zsh                # refresh the current terminal
chezmoi edit --apply ~/.zshrc     # edit shell startup
chezmoi diff                      # review pending differences
chezmoi cd                        # enter the source repo to commit/push
chezmoi update                    # pull and apply shared updates
bat cache --build                 # rebuild after colour theme changes
```

Fork the repository and use your fork's URL at `chezmoi init` if you want to
maintain your own version. chezmoi does not automatically publish local edits.
