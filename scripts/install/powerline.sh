#!/bin/sh
set -e # Exit on first error

git clone https://github.com/powerline/fonts.git --depth=1
wait

cd fonts && ./install.sh
wait

cd .. && rm -rf fonts
