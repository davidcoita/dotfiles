# 80-tools.zsh — tool initialisation.
#
# Everything eval-based lives here, and this file loads after compinit (which
# oh-my-zsh runs) because zoxide, fnm and friends register completions.
#
# NOTE: no secrets in this file, or in any file the shell sources at startup.
# See ~/.composer/auth.json (chezmoi template) and the `opb` wrapper instead.

# --- fnm: replaces nvm ---
# The old nvm was a 170ms no-op: `nvm current` returned `system`, PATH had zero
# nvm entries, and every project ran Homebrew's Node 26 regardless of .nvmrc.
# fnm reads the same .nvmrc files natively.
if (( $+commands[fnm] )); then
  # --log-level quiet suppresses the "Using Node v18.20.8" line fnm prints on
  # every cd into a project with a .nvmrc. Besides being noise, output during
  # shell init corrupts powerlevel10k's instant prompt.
  eval "$(fnm env --use-on-cd --log-level quiet --shell zsh)"
fi

# --- zoxide: frecency-based jumping, complements the named dirs in 40-dirs ---
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# --- pyenv: lazy ---
# `pyenv init - zsh` costs 121ms per shell — measured, and the single largest
# remaining startup cost once nvm was gone. The shims directory on PATH is all
# that's needed to *run* a pyenv-managed python; the expensive part is the shell
# function and the rehash hook, which only matter when you invoke pyenv itself.
# So: add shims eagerly (cheap), do the full init on first real use.
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
if [[ -d $PYENV_ROOT/shims ]]; then
  path=( $PYENV_ROOT/shims $path )

  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init - zsh)"
    pyenv "$@"
  }
fi

# --- Google Cloud SDK ---
# A tarball install lands wherever you unpacked it, so look for it rather than
# hardcoding a path: any workspace under $CODE, plus the two common locations.
# The (N) qualifiers mean "skip silently if absent", so machines without the SDK
# pay nothing and print nothing.
_gcloud_sdk=( $CODE/[^.]*/google-cloud-sdk(N/) $HOME/google-cloud-sdk(N/) /opt/homebrew/share/google-cloud-sdk(N/) )
if (( $#_gcloud_sdk )) && [[ -f $_gcloud_sdk[1]/path.zsh.inc ]]; then
  source $_gcloud_sdk[1]/path.zsh.inc
  [[ -f $_gcloud_sdk[1]/completion.zsh.inc ]] && source $_gcloud_sdk[1]/completion.zsh.inc
fi
unset _gcloud_sdk

# --- bun completions ---
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# --- java ---
# The old config ran `$(/usr/libexec/java_home)` on every shell start. openjdk@21
# is already first on PATH from .zprofile, so resolve it lazily instead.
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"

# --- docker ---
export COMPOSE_BAKE=false

# --- fzf ---
# `fzf --zsh` emits both key-bindings and completion. It must come after compinit
# (it guards on compdef) and before zsh-syntax-highlighting (it defines widgets).
# That happens at the bottom of .zshrc, not here.
export FZF_DEFAULT_OPTS="
  --height=60% --layout=reverse --border=rounded --info=inline
  --color=fg:#c0caf5,bg:-1,hl:#7aa2f7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#bb9af7
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
  --color=border:#414868"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'

# --- bat ---
export BAT_THEME="tokyonight_night"
