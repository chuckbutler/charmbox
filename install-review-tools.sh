#!/bin/bash
set -e
HOME=/home/ubuntu

# Add tims awesome PPA for the 2.0 bleeding edge tooling
sudo add-apt-repository -y ppa:tvansteenburgh/ppa
sudo apt-get update -qqy
sudo apt-get install -qy unzip \
                         build-essential\
                         charm-tools \
                         python-dev \
                         python-pip \
                         python-virtualenv \
                         rsync  \
                         make \
                         bzr

sudo pip install -U pip
sudo pip install flake8 pyyaml tox --upgrade

cd /tmp
bzr branch lp:~tvansteenburgh/python-jujuclient/beta11 jujuclient
bzr branch lp:~tvansteenburgh/juju-deployer/beta11 deployer
git clone https://github.com/juju/amulet
git clone https://github.com/juju-solutions/bundletester

cd /tmp/bundletester && sudo pip install -U ./
cd /tmp/amulet && sudo pip install -U ./
cd /tmp/deployer && sudo pip install -U ./
cd /tmp/jujuclient && sudo pip install -U ./


# Fix for CI choking on duplicate hosts if the host key has changed
# which is common. 
mkdir -p $HOME/.ssh
echo 'Host *' > $HOME/.ssh/config
echo '  StrictHostKeyChecking no' >> $HOME/.ssh/config

# Chuck hates this
touch $HOME/.vimrc
echo "alias vim=vi" >> /home/ubuntu/.bashrc

echo "export LAYER_PATH=${HOME}/layers" >> /home/ubuntu/.bashrc
echo "export INTERFACE_PATH=${HOME}/interfaces" >> /home/ubuntu/.bashrc

chown -R ubuntu:ubuntu ${HOME}

