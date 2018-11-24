#!/bin/sh
set -e # Exit on first error

source '../helpers.sh'

ghget square/maximum-awesome
wait

rake