#!/bin/sh

set -e # Exit on first error

rm -rf "$HOME/.oh-my-zsh"
ln -s "$HOME/jbconfig/zsh/plugins/oh-my-zsh" "$HOME/.oh-my-zsh"