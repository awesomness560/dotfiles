# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="nvim"

ZSH_THEME="crcandy"

plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# alias yazi="kitty --class yazi -e yazi"
# alias nvim="kitty --class nvim -e nvim"

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

eval "$(zoxide init zsh)"


compress-screen() {
    ffmpeg -i "$1" -vf "scale='min(1280,iw)':-2" \
        -c:v libx264 -crf 30 -preset slow -r 24 \
        -c:a aac -b:a 96k -movflags +faststart \
        "${1%.*}-small.mp4"
}

compress() {
    local in="$1"
    [ -f "$in" ] || { echo "usage: compress <file> [crf]"; return 1; }
    local crf="${2:-28}"
    local out="${in%.*}-compressed.mp4"

    ffmpeg -i "$in" \
        -c:v libx264 -crf "$crf" -preset slow \
        -c:a aac -b:a 128k \
        -movflags +faststart \
        -pix_fmt yuv420p \
        "$out" || return 1

    echo "$(du -h "$in" | cut -f1) → $(du -h "$out" | cut -f1)"
}

function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

dotadd() {
  mkdir -p ~/dotfiles/"$1"/.config &&
  mv ~/.config/"$1" ~/dotfiles/"$1"/.config/ &&
  stow -d ~/dotfiles -t ~ "$1" &&
  echo "Now tracking $1"
}
