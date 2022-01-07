# dotfiles

zsh and Ghostty on macOS, managed with [chezmoi](https://chezmoi.io).

## Install

Requires macOS and [Homebrew](https://brew.sh).

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>
brew bundle --file="$(chezmoi source-path)/Brewfile"
exec zsh
```

Five prompts, stored in `~/.config/chezmoi/chezmoi.toml` (machine-local, not in
this repo). Delete a key and re-run `chezmoi init` to change it.

| Prompt | Default | Controls |
|---|---|---|
| Primary git email | none | `[user]` in `~/.gitconfig` |
| Git author name | none | same |
| Where your repos live | `~/Code` | `$CODE`: `cdpath`, named dirs, `p` |
| Personal workspace | `personal` | per-directory git identity |
| Work workspace | `work` | per-directory git identity |

A blank workspace skips its `includeIf` block. Otherwise every directory under
`$CODE` becomes a workspace on its own.

## What you get

Every git repo under `$CODE` gets a named directory, generated at shell start.
Nested repos get hyphenated.

```sh
cd ~myproject           # from anywhere
vim ~myproject/src/x.c  # works as a path, tab-completes
```

- `p` fuzzy repo picker, `z` frecency jumps, `cd <workspace>` from anywhere
- `↑`/`↓` prefix history search, `Ctrl-R` history, `Ctrl-T` files, `Alt-C` dirs
- `Ctrl-X Ctrl-E` edit command line in `$EDITOR`, `Esc Esc` prepend sudo
- `Tab` completions with previews, via fzf-tab
- `mkcd`, `extract`, `killport`, `art`, `sail`, `pm`, `nr`, `kx`, `kns`, `ksh`

## Layout

```
dot_zshenv.tmpl         env vars, incl. $CODE. No PATH, see below.
dot_zprofile            PATH, deduplicated array
private_dot_zshrc       ~50 lines, load order matters
dot_p10k.zsh            prompt
dot_config/zsh/00-89    options, history, completion, keys, dirs, aliases,
                        functions, tools. Sourced in numeric order.
dot_config/ghostty/     terminal
.chezmoiexternal.toml   zsh plugins, cloned at apply time
run_once_before_*.sh    installs oh-my-zsh
```

`90-99` belongs to an optional private repo, cloned to `~/.config/zsh-private`,
for internal hostnames and secret references. Skip it and nothing breaks.

`99-local.zsh` is machine-local and never committed. Installers that want to
append to `~/.zshrc` go here, since chezmoi rewrites `~/.zshrc` on every apply.

## Things that will bite you

PATH lives in `.zprofile`, not `.zshenv`. macOS `/etc/zprofile` runs
`path_helper` afterwards and shoves `/opt/homebrew/bin` to the back.

`typeset -U path PATH`, not just `path`. Tools that assign straight to `$PATH`
(gcloud does) sail past a constraint declared only on the array. `.zshrc`
repeats it because `.zprofile` only runs for login shells.

Load order in `.zshrc`: instant prompt first, nothing above it may print.
oh-my-zsh next, since it overwrites anything before it. Then the overrides.
Then `fzf`, `zsh-syntax-highlighting`, `zsh-autosuggestions`, at the bottom,
because z-sy-h wraps every widget that exists when it loads.

zstyle resolves by specificity, not order. oh-my-zsh sets
`':completion:*:*:*:*:*'`, so a later but less specific rule loses.
`20-completion.zsh` deletes it with `zstyle -d` first.

pyenv is lazy. `pyenv init -` costs ~120 ms, so shims go on PATH immediately and
a stub function does the real init on first use.

fnm runs `--log-level quiet`, or it prints a line on every `cd` into a repo with
`.nvmrc` and corrupts the instant prompt.

## Git identity per workspace

`~/.gitconfig` sets a default, then `includeIf` overrides it per workspace. Each
workspace holds its own `.gitconfig.local`, not committed here:

```ini
[user]
	email = me@example.com
	name  = Your Name
[core]
	sshCommand = "ssh -i ~/.ssh/id_personal"
```

`[user]` must come before the `includeIf` blocks. Git takes the last definition,
so putting it after silently overrides every workspace identity.

## Secrets

Nothing secret is committed, and no startup file calls `op`. chezmoi deletes
empty targets, so a failed lookup during apply renders the template to
whitespace and deletes the file. For `~/.zshrc` that means no shell config in
any terminal.

Tokens are injected per command instead:

```sh
opb() { MY_TOKEN="$(op read --no-newline "$MY_TOKEN_REF")" "$@"; }
```

`~/.composer/auth.json` is the exception, since Composer needs a real file. It
renders at apply time and is `.chezmoiignore`d.

## Working on it

```sh
chezmoi edit --apply ~/.zshrc   # edit source, apply, one step
chezmoi diff                    # what would change
chezmoi cd                      # shell into the source dir
chezmoi update                  # pull, then apply
```

Use `chezmoi edit` rather than a direct edit plus `chezmoi re-add`. `re-add`
silently skips templates: reports success, does nothing.
