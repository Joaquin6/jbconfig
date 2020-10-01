#!/bin/bash

# Download the latest packages & upgrade - for convenience's sake
apt-get update
apt-get upgrade -y

# PPAs
add-apt-repository -y ppa:nilarimogard/webupd8
add-apt-repository -y ppa:otto-kesselgulasch/gimp
add-apt-repository -y ppa:chris-lea/node.js
apt-get update

apt-get install node gimp android-tools ppa-purge

# Ubuntu Repositories
apt-get install -y git htop vim curl build-essential filezilla node guake zsh



source ./git/configure.sh
