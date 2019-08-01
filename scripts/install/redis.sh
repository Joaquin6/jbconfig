#!/bin/sh

set -e # Exit on first error

mkdir -p $HOME/redis && cd $HOME/redis

curl -O http://download.redis.io/redis-stable.tar.gz \
	&& tar xvzf redis-stable.tar.gz \
	&& cd redis-stable \
	&& make
