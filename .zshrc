# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git)

source $ZSH/oh-my-zsh.sh

. "$HOME/.local/bin/env"

export PATH="$PATH:/opt/nvim-linux64/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/sebas/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="$HOME/Apps/flutter/bin:$PATH"

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

alias v="nvim"
alias cat="bat"
alias lg="lazygit"
alias py="python3"
alias ls="eza --icons"
alias la="eza -lah --icons"


alias fooocus="cd ~/Apps/Fooocus && git pull && uv run entry_with_update.py --always-download-new-model --disable-in-browser --preset realistic"

# Develop
alias w.="windsurf ."
alias c.="code ."

# alias dbt="~/Apps/dbt"

# ~~~~~~~~~~ UV ~~~~~~~~~~
## Envoriments
alias uva="source .venv/bin/activate"
alias uvv="uv venv"
alias uvv10="uv venv --python 3.10"
alias uvv11="uv venv --python 3.11"
alias uvv12="uv venv --python 3.12"
alias uvv13="uv venv --python 3.13"

alias uvr="uv run"

## Pip manage
alias uvpi="uv pip install"
alias uvpie="uv pip install -e ."
alias uvpir="uv pip install -r requirements.txt"
alias uvfreeze="uv pip freeze > requirements.txt"

# Fast edit zshrc
alias zshconf="nvim ~/.zshrc"

# pnpm
alias prd="pnpm run dev"
alias prb="pnpm run build"
alias prp="pnpm run preview"
alias paa="pnpm astro add"

# Install
alias sdi="sudo dnf install"
alias sdiy="sudo dnf install -y"

# Navigation aliases
alias cdn="cd ~/.config/nvim"
alias cdk="cd ~/.config/kitty"
alias cdd="cd ~/Develop"
alias cda="cd ~/Apps"

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

# System update function
function upsys {

  # System update
  echo
  echo "\033[32m╔═════╦═══════════════════╗\033[0m"
  echo "\033[32m║ \033[34;1mDNF \033[32m║ \033[34;1mUpdate && Upgrade \033[32m║\033[0m"
  echo "\033[32m╚═════╩═══════════════════╝\033[0m"
  echo
  sudo dnf update
  sudo dnf upgrade

  # Flatpak update
  echo
  echo "\033[32m╔═════════╦════════════════╗\033[0m"
  echo "\033[32m║ \033[34;1mFlatpak \033[32m║ \033[34;1mUpdate         \033[32m║\033[0m"
  echo "\033[32m╚═════════╩════════════════╝\033[0m"
  echo
  flatpak update

  # Rust update
  echo
  echo "\033[32m╔══════╦════════════════╗\033[0m"
  echo "\033[32m║ \033[34;1mRust \033[32m║ \033[34;1mUpdate         \033[32m║\033[0m"
  echo "\033[32m╚══════╩════════════════╝\033[0m"
  echo
  rustup update

  # Pnpm update
  echo
  echo "\033[32m╔══════╦════════════════╗\033[0m"
  echo "\033[32m║ \033[34;1mpnpm \033[32m║ \033[34;1mUpdate         \033[32m║\033[0m"
  echo "\033[32m╚══════╩════════════════╝\033[0m"
  echo
  pnpm self-update
}

# Create a directory and cd into it
function mkcd {
  mkdir -p "$1" && cd "$1"
}

# Extract archives (handles various formats)
function extract {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function ffmpeg_extract_audio {
  ffmpeg -i $1 -map 0:a -acodec libmp3lame $2
}

function ffmpeg_compress_video {
  ffmpeg -i $1 -c:v libx264 -crf 25 -preset medium -tag:v hvc1 -c:a eac3 -b:a 256k $2
}

function ffmpeg_replace_audio {
  ffmpeg -i $1 -i $2 -c:v copy -map 0:v:0 -map 1:a:0 $3
}

function gs_compress_pdf {
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$2 $1
}

function ffmpeg_custom_functions {
  echo "\033[34;1mffmpeg_extract_audio  \033[32m║ \033[34;1mparam 1: video_input \033[32m║ \033[34;1mparam 2: audio_output \033[32m║"
  echo "\033[34;1mffmpeg_compress_video \033[32m║ \033[34;1mparam 1: video_input \033[32m║ \033[34;1mparam 2: video_output \033[32m║"
  echo "\033[34;1mffmpeg_replace_audio  \033[32m║ \033[34;1mparam 1: video_input \033[32m║ \033[34;1mparam 2: audio_input  \033[32m║ \033[34;1mparam 3: video_output \033[32m║"
}

function du1 {
  du -sh * | sort -rh | head -10
}
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

