#!/bin/sh

set -e # Exit on first error

export PREZTO_RCS=('.zlogin' '.zlogout' '.zpreztorc' '.zprofile' '.zshenv')

for rcfile in "${PREZTO_RCS[@]}"; do
  rm -rf "$HOME/${rcfile}"
  ln -s "$HOME/jbconfig/zsh/$rcfile" "$HOME/${rcfile}"
done