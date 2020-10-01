#!/bin/sh
set -e # Exit on first error

# Configure Git
git config --global user.name "Joaquin Briceno"
git config --global user.email joaquinbriceno1@gmail.com

git config --global core.repositoryformatversion 0
git config --global core.filemode true
git config --global core.bare true
git config --global core.logallrefupdates true
git config --global core.ignorecase true
git config --global core.precomposeunicode true

git config --global pull.rebase true

git config --global color.ui auto
