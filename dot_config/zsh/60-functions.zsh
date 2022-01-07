# 60-functions.zsh — things that need arguments, so aliases won't do.

# Laravel Sail. The old alias resolved its path ONCE, at .zshrc load time, in
# $HOME — so it was permanently baked to `sh vendor/bin/sail` and the ./sail
# branch was dead code. It also ran a bash script under sh.
sail() {
  local bin
  if   [[ -f sail ]];            then bin=sail
  elif [[ -f vendor/bin/sail ]]; then bin=vendor/bin/sail
  else print -u2 "sail: no ./sail or ./vendor/bin/sail in $PWD"; return 1
  fi
  bash "$bin" "$@"
}

# artisan, through sail when the containers are up, otherwise straight php
art() {
  if [[ -f vendor/bin/sail ]] && docker compose ps --status=running 2>/dev/null | grep -q .; then
    sail artisan "$@"
  else
    php artisan "$@"
  fi
}

# Run the right package manager for whatever repo you're standing in.
pm() {
  if   [[ -f pnpm-lock.yaml ]];    then pnpm "$@"
  elif [[ -f yarn.lock ]];         then yarn "$@"
  elif [[ -f bun.lockb || -f bun.lock ]]; then bun "$@"
  elif [[ -f package-lock.json ]]; then npm "$@"
  else print -u2 "pm: no lockfile in $PWD"; return 1
  fi
}
alias n='pm'
nr() { pm run "$@"; }

# kubectl context / namespace switching with fzf when given no argument
kx() { [[ -n $1 ]] && kubectx "$1" || kubectx; }
kns() { [[ -n $1 ]] && kubens "$1" || kubens; }

# Shell into the first pod matching a name fragment
ksh() {
  local pod
  pod=$(kubectl get pods --no-headers -o custom-columns=':metadata.name' \
        | fzf --query="${1:-}" --select-1 --exit-0 --height=40% --reverse) || return
  [[ -n $pod ]] && kubectl exec -it "$pod" -- ${2:-sh}
}

# mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extract any archive
extract() {
  [[ -f $1 ]] || { print -u2 "extract: '$1' is not a file"; return 1 }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1"   ;;
    *.tar.gz|*.tgz)   tar xzf "$1"   ;;
    *.tar.xz)         tar xJf "$1"   ;;
    *.tar)            tar xf  "$1"   ;;
    *.zip)            unzip   "$1"   ;;
    *.gz)             gunzip  "$1"   ;;
    *.bz2)            bunzip2 "$1"   ;;
    *.7z)             7z x    "$1"   ;;
    *) print -u2 "extract: don't know how to handle '$1'"; return 1 ;;
  esac
}

# Kill whatever is listening on a port
killport() {
  [[ -n $1 ]] || { print -u2 "usage: killport <port>"; return 1 }
  local pids=( ${(f)"$(lsof -ti tcp:$1 2>/dev/null)"} )
  (( $#pids )) || { print "nothing listening on $1"; return 0 }
  print "killing: $pids"
  kill -9 $pids
}
