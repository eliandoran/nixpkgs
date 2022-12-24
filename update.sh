#!/bin/sh

UPSTREAM_BRANCH="nixos-22.11"
OWN_BRANCH="own-${UPSTREAM_BRANCH}"

# Move to the correct branch.
git checkout $OWN_BRANCH
git pull

# Update the branch with upstream.
git fetch upstream
git merge upstream/$UPSTREAM_BRANCH --no-edit
git push
