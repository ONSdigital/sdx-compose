#!/bin/bash
export GIT_MERGE_AUTOEDIT=no

git reset --hard

git subtree pull --prefix sdx-decrypt sdx-decrypt master --squash
git subtree pull --prefix sdx-collect sdx-collect master --squash
