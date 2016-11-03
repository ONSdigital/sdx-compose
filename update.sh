#!/bin/bash
export GIT_MERGE_AUTOEDIT=no

git reset --hard

find . -depth 1 -type d -name "sdx-*" | while read line; do git subtree pull --prefix ${line##*/} ${line##*/} master --squash; done
