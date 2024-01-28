# from `cons` on caravan discord
# ~/sh.d/rc
# Limits to a root dir & only
# sources executable numbered
# files in the drop-in dir, in
# order.
function source_files_in_dir() {
    SHDROPINDIRS="$1"
    while read -rd: dir; do
        if [ -d "$dir" ]; then
            for sourcefile in "${dir}"/*; do
                source "${sourcefile}" &> /dev/null
            done
        fi
    done <<< "$SHDROPINDIRS:"
}
# You can use this to be idempotent in other scripts/calls
# export RANSHD=true

# source_files_in_dir "$HOME/.bash_profile.d"

source_files_in_dir "$HOME/.truly_profile.d"

# source_files_in_dir "$HOME/.secrets_profile.d"

export NVM_DIR="$HOME/.nvm"
function init_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

alias replwrap='rlwrap'
## Dynamo
alias dynamo='java -Djava.library.path=~/Dynamo/DynamoDBLocal_lib -jar ~/Dynamo/DynamoDBLocal.jar -sharedDb'
PATH=$PATH:/usr/local/sbin
PATH=$PATH:~/.local/bin
alias mergepdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=out.pdf'
alias yTtoMP3='youtube-dl --extract-audio --audio-format mp3'

## alias delete-orhpaned-branches="git branch -vv | grep ': gone]'|  grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d"

if [ -e /Users/me/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/me/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

alias drs='darwin-rebuild switch --flake ".#x86_64"'

# go
export PATH=$PATH:~/go/bin

# clojure
export LEIN_FAST_TRAMPOLINE=true

## jenv
export PATH="$HOME/.jenv/bin:$PATH"
function init_jenv() { eval "$(jenv init -)" }

# export PATH="/usr/local/opt/openjdk/bin:$PATH"
. "$HOME/.cargo/env"
export PATH="/usr/local/opt/llvm/bin:$PATH"

# zig
export PATH=$PATH:/Users/me/oss/zig-macos-x86_64-0.12.0-dev.1396+f6de3ec96/

# racket
export PATH=$PATH:/Applications/Racket\ v8.10/bin/

# sml
export PATH=$PATH:/usr/local/smlnj/bin/

# haskell
[ -f "/Users/me/.ghcup/env" ] && source "/Users/me/.ghcup/env" # ghcup-env

# ocaml
[[ ! -r /Users/me/.opam/opam-init/init.zsh ]] || source /Users/me/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# bun completions
[ -s "/Users/me/.bun/_bun" ] && source "/Users/me/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# twitch
TWITCH_OAUTH='https://id.twitch.tv/oauth2/authorize?response_type=token&client_id=v1biw1x2lzo3o4b0gqqfplm4tmorsf&redirect_uri=http://localhost:3000&scope=channel%3Amanage%3Apolls+channel%3Aread%3Apolls+channel%3Abot+chat%3Aedit+chat%3Aread'

export EDITOR=vi
