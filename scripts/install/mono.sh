#!/bin/sh
set -e # Exit on first error

PREFIX=/usr/local

# Ensure you have write permissions to /usr/local
mkdir -p $PREFIX
sudo chown -R `whoami` $PREFIX

PATH=$PREFIX/bin:$PATH

# Download and build dependencies
mkdir -p ~/Build
cd ~/Build

brew update
brew install autoconf automake libtool pkg-config cmake m4

# if [[ ! -d ~/Build/m4-1.4.17 ]]; then curl -O https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz; fi
# if [[ ! -d ~/Build/autoconf-2.69 ]]; then curl -O https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz; fi
# if [[ ! -d ~/Build/automake-1.14 ]]; then curl -O https://ftp.gnu.org/gnu/automake/automake-1.16.tar.gz; fi
# if [[ ! -d ~/Build/libtool-2.4.2 ]]; then curl -O https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz; fi
# curl -O https://download.mono-project.com/sources/libgdiplus/libgdiplus0-6.0.4.tar.gz
# https://download.mono-project.com/sources/mono-tools/mono-tools-4.2.tar.gz

# for i in *.tar.gz; do tar xzvf $i; done
# for i in */configure; do (cd `dirname $i`; ./configure --prefix=$PREFIX && make && make install); done

if [[ ! -d ~/Build/mono ]]; then git clone https://github.com/mono/mono.git; fi

cd ~/Build/mono
./autogen.sh --prefix=$PREFIX --disable-nls
sudo make get-monolite-latest
sudo make
sudo make install
