# 40-dirs.zsh — project navigation.
#
# Replaces 10 hardcoded `cd` aliases. Two of them had already silently broken
# when the repos moved — which is the whole argument for generating these from
# the filesystem instead of maintaining them by hand.
#
# Every git repo under ~/Code gets a named directory: `cd ~myproject` works from
# anywhere, `~myproject` works as a path argument, and it tab-completes.

: ${CODE:=$HOME/Code}
export CODE

# Every workspace directly under $CODE joins cdpath, so `cd myrepo` works from
# anywhere no matter which workspace it lives in. Discovered, not hardcoded —
# add a directory under $CODE and it just works.
#   [^.]*  skips dotdirs. GLOB_DOTS is on (see 00-options), so a plain * would
#          otherwise drag in .idea, .DS_Store and friends.
#   (N/)   directories only; expands to nothing if $CODE doesn't exist.
cdpath=( . $CODE $CODE/[^.]*(N/) )

# Generate ~name for every repo, 2 and 3 levels deep.
# Anonymous function so the locals don't leak into the shell.
() {
  local g d p n
  typeset -A seen
  for g in $CODE/*/*/.git(N) $CODE/*/*/*/.git(N); do
    d=${g:h}          # the repo
    p=${d:h}          # its parent
    # Nested one level under ~/Code (e.g. ~/Code/work/myapp)     -> myapp
    # Deeper           (e.g. ~/Code/work/bigproject/frontend)    -> bigproject-frontend
    [[ ${p:h} == $CODE ]] && n=${d:t} || n=${p:t}-${d:t}
    # A name containing a space aborts the whole loop, so skip anything odd.
    [[ $n == [A-Za-z0-9_-]## ]] || continue
    (( ${+seen[$n]} )) || { hash -d -- "$n=$d"; seen[$n]=1 }
  done
}

hash -d code="$CODE"
hash -d icloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
hash -d dl="$HOME/Downloads"

# Interactive repo picker — `p` with no argument, or `p <filter>`.
p() {
  local dir
  dir=$(fd --type d --hidden --max-depth 4 '^\.git$' "$CODE" 2>/dev/null \
        | sed 's|/\.git/$||' \
        | fzf --query="${1:-}" --select-1 --exit-0 \
              --height=60% --layout=reverse --border=rounded \
              --preview 'eza -1 --icons --color=always {} 2>/dev/null | head -40') || return
  [[ -n $dir ]] && cd "$dir"
}
