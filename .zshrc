
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
export GPG_TTY="<XXXXXXXXXXXXXX>"


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# SU CLI Editor
alias edit="nocorrect sudo nano"


#######
# PATH
#######

# Gitkraken
export PATH=$PATH:/opt/gitkraken
# Composer
export PATH=$PATH:vendor/bin
# HTTP Prompt
export PATH=$PATH:/home/fulvio/.local/bin
# Snap
export PATH=$PATH:/var/lib/snapd/snap/bin 
# Go
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
plugins=( catimg composer copydir copyfile dirhistory git git-extras grunt gulp httpie npm sudo svn vagrant zsh-autosuggestions zsh-syntax-highlighting codeception )

# Update OhMyZsh
alias updatezsh="upgrade_oh_my_zsh"

# Please
alias please='sudo $(fc -ln -1)'

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

# Creates a Gnome app shortcut
appshortcut() {
  if [ $# -eq 0 ]; then
    return
  else
    cat "~/.local/share/applications/$1.desktop" << EOF
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Application Name
Comment=Application description
Icon=/path/to/icon.svg
Exec=application or "script.sh" %f
Terminal=false
StartupWMClass=helps-with-sticky
Name[en_GB]=Application.desktop
EOF
    gedit "~/.local/share/applications/$1.desktop"
  fi
}

# open Gnome Files for the current path
files() {
  nocorrect xdg-open .
}

# fix for VMWare Workstation breaks (must update the VM version)
fixwmware() {
  VMWARE_VERSION=workstation-15.5.1
  TMP_FOLDER=/tmp/patch-vmware

  rm -fdr $TMP_FOLDER
  mkdir -p $TMP_FOLDER
  cd $TMP_FOLDER

  git clone https://github.com/mkubecek/vmware-host-modules.git

  cd $TMP_FOLDER/vmware-host-modules

  git checkout $VMWARE_VERSION
  git fetch

  make
  sudo make install
  sudo rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
  sudo ln -s /lib/x86_64-linux-gnu/libz.so.1

  /usr/lib/vmware/lib/libz.so.1/libz.so.1

  sudo /etc/init.d/vmware restart
}

# Windows Remote Desktop
windows() {
  if [ $# -eq 0 ]; then
    echo 'Using default address... '
    WINIP="192.168.2.14"
  else
    WINIP=$1  
  fi
  echo "Connecting to $WINIP..."
  rdesktop -g 1920x1080 -r disk:moshimoshi=/home/fulvio/Desktop/Shared -u fulvio.notarstefano@gmail.com $WINIP
}

# Mount Synology shared folders
synology() {
  for dir_name in backup books comics downloads dropbox music photo projects software surveillance video; do
    sudo mount -t nfs 192.168.2.23:/volume1/$dir_name /synology/$dir_name
    cd /synology
  done
}


##########
# Dropbox
##########

export DROPBOX_PATH=~/Dropbox/


###########################
# Git / GitHub / ClubHouse
###########################

export GITHUB_USERNAME=unfulvio
export GITHUB_API_KEY=<XXXXXXXXXXXXXX>
export GITHUB_TOKEN=<XXXXXXXXXXXXXX>

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
  git checkout master
  git pull
  git fetch --prune
}
alias gitup="gitupdate"

# Removes all merged branches
gitprune() {
  gitupdate
  git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
}

# Stash with message
gitstash() {
 git stash save $1
}

# Undo the last commit
gitundo() {
  git reset HEAD~
}

# Run a composer update when switching branches or pulling the latest changes
gitcompose() {
  if [[ $# -eq 0 ]]; then
    git checkout $1
    git pull origin $1
  else
    git pull origin $(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  fi
  composer update
}

# Rename a brach 
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

# Configures gedit as the default git editor
gitgedit() {
  git config --global core.editor "gedit -s"
}

##############
# Development
##############

export WT_REPOS_PATH=/projects/wp/woothemes/
export WC_CONSUMER_KEY=<XXXXXXXXXXXXXX>
export WC_CONSUMER_SECRET=<XXXXXXXXXXXXXX>

export CLUBHOUSE_API_TOKEN=<XXXXXXXXXXXXXX>
export GLOTPRESS_USER=fulvio
export GLOTPRESS_PASSWORD=<XXXXXXXXXXXXXX>


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

# Packages and tools to install on clean machine
setup() {
  update
  # https://httpie.org/
  install httpie
  # http://http-prompt.com/
  pip install --user http-prompt 
}
