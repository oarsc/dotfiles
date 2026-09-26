# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /usr/share/nvm/init-nvm.sh

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export LESS="-Xr"
export EDITOR=nvim

function http {
    docker run -d --rm -p "${1:-80}":80 -v "$PWD":/usr/src/app --name "${2:-http}" -w /usr/src/app node:18-alpine sh -c "npm install -g http-server && http-server -p 80"
}

function nohup {
  command nohup "$@" > /dev/null 2>&1 &
}

alias zshrc="source ~/.zshrc"
alias vi=nvim
alias socks="ssh -CqND 9999 127.0.0.1"
