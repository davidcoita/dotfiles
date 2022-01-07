# 50-aliases.zsh — the aliases that survived the audit.
#
# Deleted and why:
#   zshconfig/ohmyzsh  sudo vim on files you already own. sudoers has
#                      env_keep+="HOME MAIL", so vim ran as root with your HOME
#                      and wrote root-owned ~/.viminfo, swap and undo files.
#   work/pers          replaced by cdpath — `cd <workspace>` works from anywhere
#   lcsb lcsf wbb wbf  replaced by generated named dirs (generated from the filesystem);
#   wbd bpa bpf bpb bp lcsb/lcsf were already broken — those repos moved
#   sail               was baked to `sh vendor/bin/sail` at load time -> now a function
#   dc                 shadowed /usr/bin/dc, the POSIX desk calculator
#   dce                duplicated the omz docker-compose plugin's own alias
#   mux muxconfig      tmuxinator — unused since Feb 2026
#   lcs bp             tmuxinator session starters, same
#   berdb              a generic helper in the private overlay already does this
#   sshene             replaced by a Host entry with LocalForward in ~/.ssh/config
#   icloud             replaced by the named dir ~icloud

# --- modern replacements ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git --time-style=long-iso'
alias la='eza -la --icons --group-directories-first --git --time-style=long-iso'
alias lt='eza --tree --level=2 --icons --group-directories-first'
alias cat='bat --style=plain'
alias catt='bat'                     # with line numbers and git gutter
command -v fd >/dev/null && alias find='fd'

# --- shell ---
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias zshconf='cd ~/.config/zsh'
alias reload='exec zsh'
alias path='print -l $path'
alias fpath='print -l $fpath'

# --- docker (omz docker-compose plugin provides dc*, dco etc.) ---
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f --tail=100'
alias dcps='docker compose ps'

# --- kubernetes ---
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'

# --- terraform ---
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfi='terraform init'

# --- misc ---
alias ip='curl -s ifconfig.me && echo'
alias ports='lsof -iTCP -sTCP:LISTEN -P -n'
alias df='df -h'
alias du='du -h'
