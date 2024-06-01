#!/bin/sh

UPSTREAM_BRANCH="nixos-24.05"
OWN_BRANCH="own-${UPSTREAM_BRANCH}"

# Update remote if not exists.
git config remote.upstream.url >&- || git remote add upstream https://github.com/NixOS/nixpkgs.git

# Move to the correct branch.
git checkout $OWN_BRANCH
git pull

# Update the branch with upstream.
git fetch upstream
git merge upstream/$UPSTREAM_BRANCH --no-edit
git push
