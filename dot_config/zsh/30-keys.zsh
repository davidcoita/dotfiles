# 30-keys.zsh — keybindings.
#
# Terminals disagree on what Option+arrow, Home, and End send, so the working
# approach is to bind every encoding rather than trust terminfo alone.
# ($terminfo values are only valid inside zle while the terminal is in
#  application mode; OMZ's zle-line-init hooks handle that with echoti smkx.)

bindkey -e   # emacs keymap

# Treat / . _ - as word separators so Option+arrow steps through path segments
# instead of jumping the whole path. (OMZ's lib/completion.zsh sets WORDCHARS='').
WORDCHARS='*?[]~&;!#$%^(){}<>'

# --- word motion: iTerm2 Esc+, Natural Text Editing preset, and xterm modifier form ---
for k in '^[^[[D' '^[b' '^[[1;3D' '^[[1;5D'; do bindkey "$k" backward-word; done
for k in '^[^[[C' '^[f' '^[[1;3C' '^[[1;5C'; do bindkey "$k" forward-word;  done
unset k

# --- line motion ---
bindkey '^[[H' beginning-of-line;  bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line;        bindkey '^[[4~' end-of-line
bindkey '^A'   beginning-of-line;  bindkey '^E'    end-of-line
[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]}  ]] && bindkey "${terminfo[kend]}"  end-of-line

# --- deletion ---
bindkey '^[[3~'   delete-char
bindkey '^[[3;5~' kill-word
bindkey '^H'      backward-delete-char
bindkey '^W'      backward-kill-word
bindkey '^U'      backward-kill-line   # kill to start of line, not the whole line

# --- history: prefix-aware up/down ---
# Type `git ` then Up to walk only through commands starting with `git `.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search;   bindkey '^P' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search; bindkey '^N' down-line-or-beginning-search
[[ -n ${terminfo[kcuu1]} ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n ${terminfo[kcud1]} ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# --- open the current command line in $EDITOR (Ctrl-X Ctrl-E) ---
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# --- sudo the current line (Esc Esc) ---
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  [[ $BUFFER == sudo\ * ]] && BUFFER="${BUFFER#sudo }" || BUFFER="sudo $BUFFER"
  zle end-of-line
}
zle -N sudo-command-line
bindkey '^[^[' sudo-command-line
