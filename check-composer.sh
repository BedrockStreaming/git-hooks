#!/usr/bin/env bash

# check-composer.sh
#
# Check if there a composer installation difference between past and future branch, and launch a composer update command
#
# Install into:
# - .git/hooks/post-merge
# - .git/hooks/post-rewrite
# - .git/hooks/post-checkout
#
# And make sure all are executable.
# 

file="composer.lock"

if [[ $(git diff HEAD@{1}..HEAD@{0} -- "${file}" | wc -l) -gt 0 ]]; then
  echo
  echo "NB : The file '${file}' changed, executing 'composer install' command"
  echo 
  composer install
  echo
fi
