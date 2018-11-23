#!/bin/sh
set -e # Exit on first error


extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)        tar xjf $1        ;;
      *.tar.gz)         tar xzf $1        ;;
      *.bz2)            bunzip2 $1        ;;
      *.rar)            unrar x $1        ;;
      *.gz)             gunzip $1         ;;
      *.tar)            tar xf $1         ;;
      *.tbz2)           tar xjf $1        ;;
      *.tgz)            tar xzf $1        ;;
      *.zip)            unzip $1          ;;
      *.Z)              uncompress $1     ;;
      *.7z)             7zr e $1          ;;
      *)                echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

if which brew &> /dev/null; then
  brew install ruby
else
  # https://www.ruby-lang.org/en/documentation/installation/
  curl -sS https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz \
    && extract ./ruby-2.5.1.tar.gz \
    && rm -rf ./ruby-2.5.1.tar.gz \
    && cd ./ruby-2.5.1 \
    && ./configure \
    && make \
    && sudo make install \
    && cd .. \
    && rm -rf ./ruby-2.5.1
fi

# https://guides.rubygems.org/rubygems-basics/#installing-gems

gem install drip \
  && gem install xcode-install \
  && gem install colorls
