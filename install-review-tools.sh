#!/bin/bash
set -e

useradd -m ubuntu
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/juju-users
HOME=/home/ubuntu

sudo apt-get update -qqy
sudo apt-get install -qy unzip build-essential charm-tools python-dev python-pip python-virtualenv rsync
sudo pip install bundletester flake8

mkdir -p $HOME/.go
export GOPATH=$HOME/.go
export GOROOT=/usr/lib/go

# Fetch latest code
go get launchpad.net/godeps/...
mkdir -p $HOME/.go/src/github.com/juju/
git clone https://github.com/juju/juju $HOME/.go/src/github.com/juju/juju
cd $HOME/.go/src/github.com/juju/juju
git fetch --all
git checkout 1.25

# Build!
JUJU_MAKE_GODEPS=true make godeps
make build
make install

echo "export PATH=${HOME}/.go/bin:$PATH:${HOME}/.juju-plugins" >> ${HOME}/.bashrc
chown -R ubuntu:ubuntu ${HOME}

