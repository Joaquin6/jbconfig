#!/bin/sh
set -e # Exit on first error

# https://github.com/amix/vimrc
# https://joaquin-briceno.gitbook.io/workspace/vim

# download the vimrc files:
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime & wait

# install the complete version
sh ~/.vim_runtime/install_awesome_vimrc.sh