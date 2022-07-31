#!/bin/sh

# Move to the correct branch.
git checkout own-nixos-22.05
git pull

# Update the branch with upstream.
git fetch upstream
git merge upstream/nixos-22.05 --no-edit
git push
