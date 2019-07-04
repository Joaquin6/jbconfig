#!/bin/sh

ghget () {
    # input: rails/rails
    USER=$(echo $@ | tr "/" " " | awk '{print $1}')
    REPO=$(echo $@ | tr "/" " " | awk '{print $2}')
    mkcd "$HOME/projects/github.com/$USER" && \
    hub clone $@ && \
    cd $REPO
}