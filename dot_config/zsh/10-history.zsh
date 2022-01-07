# 10-history.zsh — history that doesn't silently throw itself away.
#
# The old config had HISTSIZE=50000 but SAVEHIST=10000, with 12,236 entries on
# disk: every save truncated the file. oh-my-zsh's lib/history.zsh clamps both,
# which is why this must be sourced AFTER oh-my-zsh.sh.

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
# zsh writes NOTHING and reports NOTHING if this directory is missing.
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

HISTSIZE=200000     # in-memory
SAVEHIST=100000     # on-disk — must be <= HISTSIZE or you truncate on every save

setopt EXTENDED_HISTORY       # record timestamp + duration
setopt SHARE_HISTORY          # live sharing between concurrent shells
unsetopt INC_APPEND_HISTORY   # the manual: turn this off when SHARE_HISTORY is on

setopt HIST_IGNORE_ALL_DUPS   # keep only the most recent copy of a duplicate
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE      # leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY            # expand !! into the buffer instead of running it blind
setopt HIST_NO_STORE          # don't record `history` itself
setopt HIST_FCNTL_LOCK        # fcntl locking — safer and faster with many shells

# No-op once HIST_IGNORE_ALL_DUPS is set; OMZ turns it on, so turn it back off.
unsetopt HIST_EXPIRE_DUPS_FIRST
