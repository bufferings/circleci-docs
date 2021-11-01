#!/usr/bin/env bash

if [[ -d .git ]]; then
    git config blame.ignoreRevsFile .git-blame-ignore-revs && git submodule update --init
else
    echo "No .git file present. Post-install skipped."
fi