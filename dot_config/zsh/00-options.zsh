# 00-options.zsh — shell behaviour.
# Sourced AFTER oh-my-zsh.sh, because OMZ's lib/directories.zsh and lib/misc.zsh
# set several of these and anything set before the OMZ source line is overwritten.

# --- directories ---
setopt AUTO_CD              # `foo` = `cd foo` if foo is a directory
setopt AUTO_PUSHD           # every cd pushes onto the stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT         # don't print the stack on every cd
setopt PUSHD_TO_HOME
DIRSTACKSIZE=20

# --- globbing ---
setopt EXTENDED_GLOB        # needed for (#q...) qualifiers and ^ negation
setopt GLOB_DOTS            # globs match dotfiles too
setopt NUMERIC_GLOB_SORT    # file2 before file10
setopt NO_NOMATCH           # pass unmatched globs through instead of erroring
                            # (curl 'http://x?a=b' stops needing quotes)

# --- safety ---
setopt NO_CLOBBER           # `>` won't truncate an existing file; use `>|` to force
setopt APPEND_CREATE        # ...but `>>` may still CREATE one. Without this, NO_CLOBBER
                            # makes `>> newfile` fail outright, which surprises everyone.
setopt RM_STAR_WAIT         # 10s pause before `rm *` actually runs
setopt CHECK_JOBS           # warn about running jobs before exiting

# --- misc ---
setopt INTERACTIVE_COMMENTS # allow # comments when typing interactively
setopt NO_BEEP
setopt LONG_LIST_JOBS
setopt MULTIOS
unsetopt CORRECT CORRECT_ALL   # autocorrect guesses wrong more than it helps
