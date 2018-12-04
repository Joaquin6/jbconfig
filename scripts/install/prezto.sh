#!/bin/sh
set -e # Exit on first error

# http://jr0cket.co.uk/2013/09/hey-prezto-zsh-for-command-line-heaven.html

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
