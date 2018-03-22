#!/usr/bin/env bash
#
# Referenced from https://gist.github.com/codeinthehole/26b37efa67041e1307db
#
# Last update: March 2018
#
# Let us begin
echo "Starting Build, you will be promted for your password, stay attentive..."

# Check for system Ruby
if test ! $(which ruby); then
    echo "Mac's ship with Ruby, but I can't find it..."
fi

# Ensure Xcode is installed
if test ! $(which xcode-select); then
    echo "Installing xcode tools..."
    xcode-select --install
fi

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# BREW_INSTALL_SET
BREW_INSTALL_SET=(
  ansible
  git
  mas
  mtr
  npm
  telnet
  terraform
  wget
  yarn
  zsh
  zsh-completions
)

# Install Brew native packages, some have to be casks
echo "Installing Brew Packages..."
brew install ${BREW_INSTALL_SET[@]}

echo "Cleaning up..."
brew cleanup

CASK_INSTALL_SET=(
  caffeine
  chromecast
  dropbox
  evernote
  etcher
  google-chrome
  google-chrome-canary
  google-drive-file-stream
  handbrake
  iterm2
  keepassx
  lastpass
  mysqlworkbench
  postman
  sequel-pro
  slack
  skitch
  spotify
  superduper
  tunnelblick
  vagrant
  virtualbox
  visual-studio-code
  vlc
)

# Install Casks
echo "Installing Cask Apps..."
brew cask install ${CASK_INSTALL_SET[@]}

# Install composer
# Note - As of March 2018, there is no vanilla brew pacakge for composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install ohmyzsh, cuz...
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Copy over .ohmyzsh config
yes | cp files/.zshrc ~/

# Write our your git config
cat << EOF > ~/.gitconfig
[user]
    name = Aaron Gibson
    email = aaron@goreact.com
[github]
    user = biggiemac
[alias]
    a = add
    ca = commit -a
    cam = commit -am
    s = status
    pom = push origin master
    pog = push origin gh-pages
    puom = pull origin master
    puog = pull origin gh-pages
    cob = checkout -b
EOF

# Install eyaml, you know for encrypting the the secrets...
sudo gem install hiera-eyaml

# Notify on completion
echo "Build Complete"
