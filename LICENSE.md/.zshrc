
######
# OS
######

# Environment Language
export LANG=en_US.UTF-8

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# SSH
export SSH_KEY_PATH="~/.ssh/fulvio-notarstefano-id-rsa"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# SU CLI Editor
alias edit="nocorrect sudo nano"

# PATH
export PATH=$PATH:/opt/gitkraken
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/projects/go
export PATH=$PATH:$(go env GOPATH)/bin

############
# ZSH Shell
############

# Remove username at beginning of prompt
DEFAULT_USER=fulvio

# Theme mods
ZSH_THEME="agnoster"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Oh My Zsh!
export ZSH=/home/fulvio/.oh-my-zsh
export UPDATE_ZSH_DAYS=13
source $ZSH/oh-my-zsh.sh

# ZSH plugins
plugins=( bower composer git git-extras grunt npm sudo svn vagrant zsh-autosuggestions )


# Get my local IP address (current interface is enp0s25)
localip() {
  ifconfig enp0s25 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}

# Get my external IP address (uses OpenDNS as resolver)
extip() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

# Echoes both local and external IP addresses
myip() {
  LOCALIP="$(localip)"
  EXTERNALIP="$(extip)"
  echo "Local IP address: ${LOCALIP}"
  echo "External IP address: ${EXTERNALIP}"
}

# Windows Remote Desktop
windows() {
  if [ $# -eq 0 ]; then
    echo 'Using default address. '
    WINIP="192.168.2.14"
  else
    WINIP=$1  
  fi
  echo "Connecting to $WINIP..."
  rdesktop -g 1920x1080 -r disk:moshimoshi=/home/fulvio/Desktop/Shared -u XXXXXX.XXXXXXXX@XXXXXXXX.XXX $WINIP
}

# Mount Synology shared folders
synology() {
  for dir_name in backup books comics downloads music photo projects software video; do
    sudo mount -t nfs 192.168.2.23:/volume1/$dir_name /synology/$dir_name
    cd /synology
  done
}


##########
# Dropbox
##########

export DROPBOX_PATH=~/Dropbox/


###############
# Git / GitHub
###############

export GITHUB_USERNAME=unfulvio
#export GITHUB_API_KEY=XXXXXXXX
#export GITHUB_TOKEN=XXXXXXXXXX

# Sync a Git Fork with Upstream
# https://help.github.com/articles/configuring-a-remote-for-a-fork/
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
  git checkout master
  git pull
  git fetch --prune
}
alias gitup="gitupdate"

# Undo the last commit
gitundo() {
  git reset HEAD~
}

# Rename a brach 
# usage: gitrename <oldname> <newname>
gitrename() {
  git branch -m $2
  git push origin :$1 $2
  git push origin -u $2
}
alias gitren="gitrename"

# Delete a tag locally and upstream
# usage: gitdeletedag <tagname>
gitdeletetag() {
  git tag -d $1
  git push origin ":refs/tags/$1"
}
alias gitrmtag="gitdeletetag"


################
# WordPress Dev
################

export WT_REPOS_PATH=/projects/wp/woothemes/

vvv() {
  if [[ $1 == "cd" ]]; then
    cd "/projects/wp/vvv/srv/www/$2/public_html/"
  else  
    CWD="$(pwd)"
    cd "/projects/wp/vvv/"
    vagrant "$@"
    cd $CWD
  fi
}

skyverge() {
  cd "/projects/wp/skyverge/"
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

jiltwc() {
  cd "/projects/wp/skyverge/jilt-for-woocommerce"
}

jiltedd() {
  cd "/projects/wp/skyverge/jilt-for-edd"
}


#####################
# Package Management
#####################

DISTRO=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)

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
