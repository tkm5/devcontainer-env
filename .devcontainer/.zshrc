export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
# [ -z "" ] && export TERM=xterm

##### Zsh/Oh-my-Zsh Configuration
export ZSH="/home/devcontainer/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  #------------------
  # General
  #------------------
  aliases
  #------------------
  # Version Control
  #------------------
  git
  github
  #------------------
  # Cloud & Container
  #------------------
  docker
  docker-compose
  gcloud
  #------------------
  # Zsh Enhancements
  #------------------
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export HISTFILE=/commandhistory/.zsh_history

#------------------
# alias settings
#------------------
alias t="tmux"

POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_last"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(user dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_STATUS_OK=false
POWERLEVEL9K_STATUS_CROSS=true

#------------------
# other settings
#------------------
eval "$(uv generate-shell-completion zsh)"
