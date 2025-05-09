#!/bin/bash
echo_status() { local msg=$1; echo "[$(date -u +%Y-%m-%dT%H:%M:%S%Z)] $msg" | tee -a ~/status; }

echo_status "on-create start"
pip install --no-cache-dir ipython ipykernel
pip install "black[jupyter]"
pip install isort

# only run apt upgrade on pre-build
sudo apt-get update
if [ "$CODESPACE_NAME" = "null" ]
then
    echo_status "apt upgrading"
    sudo apt-get upgrade -y
fi

# Additional git setup
# sudo apt install git-extras
echo_status "  setting up some git and zsh goodies"
# setup easy git aliases
cp .devcontainer/gitconfig-base ~/.gitconfig
echo "zstyle ':omz:update' mode auto" >> ~/.zshrc
# install some git diff tools
wget -q  "$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | jq '.assets[].browser_download_url' -r | grep -vE 'musl|darwin|arm|apple|windows' | grep 'amd64.*deb')" -O /tmp/delta.deb
sudo dpkg -i /tmp/delta.deb

wget "$(curl -s https://api.github.com/repos/so-fancy/diff-so-fancy/releases/latest | jq '.assets[].browser_download_url' -r)" --output-document /tmp/diff-so-fancy
chmod +x /tmp/diff-so-fancy && sudo mv /tmp/diff-so-fancy /usr/local/bin/

# Install azure function core tools
echo_status "  installing azure function core tools"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs 2>/dev/null | cut -d'.' -f 1)/prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update
sudo apt-get install azure-functions-core-tools-4

# permanently change shell to zsh for codespace user
sudo chsh --shell /bin/zsh "$USER"
echo_status "on-create complete"
