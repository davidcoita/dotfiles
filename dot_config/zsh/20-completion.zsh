# 20-completion.zsh — completion behaviour and appearance.
#
# Sourced AFTER oh-my-zsh.sh. Two OMZ defaults have to be undone here:
#   lib/completion.zsh sets `zstyle ':completion:*' list-colors ''`  (empty!)
#   lib/completion.zsh sets `zstyle ':completion:*:*:*:*:*' menu select`
# zstyle resolution is by SPECIFICITY, not order — OMZ's 5-star pattern beats a
# plain ':completion:*', so the menu style must be deleted rather than reassigned.

# --- case-insensitive, partial-word, and substring matching ---
# m:{a-z}={A-Z}   lowercase input matches uppercase
# r:|[._-]=*      match on word boundaries: `f.b` -> `foo.bar`, `l-f` -> `lcs-frontend`
# l:|=*           allow a leading substring match
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# --- grouped, described results ---
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose true
zstyle ':completion:*:descriptions' format '%F{blue}%B%d%b%f'
zstyle ':completion:*:messages'     format '%F{purple}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches%f'
zstyle ':completion:*:corrections'  format '%F{yellow}%d (errors: %e)%f'

# --- colors in the completion menu ---
# OMZ probes for `dircolors`, which doesn't exist on macOS — coreutils installs it
# as `gdircolors`. Without this guard you silently get a 13-entry fallback LS_COLORS
# instead of the full 159-entry palette.
if (( $+commands[gdircolors] )); then
  eval "$(gdircolors -b)"
fi
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# --- behaviour ---
zstyle ':completion:*' squeeze-slashes true      # foo//bar -> foo/bar
zstyle ':completion:*' special-dirs true         # complete ./ and ../
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*:manuals'   separate-sections true
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'

# --- fzf-tab ---
# fzf-tab requires `menu no`; OMZ's 5-star `menu select` would win on specificity,
# so delete that context first.
zstyle -d ':completion:*:*:*:*:*' menu
zstyle ':completion:*' menu no

zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=rounded --info=inline
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*'        fzf-preview 'eza -1 --icons --color=always $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --icons --color=always $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  '[[ -d $realpath ]] && eza -1 --icons --color=always $realpath || { [[ -f $realpath ]] && bat --color=always --style=numbers --line-range=:200 $realpath; }' 2>/dev/null
