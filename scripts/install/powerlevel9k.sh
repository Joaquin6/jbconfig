#!/bin/sh
set -e # Exit on first error

git clone https://github.com/bhilburn/powerlevel9k.git  ~/.zprezto/modules/prompt/external/powerlevel9k
wait

ln -s ~/.zprezto/modules/prompt/external/powerlevel9k/powerlevel9k.zsh-theme ~/.zprezto/modules/prompt/functions/prompt_powerlevel9k_setup
wait

cd .. && rm -rf fonts
