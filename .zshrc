# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

######
# OS
######

# Environment Language
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# SSH
export SSH_KEY_PATH="~/.ssh/fulvio-notarstefano-id-rsa"

# GPG
export GPG_TTY="XXXXXXXXXXXXXXXX"

# Preferred editor for local and remote sessions
if [[ -d "/etc/os-release" ]]; then
  export EDITOR='mate -w'
else
  if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
  else
    export EDITOR='gedit'
  fi
fi
# SU CLI Editor
alias edit="nocorrect sudo nano"


#######
# PATH
#######

# Composer
export PATH=$PATH:vendor/bin


############
# ZSH Shell
############

# Remove username at beginning of prompt
DEFAULT_USER=fulvio

# Theme mods
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Oh My Zsh!
export ZSH=/home/fulvio/.oh-my-zsh
export UPDATE_ZSH_DAYS=13
source $ZSH/oh-my-zsh.sh

# ZSH plugins
plugins=( catimg composer copydir copyfile dirhistory git git-extras grunt gulp httpie npm sudo svn vagrant zsh-autosuggestions zsh-syntax-highlighting codeception )

# Update OhMyZsh
alias zshup="upgrade_oh_my_zsh"

# Powerlevel10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


##################
# Shell functions
##################

# Please
alias please='sudo $(fc -ln -1)'

# Get my local IP address (current interface is enp0s25)
localip() {
  ifconfig enp0s25 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}

# Get my external IP address (uses OpenDNS as resolver)
extip() {
  dig @ns1.google.com TXT o-o.myaddr.l.google.com +short
}

# Echoes both local and external IP addresses
myip() {
  LOCALIP="$(localip)"
  EXTERNALIP="$(extip)"
  echo "Local IP address: ${LOCALIP}"
  echo "External IP address: ${EXTERNALIP}"
}

# open Gnome Files for the current path
files() {
  nocorrect xdg-open .
}

# Mount Synology shared folders
synology() {
  for dir_name in backup books comics downloads dropbox music papà photo projects software surveillance video; do
    sudo mount -t nfs 192.168.2.23:/volume1/$dir_name /synology/$dir_name
    cd /synology
  done
}


##########
# Dropbox
##########

export DROPBOX_PATH=~/Dropbox/


#####################
# Git / GitHub / SVN 
#####################

# Personal: 
export GITHUB_USERNAME=unfulvio
export GITHUB_TOKEN=XXXXXXXXXX
# GoDaddy:
export GITHUB_API_KEY=XXXXXXXX
# SkyVerge SVN:
export WP_SVN_USER="skyverge"

# Sync a Git Fork with Upstream
# https://help.github.com/articles/configuring-a-remote-for-a-fork/
# https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/syncing-a-fork
gitsync() {
  git fetch upstream
  git checkout master
  git merge upstream/master
}

# Make a SVN-compatible patch
# http://scribu.net/wordpress/svn-patches-from-git.html
gitpatch() {
  git diff --no-prefix > "$@"
  patch -p0 "$@"
}

# Clone a GitHub repository
gitclone() {
  git clone https://github.com/$1 $2
}

# Update a repository
gitupdate() {
  # checkout to default branch (ie. master or main)
  BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git checkout $BRANCH
  git pull
  git fetch --prune
}
alias gitup="gitupdate"

# Removes all merged branches
gitprune() {
  gitupdate
  git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}

# Pulls changes from upstream for the current branch
gitpull() {
  git pull origin `git branch --show-current`
}

# Pushes the current branch changes to upstream
gitpush() {
  git push origin `git branch --show-current`
}

# Stash with message
gitstash() {
 git stash save $1
}

# Unstashes last stashed changes
gitunstash() {
 git stash pop
}

# Undo the last commit
gitundo() {
  git reset HEAD~
}

# Cleans the local branch and aligns with remote
gitclean() {
  PRIMARY="origin/$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"
  git fetch origin
  git reset --hard $PRIMARY
  git clean -f -d
}

# Rename a brach and push changesremotely
# usage: gitrename <oldname> <newname>
gitrename() {
  git branch -m $2
  git push origin :$1 $2
  git push origin -u $2
}
alias gitren="nocorrect gitrename"

# Delete a tag locally and upstream
# usage: gitdeletedag <tagname>
gitdeletetag() {
  git tag -d $1
  git push origin ":refs/tags/$1"
}
alias gitrmtag="nocorrect gitdeletetag"

# Configure default editor as the git commit editor
gitgeditor() {
  if [[ -d "/etc/os-release" ]]; then
    git config --global core.editor "mate -w"
  else
    git config --global core.editor "gedit -s"
  fi
}


##############
# Development
##############

export PROJECTS_PATH=~/Projects

export WT_REPOS_PATH=/projects/wp/woothemes/
export WC_CONSUMER_KEY=XXXXX
export WC_CONSUMER_SECRET=XXXXX

export SAKE_PRE_RELEASE_PATH=~/Projects/prereleases/

export CLUBHOUSE_API_TOKEN=XXXXX

VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1

vvv() {
  if [[ $1 == "cd" ]]; then
    if [ -z "$2" ]; then
      cd "/projects/wp/vvv"
    else
      cd "/projects/wp/vvv/www/$2/public_html/"
    fi
  else  
    # this may help with permission problems... sometimes
    echo " " | sudo tee --append /etc/hosts > /dev/null
    echo " " | sudo tee --append /etc/exports > /dev/null
    CWD="$(pwd)"
    cd "/projects/wp/vvv/"
    vagrant "$@"
    cd $CWD
  fi
}
alias vvv="nocorrect vvv"

vvvngrok() {
  if [ $# -eq 0 ]; then
    echo "Using default host ..."
    HOST="skyverge.test"
  else
    echo "Using $1 as the host ... "
    HOST="$1"
  fi
  if [ -z "$2" ]; then
    echo "Subdomain is 'fulvio' ... "
    SUBDOMAIN=fulvio
  else
    echo "Subdomain is '$2' ... "
    SUBDOMAIN="$2"
  fi
  vvv ssh --command "sudo ./ngrok http 80 -host-header=$HOST -subdomain=$SUBDOMAIN -config=/home/vagrant/.ngrok2/ngrok.yml
"
}

skyverge() {
  if [[ $1 == "cd" ]]; then
    if [ -z "$2" ]; then
      cd "/projects/wp/skyverge/"
    else
      cd "/projects/wp/skyverge/$2/"
    fi
  else  
    cd "/projects/wp/skyverge/"
  fi
}

woothemes() {
  cd "/projects/wp/woothemes/" 
}

woocommerce() {
  cd "/projects/wp/woothemes/woocommerce" 
}

subscriptions() {
  cd "/projects/wp/woothemes/woocommerce-subscriptions"
}


#####################
# Package Management
#####################

# Darwin
if [[ -d "/etc/os-release" ]]; then
  DISTRO=Darwin
else 
  DISTRO=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
fi

# Fedora
if [[ "$DISTRO" == "Fedora" ]]; then

  update() {
    sudo dnf check-update
    sudo dnf upgrade
  }

  alias upgrade="update"
  alias autoremove="nocorrect sudo dnf autoremove"
  alias install="nocorrect sudo dnf install"
  alias uninstall="nocorrect sudo dnf erase"

# Debian
else

  alias update="nocorrect sudo apt-get update && nocorrect sudo dnf upgrade"
  alias upgrade="update"
  alias autoremove="nocorrect sudo apt-get autoremove"
  alias install="nocorrect sudo apt-get install"
  alias uninstall="nocorrect sudo apt-get remove"

fi
